SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

/*
EXEC dbo.usp_rec_TransactionACIImport_Validate

*/
CREATE PROC [dbo].[usp_rec_TransactionACIImport_Validate]
AS
BEGIN
SET NOCOUNT ON

SELECT 
	COUNT(*) AS RecordCount
	,ISNULL((SUM(CASE 
					WHEN ISNUMERIC(PAN) = '' THEN CONVERT(bigint, 0)
					ELSE CONVERT(bigint, LEFT(PAN, 12)) 
				END) % CONVERT(bigint, 1000000000000)) + (SUM(IntMsgAmount1) % CONVERT(bigint, 1000000000000)), CONVERT(bigint, 0)) AS ChecksumTotal
FROM dbo.tbl_rec_TransactionACIImport (NOLOCK)

END
GO
GRANT EXECUTE ON  [dbo].[usp_rec_TransactionACIImport_Validate] TO [WebV4Role]
GO
