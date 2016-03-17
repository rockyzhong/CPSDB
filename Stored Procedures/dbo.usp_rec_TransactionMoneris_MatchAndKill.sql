SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

/*
BCP CPS.dbo.tbl_rec_TransactionMonerisImport IN "c:\recfile\GWRAW01.20150419.0R03.txt" -Sitwsjw01  -T -c
SELECT * FROM dbo.tbl_rec_TransactionMonerisImport
SELECT * FROM dbo.tbl_rec_TransactionMoneris
EXEC dbo.usp_rec_TransactionMoneris_MatchAndKill '2015-04-19', 124

SELECT * FROM dbo.tbl_trn_TransactionConsolidated WHERE SettlementDate = '2015-04-19' AND DestCode = 1
SELECT * FROM dbo.tbl_trn_TransactionConsolidated WHERE SettlementDate = '2015-04-19' AND DestCode = 1 AND ReconciliationStatus = 1
SELECT * FROM dbo.tbl_trn_TransactionConsolidated WHERE SettlementDate = '2015-04-19' AND DestCode = 1 AND ReconciliationStatus = 3
SELECT * FROM dbo.tbl_trn_TransactionConsolidated WHERE SettlementDate = '2015-04-19' AND DestCode = 1 AND ReconciliationStatus = 2  AND ResponseCodeInternal <> -99 AND DeviceID = 4235
SELECT * FROM dbo.tbl_rec_TransactionMoneris where DateTimeSettlement = '2015-04-19' AND TerminalID = (SELECT TerminalName from dbo.tbl_device where id = 4235)

SELECT * FROM dbo.tbl_trn_TransactionConsolidated WHERE SettlementDate = '2015-04-19' AND DestCode = 1
SELECT * FROM dbo.tbl_trn_TransactionConsolidated WHERE SettlementDate = '2015-04-19' AND DestCode = 1

SELECT * FROM dbo.tbl_rec_TransactionMoneris where DateTimeSettlement = '2015-04-19' and msgtype = 5220
SELECT * FROM dbo.tbl_rec_TransactionMoneris where DateTimeSettlement = '2015-04-19' and msgtype = 5240
SELECT * FROM dbo.tbl_rec_TransactionMoneris where DateTimeSettlement = '2015-04-19' and msgtype = 5270
*/

CREATE PROCEDURE [dbo].[usp_rec_TransactionMoneris_MatchAndKill]
	@pSettDate datetime
	,@pCurrency smallint = 124
AS
BEGIN
SET NOCOUNT ON

IF OBJECT_ID('tempdb..#TermpTransactionMonerisConsolidated') IS NOT NULL
BEGIN
	TRUNCATE TABLE #TermpTransactionMonerisConsolidated
	DROP TABLE #TermpTransactionMonerisConsolidated
END

IF NOT EXISTS(SELECT TOP 1 1 FROM dbo.tbl_trn_TransactionConsolidated (NOLOCK) WHERE SettlementDate = @pSettDate AND CurrencyRequest = @pCurrency)
BEGIN
	EXEC dbo.usp_trn_TransactionConsolidated_Load @pSettDate, @pCurrency, 0
END

DELETE FROM dbo.tbl_trn_TransactionConsolidated
WHERE SettlementDate = @pSettDate
	AND CurrencyRequest = @pCurrency
	AND DestCode = 1
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
	AND DestCode = 1

SELECT 
	SettlementDate = t.DateTimeSettlement
	,t.TerminalID
	,t.TraceNum
	,t.RefNum
	,t.PAN
	,TerminalEventDate = t.DateTimeTerminalEvent
	,TransactionType = CASE WHEN r.TerminalID IS NULL THEN 1 ELSE 101 END -- WTH/RWT
	,t.AmountRequested
	,AmountSettlement = CASE
							WHEN t.Settled = 'N' AND r.AmountNew IS NULL THEN CONVERT(money, 0)
							ELSE ISNULL(r.AmountNew, t.AmountAuthorized)
						END
	,AmountSurcharge = CONVERT(money, 0)
	,AmountInterchange = t.AmountInterchange + ISNULL(r.AmountInterchange, 0)
	,RespCode = RTRIM(LEFT(t.RespCode, 2))
	,t.CompCode
	,IssuerProcessorID = (CASE 
							WHEN t.IssProcessorID = '9000101004' AND t.IssInstitutionID = '1002004020' THEN 'PUL'
							WHEN t.IssProcessorID = '9000101004' AND t.IssInstitutionID = '1003004029' THEN 'CUP'
							ELSE ISNULL(t.IssNetCode, '')
						END)
	,IssuerInstitutionID = t.IssInstitutionID
	,AccountType = (CASE 
						WHEN t.PCode % 100 = 10 THEN 'SAV'
						WHEN t.PCode % 100 = 20 THEN 'CHK'
						ELSE 'CRD' 
					END)
	,t.ProcFee
	--,*
INTO #TermpTransactionMonerisConsolidated
FROM dbo.tbl_rec_TransactionMoneris t(NOLOCK)
	LEFT JOIN dbo.tbl_rec_TransactionMoneris r(NOLOCK)
		ON t.DateTimeSettlement = r.DateTimeSettlement
		AND t.TerminalID = r.TerminalID
		AND t.TraceNum = r.TraceNum
		AND t.RefNum = r.RefNum
		--AND t.DateTimeTerminalEvent = r.DateTimeTerminalEvent
		AND t.PAN = r.PAN
		AND r.MsgType = 5240
		AND r.DateTimeSettlement = @pSettDate
		AND r.CurrencyCode = @pCurrency
WHERE t.MsgType = 5220
	AND t.DateTimeSettlement = @pSettDate
	AND t.CurrencyCode = @pCurrency
UNION ALL
SELECT 
	SettlementDate = t.DateTimeSettlement
	,t.TerminalID
	,t.TraceNum
	,t.RefNum
	,t.PAN
	,TerminalEventDate = t.DateTimeTerminalEvent
	,TransactionType = 2 -- INQ
	,t.AmountRequested
	,AmountSettlement = CONVERT(money, 0)
	,AmountSurcharge = CONVERT(money, 0)
	,AmountInterchange = t.AmountInterchange
	,RespCode = RTRIM(LEFT(t.RespCode, 2))
	,t.CompCode
	,IssuerProcessorID =  ISNULL(t.IssNetCode, '')
	,IssuerInstitutionID = t.IssInstitutionID
	,AccountType = (CASE 
						WHEN t.PCode % 100 = 10 THEN 'SAV'
						WHEN t.PCode % 100 = 20 THEN 'CHK'
						ELSE 'CRD' 
					END)
	,t.ProcFee
	--,*
FROM dbo.tbl_rec_TransactionMoneris t(NOLOCK)
WHERE t.MsgType = 5270
	AND t.DateTimeSettlement = @pSettDate
	AND t.CurrencyCode = @pCurrency

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
		AND DestCode = 1
)
MERGE INTO tgt
USING #TermpTransactionMonerisConsolidated src
	ON tgt.SettlementDate = src.SettlementDate
	AND tgt.TerminalName = src.TerminalID
	AND tgt.NetworkSequence = src.TraceNum
	AND tgt.DeviceDate = src.TerminalEventDate
	AND tgt.TransactionType = src.TransactionType
WHEN NOT MATCHED BY TARGET 
	AND src.AmountSettlement <> 0 
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
		src.SettlementDate -- SettlementDate
		,ISNULL((SELECT TOP 1 Id FROM dbo.tbl_Device (NOLOCK) WHERE TerminalName = src.TerminalID) ,0) -- DeviceId
		,src.TerminalEventDate -- DeviceDate
		,src.TraceNum -- DeviceSequence
		,src.TransactionType -- TransactionType
		,0 -- TransactionId
		,src.TerminalEventDate -- SystemTime
		,src.TraceNum -- NetworkSequence
		,'' -- BINRange
		,src.PAN -- PAN
		,-99 -- ResponseCodeInternal 
		,-1 --NetworkId
		,1 -- DestCode
		,src.AmountRequested -- AmountRequest
		,0 -- AmountSettlement
		,src.AmountSurcharge -- AmountSurcharge
		,src.AmountSettlement -- AmountGatewayDebit
		,src.AmountInterchange -- AmountInterchangeCollected
		,src.ProcFee -- AmountGatewayProcFee
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
		tgt.AmountGatewayDebit = src.AmountSettlement
		,tgt.ReconciliationStatus = 
			CASE
				WHEN tgt.ResponseCodeInternal = 0 AND src.AmountSettlement = tgt.AmountSettlement THEN 3 -- auto reconciled
				WHEN tgt.ResponseCodeInternal <> 0 AND src.AmountSettlement = 0 THEN 3 -- auto reconciled
				ELSE 2  -- not reconciled
			END
		,tgt.UnreconciledStatus =
			CASE
				WHEN tgt.ResponseCodeInternal = 0 AND src.AmountSettlement = tgt.AmountSettlement THEN NULL -- auto reconciled
				WHEN tgt.ResponseCodeInternal <> 0 AND src.AmountSettlement = 0 THEN NULL -- auto reconciled
				ELSE  -- not reconciled
					CASE
						WHEN tgt.ResponseCodeInternal <> 0 AND src.AmountSettlement <> 0 THEN 3 -- gateway approved but SA declined
						WHEN tgt.ResponseCodeInternal = 0 AND src.AmountSettlement = 0 THEN 4 -- gateway declined but SA approved
						WHEN tgt.ResponseCodeInternal = 0 AND src.AmountSettlement <> 0 AND src.AmountSettlement <> tgt.AmountSettlement THEN 5 -- both approved but no equal amount 
						ELSE NULL
					END
			END;

SELECT * FROM #TermpTransactionMonerisConsolidated
IF OBJECT_ID('tempdb..#TermpTransactionMonerisConsolidated') IS NOT NULL
BEGIN
	TRUNCATE TABLE #TermpTransactionMonerisConsolidated
	DROP TABLE #TermpTransactionMonerisConsolidated
END
END

GO
GRANT EXECUTE ON  [dbo].[usp_rec_TransactionMoneris_MatchAndKill] TO [WebV4Role]
GO
