SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO


/*
TRUNCATE TABLE dbo.tbl_rec_TransactionCIBCInterchange
TRUNCATE TABLE dbo.tbl_rec_TransactionCIBCInterchangeSummary

SELECT * FROM dbo.tbl_rec_TransactionCIBCInterchange WHERE FileDate = '2015-04-19'
SELECT * FROM dbo.tbl_rec_TransactionCIBCInterchangeSummary WHERE FileDate = '2015-04-19'
SELECT * FROM dbo.tbl_trn_TransactionConsolidated WHERE SettlementDate = '2015-04-19' AND DestCode = 7

EXEC [dbo].[usp_rec_TransactionCIBCInterchange_MatchAndKill] '2015-04-19', 124

*/

CREATE PROCEDURE [dbo].[usp_rec_TransactionCIBCInterchange_MatchAndKill]
	@pFileDate datetime
	,@pCurrency smallint
AS
BEGIN
SET NOCOUNT ON

IF NOT EXISTS(SELECT TOP 1 1 FROM dbo.tbl_trn_TransactionConsolidated (NOLOCK) WHERE SettlementDate = @pFileDate AND CurrencyRequest = @pCurrency)
BEGIN
	EXEC dbo.usp_trn_TransactionConsolidated_Load @pFileDate, @pCurrency, 0
END

UPDATE t
SET AmountInterchangeCollected = i.AmountCompletedCAD
	,AmountGatewayProcFee = convert(money, 0.0175)
FROM dbo.tbl_trn_TransactionConsolidated t
	JOIN dbo.tbl_rec_TransactionCIBCInterchange i(NOLOCK)
		ON t.SettlementDate BETWEEN i.FileDate - 1 AND i.FileDate
		AND t.TerminalName = i.TerminalID
		AND t.NetworkSequence = i.RefNumInt
		AND t.SettlementDate = @pFileDate 
		AND t.DestCode = 7
		AND t.ResponseCodeInternal <> -99
		AND i.CurrencyCode = @pCurrency
		AND t.CurrencyRequest = @pCurrency



END
GO
GRANT EXECUTE ON  [dbo].[usp_rec_TransactionCIBCInterchange_MatchAndKill] TO [WebV4Role]
GO
