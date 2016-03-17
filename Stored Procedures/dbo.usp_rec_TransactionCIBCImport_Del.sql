SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO


/*
EXEC dbo.usp_rec_TransactionCIBCImport_Del

*/
CREATE PROC [dbo].[usp_rec_TransactionCIBCImport_Del]
AS
BEGIN
SET NOCOUNT ON

TRUNCATE TABLE dbo.tbl_rec_TransactionCIBCImport

END

GO
GRANT EXECUTE ON  [dbo].[usp_rec_TransactionCIBCImport_Del] TO [WebV4Role]
GO
