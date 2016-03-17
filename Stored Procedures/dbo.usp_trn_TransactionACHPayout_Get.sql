SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
/*
EXEC dbo.usp_trn_TransactionACHPayout_Get '2015-04-19', 1, 1

*/
CREATE PROC [dbo].[usp_trn_TransactionACHPayout_Get]
	@pSettDate datetime
	,@pACHFileID int
	,@pFileNo int
AS 
BEGIN
SET NOCOUNT ON

SELECT
	t.SettlementDate
	,t.ACHFileID
	,t.FileNo
	,t.BatchHeader
	,t.RTA
	,t.AccountType
	,t.RefName
	,t.HolderName
	,t.Amount
	,t.DueDate
	,t.StandardEntryCode
	,t.UserID
	,AddendaTypeCode = ISNULL(t.AddendaTypeCode, '  ')
	,AddendaInfo = ISNULL(t.AddendaInfo, '')
FROM dbo.tbl_trn_transactionACHPayout t(NOLOCK)
	JOIN dbo.tbl_AchFile f(NOLOCK)
		ON t.ACHFileID = f.Id
WHERE t.SettlementDate = @pSettDate
	AND t.ACHFileID = @pACHFileID
	AND t.FileNo = @pFileNo
	AND t.Amount <> 0
ORDER BY 
	(CASE WHEN f.AchFileFormat = 0 THEN t.BatchHeader ELSE '' END)
	,(CASE WHEN f.AchFileFormat = 0 THEN t.StandardEntryCode ELSE '' END)
	,t.DueDate
	,(CASE WHEN t.Amount >= 0 THEN 0 ELSE 1 END)
	,t.RefName
	,t.HolderName
	,t.RTA
	,t.AccountType
END
GO
GRANT EXECUTE ON  [dbo].[usp_trn_TransactionACHPayout_Get] TO [WebV4Role]
GO
