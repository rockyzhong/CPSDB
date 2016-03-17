SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

/*
truncate table tbl_rec_TransactionPulseImport
truncate table tbl_rec_TransactionPulse
SELECT * FROM tbl_rec_TransactionPulseImport (NOLOCK)
SELECT * FROM tbl_rec_TransactionPulse (NOLOCK)

BCP CPS.dbo.tbl_rec_TransactionPulseImport IN "c:\recfile\D150419.PL.HXS.PRD1.DATA1.INT610" -S 10.1.9.101  -U sa  -P Password0 -c
BCP CPS.dbo.tbl_rec_TransactionPulseImport IN "c:\recfile\D150419.PL.HXS.PRD1.DATA1.INT554" -S 10.1.9.101  -U sa  -P Password0 -c

EXEC [dbo].[usp_rec_TransactionPulse_Load] '2015-02-12'
SELECT * FROM dbo.tbl_rec_TransactionPulse WHERE DateTimeSettlement = '2015-04-19' 
*/
CREATE PROCEDURE [dbo].[usp_rec_TransactionPulseImport_Del]
AS
BEGIN
SET NOCOUNT ON

TRUNCATE TABLE tbl_rec_TransactionPulseImport

END

GO
GRANT EXECUTE ON  [dbo].[usp_rec_TransactionPulseImport_Del] TO [WebV4Role]
GO
