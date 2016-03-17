SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[usp_bak_GetAccountsCashOwnerAll]
@Accountid bigint 
AS
-- Retrieve List of Cash Owners for Account
--
-- Revision 1.0.0 by Rocky Zhong
--   Initial Revision
SELECT ow.CashOwnerName, ow.CashOwnerDocTypeId,
  tv.Name, ow.DocumentNumber
FROM [tbl_Accounts_CashOwner] ow
      INNER JOIN [tbl_TypeValue] tv ON tv.Value = ow.CashOwnerDocTypeId AND tv.TypeId=193
WHERE ow.AccountId=@Accountid
ORDER BY ow.CashOwnerName, tv.Name, ow.DocumentNumber
GO
