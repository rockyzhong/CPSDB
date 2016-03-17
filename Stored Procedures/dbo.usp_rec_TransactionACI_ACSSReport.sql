SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

/*
SELECT * FROM dbo.tbl_rec_TransactionACIImport
SELECT * FROM dbo.tbl_rec_TransactionACI
SELECT * FROM dbo.tbl_rec_TransactionACINode
SELECT * FROM dbo.tbl_rec_TransactionACISummary
EXEC dbo.usp_rec_TransactionACI_ACSSReport '2015-04-19'

SELECT DISTINCT RecordType FROM dbo.tbl_rec_TransactionACI
*/


CREATE PROCEDURE [dbo].[usp_rec_TransactionACI_ACSSReport]
	@pSettDate datetime, 
	@pCurrency smallint = 124,
	@pService char(3) = 'SCD'
AS
BEGIN
SET NOCOUNT ON

SELECT 
	NodeID AS IntMsgCardFIID,
	InstName,
	ACSSDebitCount,
	ACSSDebitAmount,
	ACSSCreditCount,
	ACSSCreditAmount,
	NetDepositAmount,
	SettlementRegion
FROM dbo.tbl_rec_TransactionACISummary (NOLOCK)
WHERE 
	DateTimeSettlement = @pSettDate 
	AND Currency = @pCurrency
	AND [Service] = 'SCD'
ORDER BY SettlementRegion, NodeID
--END
--ELSE -- IDP
--BEGIN
--  SELECT NodeID AS IntMsgCardFIID,
--    InstName,
--    ACSSDebitCount,
--    ACSSDebitAmount,
--    ACSSCreditCount,
--    ACSSCreditAmount,
--    NetDepositAmount,
--    SettlementRegion
--  FROM [tbl_SPS_ACI_IDP_ACSSTotals]
--  WHERE DateTimeSettlement = @pSettDate AND [Service] = @pService
--  ORDER BY SettlementRegion, NodeID
--END

END
GO
GRANT EXECUTE ON  [dbo].[usp_rec_TransactionACI_ACSSReport] TO [WebV4Role]
GO
