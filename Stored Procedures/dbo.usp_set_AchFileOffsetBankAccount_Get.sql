SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_set_AchFileOffsetBankAccount_Get]
@pACHFileID int
AS
SELECT oba.[BankAccountId], ac.RTA
FROM [dbo].[tbl_AchFileOffsetBankAccount] oba
INNER JOIN [dbo].[tbl_BankAccount] ac
ON ac.ID = oba.BankAccountID
WHERE oba.ACHFileID = @pACHFileID
  AND oba.FundsType = 0
GO
