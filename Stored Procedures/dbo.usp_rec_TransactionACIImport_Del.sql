SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

/*
EXEC dbo.usp_rec_TransactionACIImport_Del
TRUNCATE TABLE dbo.tbl_rec_TransactionACIImport
select * from dbo.tbl_rec_TransactionACIImport


*/
CREATE PROC [dbo].[usp_rec_TransactionACIImport_Del]
AS
BEGIN
SET NOCOUNT ON

TRUNCATE TABLE dbo.tbl_rec_TransactionACIImport

END

GO
GRANT EXECUTE ON  [dbo].[usp_rec_TransactionACIImport_Del] TO [WebV4Role]
GO
