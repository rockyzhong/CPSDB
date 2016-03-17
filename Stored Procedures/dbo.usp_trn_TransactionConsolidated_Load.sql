SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO


/*
TRUNCATE TABLE dbo.tbl_trn_TransactionConsolidated
EXEC dbo.usp_trn_TransactionConsolidated_Load '2015-04-19', 124, 1
EXEC dbo.usp_trn_TransactionConsolidated_Load '2015-04-19', 840, 1
SELECT * FROM dbo.tbl_trn_TransactionConsolidated WHERE SettlementDate = '2015-04-19'  and [CurrencyRequest] = 124
SELECT * FROM dbo.tbl_trn_TransactionConsolidated WHERE SettlementDate = '2015-04-19'  and [CurrencyRequest] = 840
SELECT transactionid, count(*) FROM dbo.tbl_trn_TransactionConsolidated WHERE SettlementDate = '2015-04-19'
group by transactionid having count(*)>1
SELECT DestCode, CurrencyRequest, count(*) FROM dbo.tbl_trn_TransactionConsolidated 
group by DestCode, CurrencyRequest
ORDER BY 1
select a.* from dbo.tbl_trn_Transaction a join (select min(transactionid) minid, max(transactionid) maxid from dbo.tbl_trn_TransactionConsolidated where currencyrequest = 124) b
	on a.id between b.minid and b.maxid
	left join dbo.tbl_trn_TransactionConsolidated c on a.id = c.transactionid
	where c.transactionid is null
	and a.CurrencyRequest = 124
	and a.TransactionType NOT BETWEEN 101 AND 112 -- exclude all reversal tran
	-- exlcude the following transactions as well
	AND a.TransactionType <> 6 -- Pre-transaction request for Accounts associated with the inserted card
	AND a.TransactionType NOT BETWEEN 50 AND 99 -- ecage trans
	AND a.TransactionType NOT BETWEEN 150 AND 199 --?
	order by id

select a.* from dbo.tbl_trn_Transaction a join (select min(transactionid) minid, max(transactionid) maxid from dbo.tbl_trn_TransactionConsolidated where currencyrequest = 840) b
	on a.id between b.minid and b.maxid
	left join dbo.tbl_trn_TransactionConsolidated c on a.id = c.transactionid
	where c.transactionid is null
	and a.CurrencyRequest = 840
	and a.TransactionType NOT BETWEEN 101 AND 112 -- exclude all reversal tran
	-- exlcude the following transactions as well
	AND a.TransactionType <> 6 -- Pre-transaction request for Accounts associated with the inserted card
	AND a.TransactionType NOT BETWEEN 50 AND 99 -- ecage trans
	AND a.TransactionType NOT BETWEEN 150 AND 199 --?
	order by id
*/

CREATE PROC [dbo].[usp_trn_TransactionConsolidated_Load]
	@SettDate DATETIME
	,@CurrencyRequest BIGINT = 124
	,@Reload BIT = 0
AS
BEGIN
SET NOCOUNT ON

--DECLARE @SettDate DATETIME
--SELECT @SettDate = '2015-05-04'
DECLARE @StartTime1 DATETIME  -- USA
DECLARE @EndTime1 DATETIME
DECLARE @StartTime2 DATETIME -- CAN
DECLARE @EndTime2 DATETIME
DECLARE @HourOffset INT
DECLARE @MinTranID BIGINT
DECLARE @MaxTranID BIGINT 
DECLARE @ErrMsg varchar(MAX)

SET @HourOffset = DATEDIFF(HOUR, GETUTCDATE(), GETDATE())

IF (@Reload = 1)
BEGIN
	DELETE FROM dbo.tbl_trn_TransactionConsolidated 
	WHERE SettlementDate = @SettDate
		AND CurrencyRequest = @CurrencyRequest
END
ELSE IF EXISTS(SELECT TOP 1 1 FROM dbo.tbl_trn_TransactionConsolidated (NOLOCK) WHERE SettlementDate = @SettDate AND CurrencyRequest = @CurrencyRequest)
BEGIN
	SET @ErrMsg = 'The transactions of the given settlement date and currency have been consolidated already.' + char(13) + char(10) 
				+ 'Set @Reload parameter to 1 if you want to reconsolidated the transactions'
	RAISERROR(@ErrMsg, 16, 1)
	RETURN
END

--Get the cutoff times
--USA cutoff time 1:00AM
--CAN cutoff time 9:00PM
IF DATEPART(MONTH, @SettDate) = 3 AND DATEPART(WEEKDAY, @SettDate) = 1 AND DATEPART(DAY, @SettDate) BETWEEN 8 AND 14
BEGIN
  SELECT @StartTime1 = DATEADD(HOUR, 6, @SettDate)
		,@EndTime1 = DATEADD(HOUR, 29, @SettDate)
		,@StartTime2 = DATEADD(HOUR, 2, @SettDate)
		,@EndTime2 = DATEADD(HOUR, 25, @SettDate)
END
ELSE IF DATEPART(MONTH, @SettDate) = 11 AND DATEPART(WEEKDAY, @SettDate) = 1
  AND DATEPART(DAY, @SettDate) BETWEEN 1 AND 7
BEGIN
  SELECT @StartTime1 = DATEADD(HOUR, 5, @SettDate)
		,@EndTime1 = DATEADD(HOUR, 30, @SettDate)
		,@StartTime2 = DATEADD(HOUR, 1, @SettDate)
		,@EndTime2 = DATEADD(HOUR, 26, @SettDate)
END
ELSE
BEGIN
  SELECT @StartTime1 = DATEADD(HOUR,1 - @HourOffset, @SettDate)
		,@EndTime1 = DATEADD(HOUR, 25 - @HourOffset, @SettDate)
		,@StartTime2 = DATEADD(HOUR, -3 - @HourOffset, @SettDate)
		,@EndTime2 = DATEADD(HOUR, 21 - @HourOffset, @SettDate)
END

SELECT 
	@MinTranID = MIN(t.Id)
	,@MaxTranID = MAX(t.Id) 
FROM dbo.tbl_trn_Transaction t(NOLOCK)
WHERE t.SystemTime BETWEEN @SettDate - 1 AND @SettDate + 2
--SELECT @StartTime1, @EndTime1, @StartTime2, @EndTime2, @MinTranID, @MaxTranID


;WITH cteTranTemp AS
(
SELECT
	-- transaction unique ID
	SettlementDate = @SettDate
	,t.DeviceId -- will map to the cctxlog TERM_ID
	,t.DeviceDate
	,t.DeviceSequence
	,TransactionType = ISNULL(r.TransactionType, t.TransactionType) -- use the reversal's transaction type to indicatet that the original transaction has been reversed
	-- transaction data
	,TransactionId = MAX(t.Id) -- internal Id for linking back for raw transaction data
	,SystemTime = MAX(t.SystemTime)
	,NetworkSequence = MAX(ISNULL(t.NetworkSequence, 0))
	,BINRange = MAX(t.BINRange)
	,PAN = MAX(ISNULL(t.PAN, N''))
	,ResponseCodeInternal = MAX(t.ResponseCodeInternal)
	,NetworkId = MAX(t.NetworkId)
	,DestCode = MAX(
		CASE
			WHEN t.CurrencyRequest = 840 AND t.NetworkId IN (840117, 840217, 840317, 840118, 840218, 840318) THEN 7 -- CIBC
			WHEN t.CurrencyRequest = 840 AND t.NetworkId IN (840113, 840213, 840313) THEN 2 -- WorldPay
			WHEN t.CurrencyRequest = 840 AND t.TransactionType IN (7, 8, 9) THEN 2 -- 7:Purchase, 8:Pre-auth, 9:Pre-auth Complete, 
			WHEN t.CurrencyRequest = 840 AND t.NetworkId IN (840114, 840214, 840314) THEN 3 -- US Bank Portland
			WHEN t.CurrencyRequest = 840 AND t.NetworkId IN (840115, 840215, 840315) THEN 4 -- US Bank St. Paul
			WHEN t.CurrencyRequest = 840 AND t.NetworkId = -1 THEN 0 -- ?
			WHEN t.CurrencyRequest = 840 THEN 101 -- PULSE
			WHEN t.CurrencyRequest = 124 AND t.NetworkId IN (124101, 124201, 124301) THEN 1 -- Moneris
			WHEN t.CurrencyRequest = 124 AND t.NetworkId IN (124103, 124203, 124303, 124104, 124204, 124304) THEN 5 -- STAR
			WHEN t.CurrencyRequest = 124 AND t.NetworkId IN (124105, 124205, 124305, 124106, 124206, 124306) THEN 10 -- Interac(ACI): 10 to 29
			WHEN t.CurrencyRequest = 124 AND t.NetworkId IN (124107, 124207, 124307, 124108, 124208, 124308) THEN 7 -- CIBC
			WHEN t.CurrencyRequest = 124 AND t.NetworkId IN (124117, 124217, 124317, 124118, 124218, 124318) THEN 7
			ELSE 0
		END)
	,AmountRequest = CAST(MAX(t.AmountRequest)/100.0 AS MONEY)
	,AmountSettlement = CAST(MAX(
		CASE 
			WHEN t.ResponseCodeInternal <> 0 THEN 0
			WHEN t.TransactionType = 3 THEN 0
			WHEN t.TransactionState = 2 AND d.QuestionablePolicy <> 1 THEN 0 -- questionable trans
			ELSE t.AmountSettlement + ISNULL(r.AmountSettlement, 0)
		END)/100.0 AS MONEY)
	,AmountSurcharge = CAST(MAX(
		CASE 
			WHEN t.ResponseCodeInternal <> 0 THEN 0
			WHEN t.TransactionType = 3 THEN 0
			WHEN t.TransactionState = 2 AND d.QuestionablePolicy <> 1 THEN 0 -- questionable trans
			ELSE t.AmountSurcharge + ISNULL(r.AmountSurcharge, 0)
		END)/100.0 AS MONEY)
	,AmountGatewayDebit = NULL
	,AmountInterchangeCollected = NULL
	,AmountGatewayProcFee = NULL
	,TerminalName = MAX(ISNULL(CAST(cctx.TERM_ID AS NVARCHAR), d.TerminalName))
	--,TerminalName = MAX(d.TerminalName)
	,CurrencyRequest = MAX(t.CurrencyRequest)
	,TransactionFlags = MAX(t.TransactionFlags)
	,IssuerNetworkId = MAX(t.IssuerNetworkId)
FROM dbo.tbl_trn_Transaction t(NOLOCK)
	LEFT JOIN dbo.tbl_trn_Transaction r(NOLOCK) -- reversals
		ON t.Id = r.OriginalTransactionId
		AND (r.TransactionType BETWEEN 101 AND 112) -- all reversal tran type
		--AND r.TransactionReason <> 7 -- timeout
		AND r.OriginalTransactionId IS NOT NULL
		AND (r.CurrencyRequest = 840 AND r.SystemTime >= @StartTime1 AND r.SystemTime < DATEADD(HOUR, 26, @EndTime1)
			OR r.CurrencyRequest = 124 AND r.SystemTime >= @StartTime2 AND r.SystemTime < DATEADD(HOUR, 26, @EndTime2))
	JOIN dbo.tbl_Device d(NOLOCK) 
		ON t.DeviceId = d.Id
	--LEFT JOIN ecage.dbo.cctxlog cctx(NOLOCK)
	LEFT JOIN dbo.cctxlog cctx(NOLOCK)
		ON t.TransactionType = 9
		  AND cctx.[TIMESTAMP] BETWEEN DATEADD(HOUR, -6, @SettDate) AND DATEADD(HOUR, 31, @SettDate)
		  AND cctx.TRANS_SEQ_NUM = CAST(t.DeviceSequence AS VARCHAR)
		  and cctx.CARD_NUM like CAST(t.BINRange AS VARCHAR) + '%' + CAST(t.pan AS VARCHAR)
		  and cctx.TRANS_TYPE IN ('CU', 'DS') AND (cctx.TERM_ID_SRC = CAST(d.TerminalName AS VARCHAR) or cctx.TERM_ID = CAST(d.TerminalName AS VARCHAR))
		  AND ((cctx.TRANS_TYPE = 'CU' AND t.TransactionFlags & 524288 > 0) OR (cctx.trans_type = 'DS' AND t.TransactionFlags & 524288 = 0))
		  AND CAST(cctx.AMOUNT*100 AS BIGINT) = t.AmountRequest
WHERE
	t.TransactionType NOT BETWEEN 101 AND 112 -- exclude all reversal tran
	-- exlcude the following transactions as well
	AND t.TransactionType <> 6 -- Pre-transaction request for Accounts associated with the inserted card
	AND t.TransactionType NOT BETWEEN 50 AND 99 -- ecage trans
	AND t.TransactionType NOT BETWEEN 150 AND 199 --?
	AND (t.CurrencyRequest = 840 AND t.SystemTime >= @StartTime1 AND t.SystemTime < @EndTime1
		OR t.CurrencyRequest = 124 AND t.SystemTime >= @StartTime2 AND t.SystemTime < @EndTime2)
	AND t.Id BETWEEN @MinTranID AND @MaxTranID
	AND t.CurrencyRequest = @CurrencyRequest
	--AND t.DeviceId = 2419
GROUP BY 
	t.DeviceId
	,t.DeviceDate
	,t.DeviceSequence
	,ISNULL(r.TransactionType, t.TransactionType)
)
INSERT INTO dbo.tbl_trn_TransactionConsolidated
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
	,TransactionFlags
	,IssuerNetworkId
	,ReconciliationStatus	
	,SettlementAllocationDate
	,SurchargeAllocationDate 
	,InterchangeAllocationDate
)
SELECT
	t.SettlementDate
	,DeviceId = d.Id
	,t.DeviceDate
	,t.DeviceSequence
	,t.TransactionType
	,t.TransactionId
	,t.SystemTime
	,t.NetworkSequence
	,t.BINRange
	,t.PAN
	,t.ResponseCodeInternal
	,t.NetworkId
	,t.DestCode
	,AmountRequest = 
		CASE 
			WHEN t.TransactionType IN (10, 11) THEN -t.AmountRequest --10:Merchandise Return, 11:Void Sale
			ELSE t.AmountRequest
		END
	,t.AmountSettlement
	,t.AmountSurcharge
	,t.AmountGatewayDebit
	,t.AmountInterchangeCollected
	,t.AmountGatewayProcFee
	,t.TerminalName
	,CAST(t.CurrencyRequest AS smallint)
	,t.TransactionFlags
	,t.IssuerNetworkId
	,ReconciliationStatus = CAST(1 AS tinyint) --Pending
	,SettlementAllocationDate = NULL
	,SurchargeAllocationDate = NULL
	,InterchangeAllocationDate = NULL
FROM cteTranTemp t
	JOIN dbo.tbl_Device d(NOLOCK)
		ON t.TerminalName = d.TerminalName

END
GO
GRANT EXECUTE ON  [dbo].[usp_trn_TransactionConsolidated_Load] TO [WebV4Role]
GO
