SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

/*

SELECT * FROM dbo.tbl_rec_TransactionACIImport
SELECT * FROM dbo.tbl_rec_TransactionACI
EXEC dbo.usp_rec_TransactionACI_MatchAndKill '2015-04-19', 124

SELECT * FROM dbo.tbl_trn_TransactionConsolidated WHERE SettlementDate = '2015-04-19' AND DestCode BETWEEN 10 AND 29
SELECT * FROM dbo.tbl_trn_TransactionConsolidated WHERE SettlementDate = '2015-04-19' AND DestCode BETWEEN 10 AND 29 AND ReconciliationStatus = 1
SELECT * FROM dbo.tbl_trn_TransactionConsolidated WHERE SettlementDate = '2015-04-19' AND DestCode BETWEEN 10 AND 29 AND ReconciliationStatus = 3
SELECT * FROM dbo.tbl_trn_TransactionConsolidated WHERE SettlementDate = '2015-04-19' AND DestCode BETWEEN 10 AND 29 AND ReconciliationStatus = 2  AND ResponseCodeInternal <> -99 AND DeviceID = 4235
SELECT * FROM dbo.tbl_rec_TransactionACI where DateTimeSettlement = '2015-04-19' AND TerminalID = (SELECT TerminalName from dbo.tbl_device where id = 4235)

*/

CREATE PROCEDURE [dbo].[usp_rec_TransactionACI_MatchAndKill]
	@pSettDate datetime
	,@pCurrency smallint = 124
AS
BEGIN
SET NOCOUNT ON

IF OBJECT_ID('tempdb..#TermpTransactionACIConsolidated') IS NOT NULL
BEGIN
	TRUNCATE TABLE #TermpTransactionACIConsolidated
	DROP TABLE #TermpTransactionACIConsolidated
END

IF NOT EXISTS(SELECT TOP 1 1 FROM dbo.tbl_trn_TransactionConsolidated (NOLOCK) WHERE SettlementDate = @pSettDate AND CurrencyRequest = @pCurrency)
BEGIN
	EXEC dbo.usp_trn_TransactionConsolidated_Load @pSettDate, @pCurrency, 0
END


DELETE FROM dbo.tbl_trn_TransactionConsolidated
WHERE SettlementDate = @pSettDate
	AND CurrencyRequest = @pCurrency
	AND DestCode BETWEEN 10 AND 29
	AND ResponseCodeInternal = -99

UPDATE dbo.tbl_trn_TransactionConsolidated
SET AmountGatewayDebit = NULL
	,AmountInterchangeCollected = NULL
	,AmountGatewayProcFee = NULL
	,ReconciliationStatus = 1
	,UnreconciledStatus = NULL
	,ReconciliationComment = NULL
WHERE SettlementDate = @pSettDate
	AND CurrencyRequest = @pCurrency
	AND DestCode BETWEEN 10 AND 29


SELECT 
	t.DateTimeSettlement
	,t.IntMsgTermID
	,IntMsgSeqNum = CONVERT(int, RIGHT(t.IntMsgSeqNum, 6))
	,t.IntMsgTranDateTime
	,PAN = MAX(t.PAN_Last4)
	,TransactionType = MAX(CASE WHEN r.IntMsgTermID IS NULL THEN 1 ELSE 101 END) -- WTH/RWT
	,AmountRequested = MAX(t.IntMsgAmount1)
	,AmountSettlement = MAX(CASE 
							WHEN t.ExtMsgRespCode NOT LIKE '00%' THEN CONVERT(money, 0)
							ELSE ISNULL(r.IntMsgAmount2, t.IntMsgAmount1)
						END)

	,Bae24RespCode = MAX(ISNULL(CONVERT(varchar(4), LEFT(t.ExtMsgRespCode, 2)), '-99'))
	--,*
INTO #TermpTransactionACIConsolidated
FROM dbo.tbl_rec_TransactionACI t(NOLOCK)
	LEFT JOIN dbo.tbl_rec_TransactionACI r(NOLOCK)
		ON t.DateTimeSettlement = r.DateTimeSettlement
		AND t.IntMsgTermID = r.IntMsgTermID
		AND t.IntMsgSeqNum = r.IntMsgSeqNum
		AND t.IntMsgTranDateTime = r.IntMsgTranDateTime
		AND r.ExtMsgType IN ('0420', '0430')
		AND r.DateTimeSettlement = @pSettDate
		AND r.Currency = @pCurrency
WHERE t.ExtMsgType LIKE '02%'
	AND t.DateTimeSettlement = @pSettDate
	AND t.Currency = @pCurrency
	AND t.IntMsgTermID <> ''
GROUP BY 
	t.DateTimeSettlement
	,t.IntMsgTermID
	,CONVERT(int, RIGHT(t.IntMsgSeqNum, 6))
	,t.IntMsgTranDateTime


-- reconciliation
;WITH tgt AS
(
	SELECT 
		SettlementDate
		,DeviceId
		,DeviceDate
		,DeviceSequence
		,TransactionType
		,TransactionId
		,SystemTime
		,NetworkSequence
		,BINRange
		,PAN
		,ResponseCodeInternal
		,NetworkId
		,DestCode
		,AmountRequest
		,AmountSettlement
		,AmountSurcharge
		,AmountGatewayDebit
		,AmountInterchangeCollected
		,AmountGatewayProcFee
		,TerminalName
		,CurrencyRequest
		,ReconciliationStatus	
		,UnreconciledStatus
		,ReconciliationComment
		,SettlementAllocationDate
		,SurchargeAllocationDate 
		,InterchangeAllocationDate
	FROM dbo.tbl_trn_TransactionConsolidated
	WHERE SettlementDate = @pSettDate
		AND CurrencyRequest = @pCurrency
		AND DestCode BETWEEN 10 AND 29
)
MERGE INTO tgt
USING #TermpTransactionACIConsolidated src
	ON tgt.SettlementDate = src.DateTimeSettlement
	AND tgt.TerminalName = src.IntMsgTermID
	AND tgt.NetworkSequence = src.IntMsgSeqNum
	AND tgt.DeviceDate = src.IntMsgTranDateTime
WHEN NOT MATCHED BY TARGET 
	AND src.Bae24RespCode = '00'
	AND EXISTS (SELECT TOP 1 Id FROM dbo.tbl_Device (NOLOCK) WHERE TerminalName = src.IntMsgTermID) THEN
	--THEN
	INSERT
	(
		SettlementDate
		,DeviceId
		,DeviceDate
		,DeviceSequence
		,TransactionType
		,TransactionId
		,SystemTime
		,NetworkSequence
		,BINRange
		,PAN
		,ResponseCodeInternal
		,NetworkId
		,DestCode
		,AmountRequest
		,AmountSettlement
		,AmountSurcharge
		,AmountGatewayDebit
		,AmountInterchangeCollected
		,AmountGatewayProcFee
		,TerminalName
		,CurrencyRequest
		,ReconciliationStatus	
		,UnreconciledStatus
		,ReconciliationComment
		,SettlementAllocationDate
		,SurchargeAllocationDate 
		,InterchangeAllocationDate
	)
	VALUES
	(
		src.DateTimeSettlement -- SettlementDate
		,ISNULL((SELECT TOP 1 Id FROM dbo.tbl_Device (NOLOCK) WHERE TerminalName = src.IntMsgTermID) ,0) -- DeviceId
		,src.IntMsgTranDateTime -- DeviceDate
		,src.IntMsgSeqNum -- DeviceSequence
		,src.TransactionType -- TransactionType
		,0 -- TransactionId
		,src.IntMsgTranDateTime -- SystemTime
		,src.IntMsgSeqNum -- NetworkSequence
		,'' -- BINRange
		,src.PAN -- PAN
		,-99 -- ResponseCodeInternal 
		,-1 --NetworkId
		,10 -- DestCode
		,src.AmountRequested -- AmountRequest
		,0 -- AmountSettlement
		,0 -- AmountSurcharge
		,src.AmountSettlement -- AmountGatewayDebit
		,CONVERT(money, 0.75) -- AmountInterchangeCollected
		,0-- AmountGatewayProcFee
		,src.IntMsgTermID -- TerminalName
		,@pCurrency -- CurrencyRequest 
		,2 -- ReconciliationStatus -- not reconciled	
		,1 -- UnreconciledStatus -- gateway approved but SA no match
		,NULL -- ReconciliationComment
		,NULL -- SettlementAllocationDate
		,NULL -- SurchargeAllocationDate 
		,NULL -- InterchangeAllocationDate
	)
WHEN NOT MATCHED BY SOURCE THEN
	UPDATE SET 
		tgt.ReconciliationStatus = CASE WHEN tgt.ResponseCodeInternal <> 0 THEN 3 ELSE 2 END -- 2: not reconciled, 3: auto reconciled
		,tgt.UnreconciledStatus = CASE WHEN tgt.ResponseCodeInternal <> 0 THEN NULL ELSE 2 END -- gateway no match but SA approved
WHEN MATCHED THEN
	UPDATE SET 
		tgt.AmountGatewayDebit = src.AmountSettlement
		,tgt.AmountInterchangeCollected = CASE WHEN src.AmountSettlement > 0 THEN 0.75 ELSE 0 END
		,tgt.ReconciliationStatus = 
			CASE
				WHEN tgt.ResponseCodeInternal = 0 AND src.AmountSettlement = tgt.AmountSettlement THEN 3 -- auto reconciled
				WHEN tgt.ResponseCodeInternal <> 0 AND src.AmountSettlement = 0 THEN 3 -- auto reconciled
				ELSE 2  -- not reconciled
			END
		,tgt.UnreconciledStatus =
			CASE
				WHEN tgt.ResponseCodeInternal = 0 AND src.AmountSettlement = tgt.AmountSettlement THEN NULL -- auto reconciled
				WHEN tgt.ResponseCodeInternal <> 0 AND src.Bae24RespCode <> '00' THEN NULL -- auto reconciled
				ELSE  -- not reconciled
					CASE
						WHEN tgt.ResponseCodeInternal <> 0 AND src.Bae24RespCode = '00' THEN 3 -- gateway approved but SA declined
						WHEN tgt.ResponseCodeInternal = 0 AND src.Bae24RespCode <> '00' THEN 4 -- gateway declined but SA approved
						WHEN tgt.ResponseCodeInternal = 0 AND src.Bae24RespCode = '00' AND src.AmountSettlement <> tgt.AmountSettlement THEN 5 -- both approved but no equal amount 
						ELSE NULL
					END
			END;

--SELECT * FROM #TermpTransactionACIConsolidated
IF OBJECT_ID('tempdb..#TermpTransactionACIConsolidated') IS NOT NULL
BEGIN
	TRUNCATE TABLE #TermpTransactionACIConsolidated
	DROP TABLE #TermpTransactionACIConsolidated
END
END

GO
GRANT EXECUTE ON  [dbo].[usp_rec_TransactionACI_MatchAndKill] TO [WebV4Role]
GO
