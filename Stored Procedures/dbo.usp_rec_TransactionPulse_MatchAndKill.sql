SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

/*
SELECT * FROM dbo.tbl_rec_TransactionPulse
SELECT * FROM dbo.tbl_trn_TransactionConsolidated --41065
SELECT * FROM dbo.tbl_trn_TransactionConsolidated WHERE SettlementDate = '2015-04-19' and destcode = 101 --19714
EXEC [dbo].[usp_rec_TransactionPulse_MatchAndKill] '2015-04-19'
SELECT * FROM dbo.tbl_trn_TransactionConsolidated WHERE SettlementDate = '2015-04-19' and destcode = 101 and  responsecodeinternal = -99
SELECT * FROM dbo.tbl_trn_TransactionConsolidated WHERE SettlementDate = '2015-04-19' and destcode =101 and reconciliationstatus = 2
SELECT * FROM dbo.tbl_trn_TransactionConsolidated WHERE deviceid = 85 and  responsecodeinternal <> -99
SELECT * FROM dbo.tbl_trn_TransactionConsolidated WHERE SettlementDate = '2015-04-19' and destcode = 101 and UnreconciledStatus = 1
SELECT * FROM dbo.tbl_trn_TransactionConsolidated WHERE SettlementDate = '2015-04-19' and destcode = 101 and UnreconciledStatus = 2
SELECT * FROM dbo.tbl_trn_TransactionConsolidated WHERE SettlementDate = '2015-04-19' and destcode = 101 and UnreconciledStatus = 3
SELECT * FROM dbo.tbl_trn_TransactionConsolidated WHERE SettlementDate = '2015-04-19' and destcode = 101 and UnreconciledStatus = 4
SELECT * FROM dbo.tbl_trn_TransactionConsolidated WHERE SettlementDate = '2015-04-19' and destcode = 101 and UnreconciledStatus = 5
*/
CREATE PROCEDURE [dbo].[usp_rec_TransactionPulse_MatchAndKill]
	@pSettDate datetime
AS
BEGIN
SET NOCOUNT ON

IF OBJECT_ID('tempdb..#TempTransactionPulseConsolidated') IS NOT NULL
BEGIN
	TRUNCATE TABLE #TempTransactionPulseConsolidated
	DROP TABLE #TempTransactionPulseConsolidated
END
IF OBJECT_ID('tempdb..#TempTransactionCirrusConsolidated') IS NOT NULL
BEGIN
	TRUNCATE TABLE #TempTransactionCirrusConsolidated
	DROP TABLE #TempTransactionCirrusConsolidated
END

IF NOT EXISTS(SELECT TOP 1 1 FROM dbo.tbl_trn_TransactionConsolidated (NOLOCK) WHERE SettlementDate = @pSettDate AND CurrencyRequest = 840)
BEGIN
	EXEC dbo.usp_trn_TransactionConsolidated_Load @pSettDate, 840, 0
END


DELETE FROM dbo.tbl_trn_TransactionConsolidated
WHERE SettlementDate = @pSettDate
	AND DestCode = 101
	AND ResponseCodeInternal = -99

UPDATE dbo.tbl_trn_TransactionConsolidated
SET AmountGatewayDebit = NULL
	,AmountInterchangeCollected = NULL
	,AmountGatewayProcFee = NULL
	,ReconciliationStatus = 1
	,UnreconciledStatus = NULL
	,ReconciliationComment = NULL
WHERE SettlementDate = @pSettDate
	AND DestCode = 101


SELECT
	t.DateTimeSettlement
	,t.TerminalID
	,RetrievalRefNum2Int = CAST(t.RetrievalRefNum2Int AS BIGINT)
	,PAN_Last4 = MAX(t.PAN_Last4)
	,t.LocalTimeStamp
	,ActionCode = MAX(t.ActionCode)
	,PulseGatewayDebit = MAX(
		CASE 
			WHEN t.ActionCode = '0000' AND t.PCode NOT LIKE '40%' THEN t.Amount1Value - ISNULL(r.Amount1Value, 0)
			ELSE 0
		END)
	,PulseInterchange = MAX( 
		CASE
			WHEN t.Fee1Type IS NULL THEN 0
			WHEN t.Amount1Value = r.Amount1Value THEN 0
			WHEN t.Fee1Type LIKE 'Interchange%' THEN t.Fee1Value
			WHEN t.Fee2Type LIKE 'Interchange%' THEN t.Fee2Value
			WHEN t.Fee6Type LIKE 'Interchange%' OR t.Fee6Type LIKE '8__' THEN t.Fee6Value
			ELSE 0
		END)
	,PulseSwitchFee = MAX( 
		CASE 
			WHEN t.Fee1Type IS NULL THEN 0
			WHEN t.Fee1Type LIKE 'Network Sec%' THEN t.Fee1Value + t.Fee3Value
			WHEN t.Fee1Type LIKE 'Switch Fee%' AND t.Fee2Type LIKE 'PLUS SMS%' THEN t.Fee1Value + t.Fee2Value
			WHEN t.Fee1Type LIKE 'Switch Fee%' THEN t.Fee1Value
			ELSE 0 
		END)
	,Fee1Type = MAX(t.Fee1Type)
	,FeeCount = MAX(t.FeeCount)
	,IssuerNetworkID = MAX(t.IssuerNetworkID)
	,TransactionType =
		CASE
			WHEN r.TerminalID IS NULL THEN 1 -- ATM Withdrawal
			ELSE 101 -- Reversal of ATM Withdrawal
		END
INTO #TempTransactionPulseConsolidated
FROM dbo.tbl_rec_TransactionPulse t(NOLOCK)
	LEFT JOIN dbo.tbl_rec_TransactionPulse r(NOLOCK) -- reversals
		ON t.DateTimeSettlement = r.DateTimeSettlement
		AND t.TerminalID = r.TerminalID
		AND t.RetrievalRefNum2Int = r.RetrievalRefNum2Int
		AND t.PAN_Last4 = r.PAN_Last4
		--AND t.LocalTimeStamp = r.LocalTimeStamp
		AND r.ActionCode = '4000'
		AND r.Fee1Type <> 'Cirrus Interchange'
		AND r.DateTimeSettlement = @pSettDate
WHERE 
	t.ActionCode <> '4000'
	AND t.Fee1Type <> 'Cirrus Interchange'
	AND t.DateTimeSettlement  = @pSettDate
GROUP BY t.DateTimeSettlement
	,t.TerminalID
	,t.RetrievalRefNum2Int
	,t.PAN_Last4
	,t.LocalTimeStamp
	,CASE
			WHEN r.TerminalID IS NULL THEN 1 -- ATM Withdrawal
			ELSE 101 -- Reversal of ATM Withdrawal
	END

SELECT 
	t.DateTimeSettlement
	,t.TerminalID
	,RetrievalRefNum2Int = CAST(t.RetrievalRefNum2Int AS BIGINT)
	,t.PAN_Last4
	,t.LocalTimeStamp
	,CirrusInterchange =
		CASE 
			WHEN t.Fee1Type IS NULL THEN 0
			WHEN t.Fee3Value = r.Fee3Value THEN 0
			ELSE t.Fee1Value 
		END 
INTO #TempTransactionCirrusConsolidated	
FROM dbo.tbl_rec_TransactionPulse t(NOLOCK)
	LEFT JOIN dbo.tbl_rec_TransactionPulse r(NOLOCK) -- reversals
		ON t.DateTimeSettlement = r.DateTimeSettlement
		AND t.TerminalID = r.TerminalID
		AND t.RetrievalRefNum2Int = r.RetrievalRefNum2Int
		AND t.PAN_Last4 = r.PAN_Last4
		AND r.ActionCode = '4000'
		AND r.Fee1Type = 'Cirrus Interchange'
		AND r.DateTimeSettlement BETWEEN @pSettDate - 2 AND @pSettDate
WHERE 
	t.ActionCode <> '4000'
	AND t.Fee1Type = 'Cirrus Interchange'
	AND t.DateTimeSettlement BETWEEN @pSettDate - 2 AND @pSettDate

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
		AND DestCode = 101 
)
MERGE INTO tgt
USING #TempTransactionPulseConsolidated src
	ON tgt.SettlementDate = src.DateTimeSettlement
	AND tgt.TerminalName = src.TerminalID
	--AND tgt.DeviceDate BETWEEN DATEADD(second, -2, src.LocalTimeStamp) AND DATEADD(second, +2, src.LocalTimeStamp) -- no need since duplicate seq no in one day seldom happens
	AND tgt.NetworkSequence = src.RetrievalRefNum2Int
	AND tgt.PAN = src.PAN_Last4
WHEN NOT MATCHED BY TARGET 
	AND src.ActionCode = '0000'
	AND src.Fee1Type <>  'PIX2 Fee Type'
	AND NOT (src.ActionCode = '0000' AND src.FeeCount = 0 AND src.IssuerNetworkId = '')
	AND EXISTS (SELECT TOP 1 Id FROM dbo.tbl_Device (NOLOCK) WHERE TerminalName = src.TerminalID ) 
	--AND NOT EXISTS(SELECT TOP 1 1 FROM dbo.tbl_trn_TransactionConsolidated (NOLOCK) 
	--				WHERE SettlementDate = src.DateTimeSettlement 
	--				AND DeviceId = (SELECT TOP 1 Id FROM dbo.tbl_Device (NOLOCK) WHERE TerminalName = src.TerminalID)
	--				AND DeviceDate = src.LocalTimeStamp
	--				AND DeviceSequence = src.RetrievalRefNum2Int
	--				AND TransactionType = src.TransactionType) 
	THEN
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
		,ISNULL((SELECT TOP 1 Id FROM dbo.tbl_Device (NOLOCK) WHERE TerminalName = src.TerminalID) ,0) -- DeviceId
		,src.LocalTimeStamp -- DeviceDate
		,src.RetrievalRefNum2Int -- DeviceSequence
		,src.TransactionType -- TransactionType
		,0 -- TransactionId
		,src.LocalTimeStamp -- SystemTime
		,src.RetrievalRefNum2Int -- NetworkSequence
		,'' -- BINRange
		,src.PAN_Last4 -- PAN
		,-99 -- ResponseCodeInternal 
		,-1 --NetworkId
		,101 -- DestCode
		,0 -- AmountRequest
		,0 -- AmountSettlement
		,0 -- AmountSurcharge
		,src.PulseGatewayDebit -- AmountGatewayDebit
		,src.PulseInterchange -- AmountInterchangeCollected
		,src.PulseSwitchFee -- AmountGatewayProcFee
		,src.TerminalID -- TerminalName
		,840 -- CurrencyRequest 
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
		tgt.AmountGatewayDebit = src.PulseGatewayDebit
		,tgt.AmountInterchangeCollected = src.PulseInterchange
		,tgt.AmountGatewayProcFee = src.PulseSwitchFee
		,tgt.ReconciliationStatus = 
			CASE
				WHEN src.ActionCode = '0000' AND tgt.ResponseCodeInternal = 0 AND src.PulseGatewayDebit = tgt.AmountSettlement THEN 3 -- auto reconciled
				WHEN src.ActionCode <> '0000' AND tgt.ResponseCodeInternal <> 0 THEN 3
				ELSE 2  -- not reconciled
			END
		,tgt.UnreconciledStatus =
			CASE
				WHEN src.ActionCode = '0000' AND tgt.ResponseCodeInternal = 0 AND src.PulseGatewayDebit = tgt.AmountSettlement THEN 3 -- auto reconciled
				WHEN src.ActionCode <> '0000' AND tgt.ResponseCodeInternal <> 0 THEN 3
				ELSE -- not reconciled
					CASE
						WHEN src.ActionCode = '0000' AND tgt.ResponseCodeInternal <> 0 THEN 3 -- gateway approved but SA declined
						WHEN src.ActionCode <> '0000' AND tgt.ResponseCodeInternal = 0 THEN 4 -- gateway declined but SA approved
						WHEN src.ActionCode = '0000' AND tgt.ResponseCodeInternal = 0 AND src.PulseGatewayDebit <> tgt.AmountSettlement THEN 5 -- both approved but no equal amount  
						ELSE NULL
					END
			END;

-- update Cirrus interchange
UPDATE tc
SET AmountInterchangeCollected = cc.CirrusInterchange
FROM dbo.tbl_trn_TransactionConsolidated tc
	JOIN #TempTransactionCirrusConsolidated cc(NOLOCK)
		ON tc.SettlementDate = cc.DateTimeSettlement
		AND tc.TerminalName = cc.TerminalID
		AND tc.NetworkSequence = cc.RetrievalRefNum2Int
		AND tc.DeviceDate = cc.LocalTimeStamp
		AND tc.PAN = cc.PAN_Last4 
		AND tc.ResponseCodeInternal <> -99
		AND tc.SettlementDate = @pSettDate
		AND tc.DestCode = 101

--SELECT * FROM #TempTransactionPulseConsolidated
--SELECT * FROM #TempTransactionCirrusConsolidated
IF OBJECT_ID('tempdb..#TempTransactionPulseConsolidated') IS NOT NULL
BEGIN
	TRUNCATE TABLE #TempTransactionPulseConsolidated
	DROP TABLE #TempTransactionPulseConsolidated
END
IF OBJECT_ID('tempdb..#TempTransactionCirrusConsolidated') IS NOT NULL
BEGIN
	TRUNCATE TABLE #TempTransactionCirrusConsolidated
	DROP TABLE #TempTransactionCirrusConsolidated
END

END
GO
GRANT EXECUTE ON  [dbo].[usp_rec_TransactionPulse_MatchAndKill] TO [WebV4Role]
GO
