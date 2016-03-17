SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

/*
EXEC dbo.usp_rec_TransactionMoneris_Del '2015-05-14', 124
TRUNCATE TABLE dbo.tbl_rec_TransactionMonerisImport
TRUNCATE TABLE dbo.tbl_rec_TransactionMonerisSummaryImport
select * from dbo.tbl_rec_TransactionMonerisImport
select * from dbo.tbl_rec_TransactionMonerisSummaryImport 

*/
CREATE PROC [dbo].[usp_rec_TransactionMonerisImport_Del]
AS
BEGIN
SET NOCOUNT ON

TRUNCATE TABLE dbo.tbl_rec_TransactionMonerisImport

TRUNCATE TABLE dbo.tbl_rec_TransactionMonerisSummaryImport

END

GO
GRANT EXECUTE ON  [dbo].[usp_rec_TransactionMonerisImport_Del] TO [WebV4Role]
GO
