SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

/*
EXEC dbo.usp_rec_TransactionCIBCInterchange_Del '2015-05-14', 124
TRUNCATE TABLE dbo.tbl_rec_TransactionCIBCInterchange
TRUNCATE TABLE dbo.tbl_rec_TransactionCIBCInterchangeSummary 
select * from dbo.tbl_rec_TransactionCIBCInterchange
select * from dbo.tbl_rec_TransactionCIBCInterchangeSummary 

*/
CREATE PROC [dbo].[usp_rec_TransactionCIBCInterchange_Del]
	@pFileDate datetime
	,@pCurrency smallint
AS
BEGIN
SET NOCOUNT ON

DELETE FROM dbo.tbl_rec_TransactionCIBCInterchange
WHERE FileDate = @pFileDate
	AND CurrencyCode = @pCurrency

DELETE FROM dbo.tbl_rec_TransactionCIBCInterchangeSummary
WHERE FileDate = @pFileDate
	AND CurrencyCode = @pCurrency
END

GO
GRANT EXECUTE ON  [dbo].[usp_rec_TransactionCIBCInterchange_Del] TO [WebV4Role]
GO
