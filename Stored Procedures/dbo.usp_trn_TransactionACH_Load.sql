SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

CREATE PROC [dbo].[usp_trn_TransactionACH_Load]
	@pSettDate datetime
	,@pCurrency smallint
	,@pReload int = 0
AS
BEGIN
SET NOCOUNT ON

DECLARE @ErrMsg VARCHAR(MAX)

IF (@pReload = 1)
BEGIN
	UPDATE dbo.tbl_trn_TransactionConsolidated
	SET SettlementAllocationDate = NULL
	WHERE SettlementAllocationDate = @pSettDate
		AND CurrencyRequest = @pCurrency

	UPDATE dbo.tbl_trn_TransactionConsolidated
	SET SurchargeAllocationDate = NULL
	WHERE SurchargeAllocationDate = @pSettDate
		AND CurrencyRequest =@pCurrency

	UPDATE dbo.tbl_trn_TransactionConsolidated
	SET InterchangeAllocationDate = NULL
	WHERE InterchangeAllocationDate = @pSettDate
		AND CurrencyRequest = @pCurrency

	UPDATE t
	SET SettlementDate = NULL
	FROM dbo.tbl_ACHSchedule t
		JOIN dbo.tbl_BankAccount b(NOLOCK)
			ON t.SourceBankAccountId = b.Id
			AND b.Currency = CAST(@pCurrency AS bigint)
	WHERE SettlementDate = @pSettDate
END
ELSE IF EXISTS(SELECT TOP 1 1 FROM dbo.tbl_trn_TransactionACH t(NOLOCK) WHERE t.SettlementDate = @pSettDate AND t.Currency = @pCurrency)				
BEGIN
	SET @ErrMsg = 'The conlisolidated transactions and scheduled ACH of the given settlement date and currency have been allocated already.' + char(13) + char(10) 
			+ 'Set @Reload parameter to 1 if you want reallocation.'
	RAISERROR(@ErrMsg, 16, 1)

	RETURN
END

DECLARE @Year int
DECLARE @StartOfMarch datetime
DECLARE @StartOfNovember datetime 
DECLARE @DstStart datetime 
DECLARE @DstEnd datetime
DECLARE @SettlementDeviceOffDays int
DECLARE @SettlementHistoryDays int
SELECT TOP 1 @SettlementDeviceOffDays = CAST(Value AS int) FROM dbo.tbl_Parameter (NOLOCK) WHERE Name = 'SettlementDeviceOffDays'
SET @SettlementDeviceOffDays = ISNULL(@SettlementDeviceOffDays, 5)
SELECT TOP 1 @SettlementHistoryDays = CAST(Value AS int) FROM dbo.tbl_Parameter (NOLOCK) WHERE Name = 'SettlementHistoryDays'
SET @SettlementHistoryDays = ISNULL(@SettlementHistoryDays, 10)

------------------------------------------------------------------------------------------------------------------------
-- get all transactions to be settled -----------------------------------------------------------------------------------
IF OBJECT_ID('tempdb..#TempTransactionConsolidated') IS NOT NULL
BEGIN
	TRUNCATE TABLE #TempTransactionConsolidated
	DROP TABLE #TempTransactionConsolidated
END

SELECT 
	t.DeviceId
	,t.TransactionType
	,t.TransactionId
	,t.SystemTime
	,t.AmountSettlement
	,t.AmountSurcharge
	,t.TerminalName
	,t.CurrencyRequest
	,t.TransactionFlags
	,IssuerNetworkId = ISNULL(t.IssuerNetworkId, '')
	,t.SettlementAllocationDate
	,t.SurchargeAllocationDate
	,t.InterchangeAllocationDate
	,ApprWthCount = CAST(CASE WHEN t.AmountSettlement <> 0 AND t.TransactionType NOT IN (2, 3, 103, 4, 104, 5) THEN 1 ELSE 0 END AS int)
	,DeclWthCount = CAST(CASE WHEN t.AmountSettlement = 0 AND t.TransactionType NOT IN (2, 3, 103, 4, 104, 5) THEN 1 ELSE 0 END AS int)
	,ApprNFCount = CAST(CASE WHEN t.AmountSettlement <> 0 AND t.TransactionType IN (2, 3, 103, 4, 104, 5) THEN 1 ELSE 0 END AS int) -- INQ, TSF, DEP, STM
	,DeclNFCount = CAST(CASE WHEN t.AmountSettlement = 0 AND t.TransactionType IN (2, 3, 103, 4, 104, 5) THEN 1 ELSE 0 END AS int) -- INQ, TSF, DEP, STM
	,SurchargedCount = CAST(CASE WHEN t.AmountSurcharge <> 0 THEN  1 ELSE 0 END AS int)
INTO #TempTransactionConsolidated
FROM dbo.tbl_trn_TransactionConsolidated t(NOLOCK)
WHERE t.SettlementDate BETWEEN @pSettDate - @SettlementHistoryDays AND @pSettDate -- for performance
	AND t.CurrencyRequest = @pCurrency
	AND t.ResponseCodeInternal <> -99 
	AND (t.SettlementAllocationDate IS NULL -- not allocated
		OR t.SurchargeAllocationDate IS NULL 
		OR t.InterchangeAllocationDate IS NULL AND t.TransactionType IN (1, 101))



--SELECT * FROM #TempTransactionConsolidated
--SELECT * FROM #TempTransactionConsolidatedTrans
------------------------------------------------------------------------------------------------------------------------
-- get cutover time for each fund type ---------------------------------------------------------------------------------
SET @Year = DATEPART(YEAR, @pSettDate)
SET @StartOfMarch = DATEADD(MONTH, 2, DATEADD(YEAR, @year - 1900, 0))
SET @StartOfNovember = DATEADD(MONTH, 10, DATEADD(YEAR, @year - 1900, 0));
SET @DstStart = DATEADD(day, (( 15 - DATEPART(dw, @StartOfMarch) ) % 7 ) + 7, @StartOfMarch)
SET @DstEnd = DATEADD(day, (( 8 - DATEPART(dw, @StartOfNovember) ) % 7 ), @StartOfNovember)
--SELECT @DstStart, @DstEnd, @SettlementDeviceOffDays

IF OBJECT_ID('tempdb..#TempDayCloseTime') IS NOT NULL
BEGIN
	TRUNCATE TABLE #TempDayCloseTime
	DROP TABLE #TempDayCloseTime
END

SELECT
	d.DeviceId
	,co.FundsType
	,CutoverTimeUTC = 
		CASE 
			WHEN ISNULL(co.DepositExec, 0) = 0 THEN 
				DATEADD(MINUTE, ISNULL(co.CutoverOffset, 0),
				CASE
					WHEN d.CurrencyRequest = 124 AND @pSettDate >= @DstStart AND @pSettDate < @DstEnd -- DST
						THEN DATEADD(MINUTE, -(-300) - 60, DATEADD(HOUR, +21, @pSettDATE)) --9:00PM
					WHEN d.CurrencyRequest = 124
						THEN DATEADD(MINUTE, -(-300), DATEADD(HOUR, +21, @pSettDATE))
					WHEN d.CurrencyRequest = 840 AND @pSettDate >= @DstStart AND @pSettDate < @DstEnd -- DST
						THEN DATEADD(MINUTE, -(-300) - 60, DATEADD(HOUR, +25, @pSettDATE))
					WHEN d.CurrencyRequest = 840
						THEN DATEADD(MINUTE, -(-300), DATEADD(HOUR, +25, @pSettDATE)) 
					ELSE DATEADD(HOUR, 24, @pSettDate)
				END)
			ELSE ISNULL(dc.DayCloseTime, @pSettDATE - @SettlementDeviceOffDays + 1)
		END
INTO #TempDayCloseTime
FROM 
	(SELECT DISTINCT DeviceId, CurrencyRequest FROM #TempTransactionConsolidated (NOLOCK)) d
	LEFT JOIN dbo.tbl_DeviceCutoverOffset co(NOLOCK)
		ON d.DeviceId = co.DeviceId
	LEFT JOIN (SELECT dc.DeviceId, DayCloseTime = MAX(dc.ClosedDate) FROM dbo.tbl_DeviceDayClose dc(NOLOCK)
				WHERE dc.SettlementClosedDate = @pSettDate
				GROUP BY dc.DeviceId) dc
		ON d.DeviceId = dc.DeviceId

--SELECT * FROM #TempDayCloseTime
------------------------------------------------------------------------------------------------------------------------
-- Settlement Allocation -----------------------------------------------------------------------------------------------
IF OBJECT_ID('tempdb..#TempTransactionACHSettlementAlloc') IS NOT NULL
BEGIN
	TRUNCATE TABLE #TempTransactionACHSettlementAlloc
	DROP TABLE #TempTransactionACHSettlementAlloc
END
IF OBJECT_ID('tempdb..#TempTransactionACHSettlement') IS NOT NULL
BEGIN
	TRUNCATE TABLE #TempTransactionACHSettlement
	DROP TABLE #TempTransactionACHSettlement
END

SELECT 
	t.TransactionId
	,DatetimeSettlement = @pSettDate 
	,DateTimeClose = dc.CutoverTimeUTC
	,SourceType = 2
	,SourceCode = t.TerminalName
	,DeviceId = t.DeviceId
	,AccountId = ISNULL(ISNULL(ao1.BankAccountId, ao2.BankAccountId), a.BankAccountId)
	,FundsType = CASE
					WHEN t.TransactionType IN (1, 101, 2, 3, 103, 4, 104, 5, 105) THEN 'SETL' -- ATM SETTLEMENT
					WHEN t.TransactionType IN (7, 107, 8, 108, 9, 109, 10, 110, 11, 111, 12, 112) AND t.TransactionFlags & 524288 = 0 THEN 'SETD' -- POS DEBIT SETTLEMENT, 524288: Pinless
					ELSE 'SETC' -- POS CREDIT SETTLEMENT
				END
	,BaseTotal = CASE WHEN t.AmountSettlement<>0  THEN t.AmountSettlement - t.AmountSurcharge ELSE 0 END
	,Amount = CASE WHEN t.AmountSettlement<>0  THEN t.AmountSettlement - t.AmountSurcharge ELSE 0 END
	,t.ApprWthCount
	,t.DeclWthCount
	,t.ApprNFCount
	,t.DeclNFCount
	,t.SurchargedCount
INTO #TempTransactionACHSettlementAlloc
FROM #TempTransactionConsolidated t(NOLOCK)
	JOIN #TempDayCloseTime dc(NOLOCK)
		ON t.DeviceId = dc.DeviceId
		AND t.SystemTime <= dc.CutoverTimeUTC 
		AND dc.FundsType = 1 -- settlement
	JOIN dbo.tbl_DeviceToSettlementAccount a(NOLOCK)
		ON t.DeviceId = a.DeviceId
		AND t.SystemTime >= a.StartDate
		AND t.SystemTime < a.EndDate
	LEFT JOIN dbo.tbl_DeviceToSettlementAccountOverride ao1(NOLOCK) -- specific tran types
		ON t.DeviceId = ao1.DeviceId
		AND t.SystemTime >= ao1.StartDate
		AND t.SystemTime < ao1.EndDate
		AND t.TransactionType = CAST(ao1.OverrideData AS BIGINT)
		AND ao1.OverrideType = 1
		AND ao1.OverrideData <> N'0'
	LEFT JOIN dbo.tbl_DeviceToSettlementAccountOverride ao2(NOLOCK) -- all other tran types
		ON t.DeviceId = ao2.DeviceId
		AND t.SystemTime >= ao2.StartDate
		AND t.SystemTime < ao2.EndDate
		AND ao1.OverrideType = 1
		AND ao1.OverrideData = N'0'
WHERE t.SettlementAllocationDate IS NULL -- not allocated

SELECT DatetimeSettlement
	,DateTimeClose
	,SourceType
	,SourceCode 
	,DeviceId
	,AccountId
	,FundsType
	,BaseTotal = CAST(SUM(BaseTotal) AS money)
	,Amount = CAST(SUM(Amount) AS money)
	,ApprWthCount = SUM(ApprWthCount)
	,DeclWthCount = SUM(DeclWthCount)
	,ApprNFCount = SUM(ApprNFCount)
	,DeclNFCount = SUM(DeclNFCount)
	,SurchargedCount = SUM(SurchargedCount)
	,ACHDesc = CAST(NULL AS nvarchar(200))
INTO #TempTransactionACHSettlement
FROM #TempTransactionACHSettlementAlloc (NOLOCK)
GROUP BY DatetimeSettlement
	,DateTimeClose
	,SourceType
	,SourceCode 
	,DeviceId
	,AccountId
	,FundsType

--SELECT * FROM #TempTransactionACHSettlement
------------------------------------------------------------------------------------------------------------------------
-- Surcharge Allocation ------------------------------------------------------------------------------------------------
IF OBJECT_ID('tempdb..#TempTransactionACHSurchargeAlloc') IS NOT NULL
BEGIN
	TRUNCATE TABLE #TempTransactionACHSurchargeAlloc
	DROP TABLE #TempTransactionACHSurchargeAlloc
END
IF OBJECT_ID('tempdb..#TempTransactionACHSurchargeSplitRemainderAlloc') IS NOT NULL
BEGIN
	TRUNCATE TABLE #TempTransactionACHSurchargeSplitRemainderAlloc
	DROP TABLE #TempTransactionACHSurchargeSplitRemainderAlloc
END
IF OBJECT_ID('tempdb..#TempTransactionACHSurcharge') IS NOT NULL
BEGIN
	TRUNCATE TABLE #TempTransactionACHSurcharge
	DROP TABLE #TempTransactionACHSurcharge
END
IF OBJECT_ID('tempdb..#TempTransactionACHSurchargeTrans') IS NOT NULL
BEGIN
	TRUNCATE TABLE #TempTransactionACHSurchargeTrans
	DROP TABLE #TempTransactionACHSurchargeTrans
END

SELECT DISTINCT
	t.TransactionId
	,DatetimeSettlement = @pSettDate 
	,DateTimeClose = dc.CutoverTimeUTC
	,SourceType = 2
	,SourceCode = t.TerminalName
	,t.DeviceId
	,AccountId = ISNULL(ISNULL(ISNULL(aot1.BankAccountId, aot2.BankAccountId), aon.BankAccountId), a.BankAccountId)
	,FundsType = 
		CASE
			WHEN t.TransactionType IN (1, 101, 2, 3, 103, 4, 104, 5, 105) THEN 'SRCH' -- ATM SURCHARGE
			WHEN t.TransactionType IN (7, 107, 8, 108, 9, 109, 10, 110, 11, 111, 12, 112) AND t.TransactionFlags & 524288 = 0 THEN 'SRCD' -- POS DEBIT SURCHARGE, 524288: Pinless
			ELSE 'SRCC' -- POS CREDIT SURCHARGE
		END
	,BaseTotal = CASE WHEN t.AmountSettlement<>0  THEN t.AmountSurcharge ELSE 0 END
	,Amount = CASE 
					WHEN ISNULL(ISNULL(ISNULL(aot1.SplitType, aot2.SplitType), aon.SplitType), a.SplitType) = 0 
						THEN (CASE WHEN t.AmountSettlement<>0  THEN t.AmountSurcharge ELSE 0 END) 
							* (CAST(ISNULL(ISNULL(ISNULL(aot1.SplitData, aot2.SplitData), aon.SplitData), a.SplitData) AS int)) / 1000000.00 -- percentage
					WHEN ISNULL(ISNULL(ISNULL(aot1.SplitType, aot2.SplitType), aon.SplitType), a.SplitType) = 1 
						THEN (CAST(ISNULL(ISNULL(ISNULL(aot1.SplitData, aot2.SplitData), aon.SplitData), a.SplitData) AS money)) / 100.00
					ELSE CAST(0.00 AS money)
				END
	,t.ApprWthCount
	,t.DeclWthCount
	,t.ApprNFCount
	,t.DeclNFCount
	,t.SurchargedCount
	,SplitType = ISNULL(ISNULL(ISNULL(aot1.SplitType, aot2.SplitType), aon.SplitType), a.SplitType)
INTO #TempTransactionACHSurchargeAlloc
FROM #TempTransactionConsolidated t(NOLOCK)
	JOIN #TempDayCloseTime dc(NOLOCK)
		ON t.DeviceId = dc.DeviceId
		AND t.SystemTime <= dc.CutoverTimeUTC 
		AND dc.FundsType = 2 -- surcharge
	JOIN dbo.tbl_DeviceToSurchargeSplitAccount a(NOLOCK)
		ON t.DeviceId = a.DeviceId
		AND t.SystemTime >= a.StartDate
		AND t.SystemTime < a.EndDate
	LEFT JOIN dbo.tbl_DeviceToSurchargeSplitAccountOverride aot1(NOLOCK) -- overrided by specific transaction types
		ON t.DeviceId = aot1.DeviceId
		AND t.SystemTime >= aot1.StartDate
		AND t.SystemTime < aot1.EndDate
		AND t.TransactionType= CAST(aot1.OverrideData AS BIGINT) 
		AND aot1.OverrideType = 1  
		AND aot1.OverrideData <> N'0'
	LEFT JOIN dbo.tbl_DeviceToSurchargeSplitAccountOverride aot2(NOLOCK) -- overrided by all transaction types
		ON t.DeviceId = aot2.DeviceId
		AND t.SystemTime >= aot2.StartDate
		AND t.SystemTime < aot2.EndDate
		AND aot2.OverrideType = 1  
		AND aot2.OverrideData = N'0'
	LEFT JOIN dbo.tbl_InterchangeNetwork nw(NOLOCK)
		ON t.IssuerNetworkId = nw.NetworkCode
	LEFT JOIN dbo.tbl_DeviceToSurchargeSplitAccountOverride aon(NOLOCK) -- overrided by network
		ON t.DeviceId = aon.DeviceId
		AND t.SystemTime >= aon.StartDate
		AND t.SystemTime < aon.EndDate
		AND aon.OverrideType = 2  
		AND nw.GroupCode = aon.OverrideData
WHERE t.SurchargeAllocationDate IS NULL -- not allocated

SELECT 
	t.TransactionId
	,t.DatetimeSettlement
	,t.DateTimeClose
	,t.SourceType
	,t.SourceCode 
	,t.DeviceId
	,t.AccountId
	,t.FundsType
	,t.BaseTotal
	,Amount = t.BaseTotal - ISNULL(SUM(s.Amount), 0)
	,t.ApprWthCount
	,t.DeclWthCount
	,t.ApprNFCount
	,t.DeclNFCount
	,t.SurchargedCount
	,t.SplitType
INTO #TempTransactionACHSurchargeSplitRemainderAlloc
FROM  #TempTransactionACHSurchargeAlloc t(NOLOCK)
	LEFT JOIN #TempTransactionACHSurchargeAlloc s(NOLOCK)
		ON t.TransactionId = s.TransactionId
		AND s.SplitType IN (0, 1)
WHERE t.SplitType = 2 -- remainders
GROUP BY 
	t.TransactionId
	,t.DatetimeSettlement
	,t.DateTimeClose
	,t.SourceType
	,t.SourceCode 
	,t.DeviceId
	,t.AccountId
	,t.FundsType
	,t.BaseTotal
	,t.ApprWthCount
	,t.DeclWthCount
	,t.ApprNFCount
	,t.DeclNFCount
	,t.SurchargedCount
	,t.SplitType


SELECT DatetimeSettlement
	,DateTimeClose
	,SourceType
	,SourceCode 
	,DeviceId
	,AccountId
	,FundsType
	,BaseTotal = CAST(SUM(BaseTotal) AS money)
	,Amount = CAST(SUM(Amount) AS money)
	,ApprWthCount = SUM(ApprWthCount)
	,DeclWthCount = SUM(DeclWthCount)
	,ApprNFCount = SUM(ApprNFCount)
	,DeclNFCount = SUM(DeclNFCount)
	,SurchargedCount = SUM(SurchargedCount)
	,ACHDesc = CAST(NULL AS nvarchar(200))
INTO #TempTransactionACHSurcharge
FROM (SELECT * FROM #TempTransactionACHSurchargeAlloc (NOLOCK) WHERE SplitType IN (0, 1)
	UNION ALL 
	SELECT * FROM #TempTransactionACHSurchargeSplitRemainderAlloc (NOLOCK)) a
GROUP BY DatetimeSettlement
	,DateTimeClose
	,SourceType
	,SourceCode 
	,DeviceId
	,AccountId
	,FundsType

SELECT DISTINCT TransactionId 
INTO #TempTransactionACHSurchargeTrans
FROM  #TempTransactionACHSurchargeAlloc(NOLOCK)

IF OBJECT_ID('tempdb..#TempTransactionACHSurchargeAlloc') IS NOT NULL
BEGIN
	TRUNCATE TABLE #TempTransactionACHSurchargeAlloc
	DROP TABLE #TempTransactionACHSurchargeAlloc
END
IF OBJECT_ID('tempdb..#TempTransactionACHSurchargeSplitRemainderAlloc') IS NOT NULL
BEGIN
	TRUNCATE TABLE #TempTransactionACHSurchargeSplitRemainderAlloc
	DROP TABLE #TempTransactionACHSurchargeSplitRemainderAlloc
END

------------------------------------------------------------------------------------------------------------------------
-- Interchange Allocation ----------------------------------------------------------------------------------------------
IF OBJECT_ID('tempdb..#TempInterchangeSchemeSignatureAmount') IS NOT NULL
BEGIN
	TRUNCATE TABLE #TempInterchangeSchemeSignatureAmount
	DROP TABLE #TempInterchangeSchemeSignatureAmount
END
IF OBJECT_ID('tempdb..#TempTransactionACHInterchangeAlloc') IS NOT NULL
BEGIN
	TRUNCATE TABLE #TempTransactionACHInterchangeAlloc
	DROP TABLE #TempTransactionACHInterchangeAlloc
END
IF OBJECT_ID('tempdb..#TempTransactionACHInterchangeSplitRemainderAlloc') IS NOT NULL
BEGIN
	TRUNCATE TABLE #TempTransactionACHInterchangeSplitRemainderAlloc
	DROP TABLE #TempTransactionACHInterchangeSplitRemainderAlloc
END
IF OBJECT_ID('tempdb..#TempTransactionACHInterchange') IS NOT NULL
BEGIN
	TRUNCATE TABLE #TempTransactionACHInterchange
	DROP TABLE #TempTransactionACHInterchange
END
IF OBJECT_ID('tempdb..#TempTransactionACHInterchangeTrans') IS NOT NULL
BEGIN
	TRUNCATE TABLE #TempTransactionACHInterchangeTrans
	DROP TABLE #TempTransactionACHInterchangeTrans
END

SELECT
	t.DeviceId
	,t.IssuerNetworkId
	,t.TransactionType
	,sga.Recipient
	,AmountApproval = CAST(sga.AmountApproval / 100.0 AS money)
	,AmountDeclined = CAST(sga.AmountDeclined / 100.0 AS money)
INTO #TempInterchangeSchemeSignatureAmount
FROM (SELECT DISTINCT DeviceId, IssuerNetworkId, TransactionType FROM #TempTransactionConsolidated(NOLOCK) 
		WHERE InterchangeAllocationDate IS NULL
			AND TransactionType IN (1, 101)) t
	JOIN dbo.tbl_DeviceToInterchangeScheme d2s(NOLOCK)
		ON t.DeviceId = d2s.DeviceId
	LEFT JOIN dbo.tbl_InterchangeSchemeSignature sig1(NOLOCK) -- specific network and specific tran type
		ON sig1.InterchangeSchemeId = d2s.InterchangeSchemeId
		AND sig1.IssuerNetworkId <> N'ALL' 
		AND sig1.TransactionType <> 0
		AND sig1.IssuerNetworkId = t.IssuerNetworkId
		AND sig1.TransactionType = t.TransactionType
	LEFT JOIN dbo.tbl_InterchangeSchemeSignature sig2(NOLOCK) -- specific network and all tran types
		ON sig2.InterchangeSchemeId = d2s.InterchangeSchemeId
		AND sig2.IssuerNetworkId <> N'ALL' 
		AND sig2.TransactionType = 0
		AND sig2.IssuerNetworkId = t.IssuerNetworkId
	LEFT JOIN dbo.tbl_InterchangeSchemeSignature sig3(NOLOCK) -- all networks and specific tran types
		ON sig3.InterchangeSchemeId = d2s.InterchangeSchemeId
		AND sig3.IssuerNetworkId = N'ALL' 
		AND sig3.TransactionType <> 0
		AND sig3.TransactionType = t.TransactionType
	LEFT JOIN dbo.tbl_InterchangeSchemeSignature sig4(NOLOCK) -- all networks and all tran types
		ON sig4.InterchangeSchemeId = d2s.InterchangeSchemeId
		AND sig4.IssuerNetworkId = N'ALL' 
		AND sig4.TransactionType = 0
	JOIN dbo.tbl_InterchangeSchemeSignatureAmount sga(NOLOCK)
		ON sga.InterchangeSchemeSignatureId = ISNULL(ISNULL(ISNULL(sig1.Id, sig2.Id), sig3.Id), sig4.Id)

SELECT 
	t.TransactionId
	,DateTimeSettlement = @pSettDate
	,DateTimeClose = dc.CutoverTimeUTC
	,SourceType = 2
	,SourceCode = t.TerminalName
	,t.DeviceId
	,AccountID = isa.BankAccountId
	,FundsType = 'INTR'
	,BaseTotal = CASE WHEN t.AmountSettlement <> 0 THEN sga.AmountApproval ELSE sga.AmountDeclined END
	,Amount = CASE 
				WHEN isa.SplitType = 0 THEN (CASE WHEN t.AmountSettlement <> 0 THEN sga.AmountApproval ELSE sga.AmountDeclined END) * isa.SplitData / 1000000.00 -- percentage
				WHEN isa.SplitType = 1 THEN CAST(isa.SplitData AS money) / 100.00
				ELSE CAST(0.00 AS money)
			END
	,t.ApprWthCount
	,t.DeclWthCount
	,t.ApprNFCount
	,t.DeclNFCount
	,t.SurchargedCount
	,SplitType = isa.SplitType
	,sga.Recipient
INTO #TempTransactionACHInterchangeAlloc
FROM #TempTransactionConsolidated t(NOLOCK)
	JOIN #TempDayCloseTime dc(NOLOCK)
		ON t.DeviceId = dc.DeviceId
		AND t.SystemTime <= dc.CutoverTimeUTC 
		AND dc.FundsType = 3 -- interchange
	JOIN #TempInterchangeSchemeSignatureAmount sga(NOLOCK)
		ON t.DeviceId = sga.DeviceId
		AND t.IssuerNetworkId = sga.IssuerNetworkId
		AND t.TransactionType = sga.TransactionType
	JOIN dbo.tbl_DeviceToInterchangeSplitAccount isa(NOLOCK)
		ON t.DeviceId = isa.DeviceId
		AND sga.Recipient = isa.Recipient
		AND t.SystemTime >= isa.StartDate
		AND t.SystemTime < isa.EndDate
WHERE 
	t.InterchangeAllocationDate IS NULL
	AND t.TransactionType IN (1, 101) -- Withdrawal and its Reversal only

SELECT 
	t.TransactionId
	,t.DatetimeSettlement
	,t.DateTimeClose
	,t.SourceType
	,t.SourceCode 
	,t.DeviceId
	,t.AccountId
	,t.FundsType
	,t.BaseTotal
	,Amount = t.BaseTotal - ISNULL(SUM(s.Amount), 0)
	,t.ApprWthCount
	,t.DeclWthCount
	,t.ApprNFCount
	,t.DeclNFCount
	,t.SurchargedCount
	,t.SplitType
	,t.Recipient
INTO #TempTransactionACHInterchangeSplitRemainderAlloc
FROM  #TempTransactionACHInterchangeAlloc t(NOLOCK)
	LEFT JOIN #TempTransactionACHInterchangeAlloc s(NOLOCK)
		ON t.TransactionId = s.TransactionId
		AND t.Recipient = s.Recipient
		AND s.SplitType IN (0, 1)
WHERE t.SplitType = 2 -- remainders
GROUP BY 
	t.TransactionId
	,t.DatetimeSettlement
	,t.DateTimeClose
	,t.SourceType
	,t.SourceCode 
	,t.DeviceId
	,t.AccountId
	,t.FundsType
	,t.BaseTotal
	,t.ApprWthCount
	,t.DeclWthCount
	,t.ApprNFCount
	,t.DeclNFCount
	,t.SurchargedCount
	,t.SplitType
	,t.Recipient

SELECT DatetimeSettlement
	,DateTimeClose
	,SourceType
	,SourceCode 
	,DeviceId
	,AccountId
	,FundsType
	,BaseTotal = CAST(SUM(BaseTotal) AS money)
	,Amount = CAST(SUM(Amount) AS money)
	,ApprWthCount = SUM(ApprWthCount)
	,DeclWthCount = SUM(DeclWthCount)
	,ApprNFCount = SUM(ApprNFCount)
	,DeclNFCount = SUM(DeclNFCount)
	,SurchargedCount = SUM(SurchargedCount)
	,ACHDesc = CAST(NULL AS nvarchar(200))
INTO #TempTransactionACHInterchange
FROM (SELECT * FROM #TempTransactionACHInterchangeAlloc (NOLOCK) WHERE SplitType IN (0, 1)
	UNION ALL 
	SELECT * FROM #TempTransactionACHInterchangeSplitRemainderAlloc (NOLOCK)) a
GROUP BY DatetimeSettlement
	,DateTimeClose
	,SourceType
	,SourceCode 
	,DeviceId
	,AccountId
	,FundsType

SELECT DISTINCT TransactionId 
INTO #TempTransactionACHInterchangeTrans
FROM  #TempTransactionACHInterchangeAlloc(NOLOCK)


--SELECT * FROM #TempTransactionACHInterchangeAlloc
--SELECT * FROM #TempTransactionACHInterchangeSplitRemainderAlloc
--SELECT * FROM #TempTransactionACHInterchange
--SELECT * FROM #TempTransactionACHInterchangeTrans
IF OBJECT_ID('tempdb..#TempInterchangeSchemeSignatureAmount') IS NOT NULL
BEGIN
	TRUNCATE TABLE #TempInterchangeSchemeSignatureAmount
	DROP TABLE #TempInterchangeSchemeSignatureAmount
END
IF OBJECT_ID('tempdb..#TempTransactionACHInterchangeAlloc') IS NOT NULL
BEGIN
	TRUNCATE TABLE #TempTransactionACHInterchangeAlloc
	DROP TABLE #TempTransactionACHInterchangeAlloc
END
IF OBJECT_ID('tempdb..#TempTransactionACHInterchangeSplitRemainderAlloc') IS NOT NULL
BEGIN
	TRUNCATE TABLE #TempTransactionACHInterchangeSplitRemainderAlloc
	DROP TABLE #TempTransactionACHInterchangeSplitRemainderAlloc
END
IF OBJECT_ID('tempdb..#TempDayCloseTime') IS NOT NULL
BEGIN
	TRUNCATE TABLE #TempDayCloseTime
	DROP TABLE #TempDayCloseTime
END
--------------------------------------------------------------------------------------------------------------
-- Scheduled ACH ---------------------------------------------------------------------------------------------
IF OBJECT_ID('tempdb..#TempTransactionACHScheduled') IS NOT NULL
BEGIN
	TRUNCATE TABLE #TempTransactionACHScheduled
	DROP TABLE #TempTransactionACHScheduled
END
IF OBJECT_ID('tempdb..#TempTransactionACHScheduledTax') IS NOT NULL
BEGIN
	TRUNCATE TABLE #TempTransactionACHScheduledTax
	DROP TABLE #TempTransactionACHScheduledTax
END

SELECT 
	TransactionId = s.Id
	,DateTimeSettlement = @pSettDate
	,DateTimeClose = @pSettDate
	,SourceType = s.SourceType
	,SourceCode = ISNULL(ISNULL(d.TerminalName, u.UserName), CAST(s.SourceId AS VARCHAR(20)))
	,DeviceId = d.Id
	,AccountID = CASE WHEN f.FundsType = 1 THEN s.DestinationBankAccountId ELSE s.SourceBankAccountId END
	,FundsType = CASE WHEN f.FundsType = 1 THEN 'ADJC' ELSE 'ADJD' END -- adjustment credit or debit
	,BaseTotal = CAST(s.Amount * f.FundsType AS money)
	,Amount = CAST(s.Amount * f.FundsType AS money)
	,StandardEntryCode = CASE WHEN s.StandardEntryClassCode = 'N/A' OR LTRIM(RTRIM(s.StandardEntryClassCode)) = '' THEN 'CCD' ELSE s.StandardEntryClassCode END
	,BatchHeader = CASE
						WHEN s.BatchHeader IS NULL OR LTRIM(RTRIM(s.BatchHeader)) = '' THEN 'SETTLEMENT' 
						ELSE s.BatchHeader
					END
	,ACHDesc = s.AchScheduleStatus
	,TaxList = s.TaxList
	,DeviceAddressId = d.AddressId
	,UserIsoId = u.IsoId
INTO #TempTransactionACHScheduled
FROM dbo.tbl_ACHSchedule  s(NOLOCK)
	LEFT JOIN dbo.tbl_Device d(NOLOCK)
		ON s.SourceType = 2 -- terminal
		AND s.SourceId = d.Id
	LEFT JOIN dbo.tbl_upm_User u(NOLOCK)
		ON s.SourceType = 1
		AND s.SourceId = u.Id
	CROSS JOIN (
		SELECT FundsType = -1 
		UNION ALL SELECT FundsType = 1) f
	JOIN dbo.tbl_BankAccount b(NOLOCK)
		ON b.Id = CASE WHEN f.FundsType = 1 THEN s.DestinationBankAccountId ELSE s.SourceBankAccountId END
		AND b.Currency = CAST(@pCurrency AS bigint)
WHERE s.AchScheduleStatus = 1 -- enabled
	AND ((s.ScheduleType = 1 -- 1:daily, 2:weekly, 3:monthly, 4: once
			OR s.ScheduleType = 2 AND s.ScheduleDay = DATEPART(weekday, @pSettDate) 
			OR s.ScheduleType = 3 AND s.ScheduleDay = DATEPART(day, @pSettDate)) AND @pSettDate BETWEEN s.StartDate AND s.EndDate
		OR s.ScheduleType = 4 AND s.SettlementDate IS NULL)


SELECT 
	s.TransactionId
	,s.DateTimeSettlement
	,s.DateTimeClose
	,s.SourceType
	,s.SourceCode
	,s.DeviceId
	,s.AccountID
	,FundsType =  CASE WHEN s.Amount > 0 THEN 'ADTC' ELSE 'ADTD' END -- adjustment credit or debit tax
	,BaseTotal = CAST(s.BaseTotal * t.TaxPercent AS money)
	,Amount = CAST(s.Amount * t.TaxPercent AS money)
	,s.StandardEntryCode
	,s.BatchHeader
	,s.ACHDesc
	,s.TaxList
	,s.DeviceAddressId
	,s.UserIsoId
INTO #TempTransactionACHScheduledTax
FROM #TempTransactionACHScheduled s(NOLOCK)
    LEFT JOIN dbo.tbl_IsoAddress i(NOLOCK)
		ON s.UserIsoId = i.IsoId
    LEFT JOIN dbo.tbl_Address a(NOLOCK) 
		ON ISNULL(s.DeviceAddressId, i.AddressId) = a.Id
    JOIN dbo.tbl_RegionTax t(NOLOCK)
		ON a.RegionId = t.RegionId
		AND s.TaxList = t.TaxName


--------------------------------------------------------------------------------------------------------------
-- Finalize the data -----------------------------------------------------------------------------------------
DELETE FROM dbo.tbl_trn_TransactionACH
WHERE SettlementDate = @PSettDate
	AND Currency = @pCurrency

INSERT INTO dbo.tbl_trn_TransactionACH
(
	SettlementDate
	,DateTimeClose
	,SourceType
	,SourceCode 
	,DeviceId
	,AccountId
	,FundsType
	,BaseTotal
	,Amount
	,ApprWthCount
	,DeclWthCount
	,ApprNFCount
	,DeclNFCount
	,SurchargedCount
	,ACHDesc
	,StandardEntryCode
	,BatchHeader
	,Currency 
)
SELECT *,StandardEntryCode=NULL,BatchHeader=NULL,Currency = @pCurrency FROM #TempTransactionACHSettlement (NOLOCK)
UNION ALL 
SELECT *,StandardEntryCode=NULL,BatchHeader=NULL,Currency = @pCurrency FROM #TempTransactionACHSurcharge (NOLOCK)
UNION ALL 
SELECT *,StandardEntryCode=NULL,BatchHeader=NULL,Currency = @pCurrency FROM #TempTransactionACHInterchange (NOLOCK) 
UNION ALL 
SELECT DatetimeSettlement
	,DateTimeClose
	,SourceType
	,SourceCode 
	,DeviceId
	,AccountId
	,FundsType
	,BaseTotal = SUM(BaseTotal)
	,Amount = SUM(Amount)
	,ApprWthCount = 0
	,DeclWthCount = 0
	,ApprNFCount = 0
	,DeclNFCount = 0
	,SurchargedCount = 0
	,ACHDesc = MAX(ACHDesc)
	,StandardEntryCode = MAX(StandardEntryCode)
	,BatchHeader = MAX(BatchHeader)
	,Currency = @pCurrency
FROM (SELECT * FROM #TempTransactionACHScheduled (NOLOCK)
	UNION ALL
	SELECT * FROM #TempTransactionACHScheduledTax (NOLOCK)) a
GROUP BY DatetimeSettlement
	,DateTimeClose
	,SourceType
	,SourceCode 
	,DeviceId
	,AccountId
	,FundsType	


UPDATE t
SET SettlementAllocationDate = @pSettDate
FROM dbo.tbl_trn_TransactionConsolidated t
	JOIN  #TempTransactionACHSettlementAlloc a(NOLOCK)
		ON t.TransactionId = a.TransactionID

UPDATE t
SET SurchargeAllocationDate = @pSettDate
FROM dbo.tbl_trn_TransactionConsolidated t
	JOIN  #TempTransactionACHSurchargeTrans a(NOLOCK)
		ON t.TransactionId = a.TransactionID

UPDATE t
SET InterchangeAllocationDate = @pSettDate
FROM dbo.tbl_trn_TransactionConsolidated t
	JOIN  #TempTransactionACHInterchangeTrans a(NOLOCK)
		ON t.TransactionId = a.TransactionID
	
UPDATE t
SET SettlementDate = @pSettDate
FROM dbo.tbl_ACHSchedule t
	JOIN (SELECT DISTINCT TransactionId FROM #TempTransactionACHScheduled (NOLOCK)) s 
		ON t.Id = s.TransactionId

--SELECT * FROM  dbo.tbl_trn_TransactionACH
--------------------------------------------------------------------------------------------------------------
-- Clean up --------------------------------------------------------------------------------------------------
IF OBJECT_ID('tempdb..#TempTransactionConsolidated') IS NOT NULL
BEGIN
	TRUNCATE TABLE #TempTransactionConsolidated
	DROP TABLE #TempTransactionConsolidated
END
IF OBJECT_ID('tempdb..#TempTransactionACHSettlementAlloc') IS NOT NULL
BEGIN
	TRUNCATE TABLE #TempTransactionACHSettlementAlloc
	DROP TABLE #TempTransactionACHSettlementAlloc
END
IF OBJECT_ID('tempdb..#TempTransactionACHSettlement') IS NOT NULL
BEGIN
	TRUNCATE TABLE #TempTransactionACHSettlement
	DROP TABLE #TempTransactionACHSettlement
END
IF OBJECT_ID('tempdb..#TempTransactionACHSurcharge') IS NOT NULL
BEGIN
	TRUNCATE TABLE #TempTransactionACHSurcharge
	DROP TABLE #TempTransactionACHSurcharge
END
IF OBJECT_ID('tempdb..#TempTransactionACHSurchargeTrans') IS NOT NULL
BEGIN
	TRUNCATE TABLE #TempTransactionACHSurchargeTrans
	DROP TABLE #TempTransactionACHSurchargeTrans
END
IF OBJECT_ID('tempdb..#TempTransactionACHInterchange') IS NOT NULL
BEGIN
	TRUNCATE TABLE #TempTransactionACHInterchange
	DROP TABLE #TempTransactionACHInterchange
END
IF OBJECT_ID('tempdb..#TempTransactionACHInterchangeTrans') IS NOT NULL
BEGIN
	TRUNCATE TABLE #TempTransactionACHInterchangeTrans
	DROP TABLE #TempTransactionACHInterchangeTrans
END

END
GO
GRANT EXECUTE ON  [dbo].[usp_trn_TransactionACH_Load] TO [WebV4Role]
GO
