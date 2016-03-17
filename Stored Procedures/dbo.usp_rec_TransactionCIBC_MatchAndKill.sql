SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

/*
TRUNCATE TABLE dbo.tbl_trn_TransactionConsolidated
TRUNCATE TABLE dbo.tbl_rec_TransactionCIBCImport
TRUNCATE TABLE dbo.tbl_rec_TransactionCIBC

EXEC dbo.usp_rec_TransactionCIBC_Load '2015-04-19', 840
SELECT * FROM dbo.tbl_rec_TransactionCIBC WHERE DateTimeSettlement = '2015-04-19' and Currency = 840
SELECT * FROM dbo.tbl_trn_TransactionConsolidated WHERE SettlementDate = '2015-04-19' AND destcode = 7 and currencyrequest = 840
EXEC [dbo].[usp_rec_TransactionCIBC_MatchAndKill] '2015-04-19', 840
SELECT * FROM dbo.tbl_trn_TransactionConsolidated WHERE SettlementDate = '2015-04-19' AND destcode = 7 and currencyrequest = 840

EXEC dbo.usp_rec_TransactionCIBC_Load '2015-04-19', 124
SELECT * FROM dbo.tbl_rec_TransactionCIBC WHERE DateTimeSettlement = '2015-04-19' and Currency = 124
SELECT * FROM dbo.tbl_trn_TransactionConsolidated WHERE SettlementDate = '2015-04-19' AND destcode = 7 and currencyrequest = 124
EXEC [dbo].[usp_rec_TransactionCIBC_MatchAndKill] '2015-04-19', 124
SELECT * FROM dbo.tbl_trn_TransactionConsolidated WHERE SettlementDate = '2015-04-19' AND destcode = 7 and currencyrequest = 124
*/
CREATE PROCEDURE [dbo].[usp_rec_TransactionCIBC_MatchAndKill]
	@pSettDate datetime,
	@pCurrency smallint
AS
BEGIN
SET NOCOUNT ON

IF OBJECT_ID('tempdb..#TempTransactionCIBCConsolidated') IS NOT NULL
BEGIN
	TRUNCATE TABLE #TempTransactionCIBCConsolidated
	DROP TABLE #TempTransactionCIBCConsolidated
END


IF NOT EXISTS(SELECT TOP 1 1 FROM dbo.tbl_trn_TransactionConsolidated (NOLOCK) WHERE SettlementDate = @pSettDate AND CurrencyRequest = @pCurrency)
BEGIN
	EXEC dbo.usp_trn_TransactionConsolidated_Load @pSettDate, @pCurrency, 0
END

DELETE FROM dbo.tbl_trn_TransactionConsolidated
WHERE SettlementDate = @pSettDate
	AND CurrencyRequest = @pCurrency
	AND DestCode = 7
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
	AND DestCode = 7


SELECT 
	t.DateTimeSettlement
	,t.TerminalID
	,RetrievalRefNumInt = CAST(t.RetrievalRefNumInt AS BIGINT)
	,t.DateTimeLocal
	,t.MsgType
	,CIBCGatewayDebit = ISNULL(r.AmountReconciliationCAD, t.AmountReconciliationCAD)
	,TransactionType =
		CASE
			WHEN r.TerminalID IS NULL THEN 1 -- ATM Withdrawal
			ELSE 101 -- Reversal of ATM Withdrawal
		END
	,t.AmountTransactionCAD
	,t.AmountReconciliationCAD
INTO #TempTransactionCIBCConsolidated
FROM dbo.tbl_rec_TransactionCIBC t(NOLOCK)
	LEFT JOIN dbo.tbl_rec_TransactionCIBC r(NOLOCK) -- reversals
		ON t.DateTimeSettlement = r.DateTimeSettlement
		AND t.TerminalID = r.TerminalID
		AND t.RetrievalRefNumInt = r.RetrievalRefNumInt
		AND t.DateTimeLocal = r.DateTimeLocal
		AND r.MsgType = 420
		AND r.DateTimeSettlement = @pSettDate
		AND r.Currency = @pCurrency
WHERE 
	t.MsgType <> 420
	AND t.DateTimeSettlement  = @pSettDate
	AND t.Currency = @pCurrency


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
		AND DestCode = 7
)
MERGE INTO tgt
USING #TempTransactionCIBCConsolidated src
	ON tgt.SettlementDate = src.DateTimeSettlement
	AND tgt.TerminalName = src.TerminalID
	AND tgt.NetworkSequence = src.RetrievalRefNumInt
WHEN NOT MATCHED BY TARGET 
	AND src.CIBCGatewayDebit <> 0
	AND EXISTS (SELECT TOP 1 Id FROM dbo.tbl_Device (NOLOCK) WHERE TerminalName = src.TerminalID) THEN
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
		,ISNULL((SELECT TOP 1 Id FROM dbo.tbl_Device (NOLOCK) WHERE TerminalName = src.TerminalID) ,0) -- DeviceId
		,src.DateTimeLocal -- DeviceDate
		,src.RetrievalRefNumInt -- DeviceSequence
		,src.TransactionType -- TransactionType
		,0 -- TransactionId
		,src.DateTimeLocal -- SystemTime
		,src.RetrievalRefNumInt -- NetworkSequence
		,'' -- BINRange
		,'' -- PAN
		,-99 -- ResponseCodeInternal 
		,-1 --NetworkId
		,7 -- DestCode
		,src.AmountTransactionCAD -- AmountRequest
		,0 -- AmountSettlement
		,0 -- AmountSurcharge
		,CASE
			WHEN src.MsgType = 422 THEN -src.AmountTransactionCAD
			WHEN src.MsgType = 220 THEN src.AmountReconciliationCAD
			ELSE src.CIBCGatewayDebit 
		END -- AmountGatewayDebit
		,0 -- AmountInterchangeCollected
		,0-- AmountGatewayProcFee
		,src.TerminalID -- TerminalName
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
		tgt.AmountGatewayDebit = src.CIBCGatewayDebit
		,tgt.ReconciliationStatus = 
			CASE
				WHEN tgt.ResponseCodeInternal = 0 AND src.CIBCGatewayDebit = tgt.AmountSettlement THEN 3 -- auto reconciled
				WHEN tgt.ResponseCodeInternal <> 0 AND src.CIBCGatewayDebit = 0 THEN 3 -- auto reconciled
				ELSE 2  -- not reconciled
			END
		,tgt.UnreconciledStatus =
			CASE
				WHEN tgt.ResponseCodeInternal = 0 AND src.CIBCGatewayDebit = tgt.AmountSettlement THEN NULL -- auto reconciled
				WHEN tgt.ResponseCodeInternal <> 0 AND src.CIBCGatewayDebit = 0 THEN NULL -- auto reconciled
				ELSE  -- not reconciled
					CASE
						WHEN tgt.ResponseCodeInternal <> 0 AND src.CIBCGatewayDebit <> 0 THEN 3 -- gateway approved but SA declined
						WHEN tgt.ResponseCodeInternal = 0 AND src.CIBCGatewayDebit = 0 THEN 4 -- gateway declined but SA approved
						WHEN tgt.ResponseCodeInternal = 0 AND src.CIBCGatewayDebit <> 0 AND src.CIBCGatewayDebit <> tgt.AmountSettlement THEN 5 -- both approved but no equal amount 
						ELSE NULL
					END
			END;


--SELECT * FROM #TempTransactionCIBCConsolidated
IF OBJECT_ID('tempdb..#TempTransactionCIBCConsolidated') IS NOT NULL
BEGIN
	TRUNCATE TABLE #TempTransactionCIBCConsolidated
	DROP TABLE #TempTransactionCIBCConsolidated
END


END
GO
GRANT EXECUTE ON  [dbo].[usp_rec_TransactionCIBC_MatchAndKill] TO [WebV4Role]
GO
