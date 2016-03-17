SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[usp_bak_GetAccounts_CashOwner_BlackList]
@CashOwnerName nvarchar(128) = NULL,
@CashOwnerDocTypeId bigint = NULL,
@DocumentNumber nvarchar(128) = NULL
AS
-- Check for Cash Owner match in blacklist, on either name or Document Type
--
-- Revision 1.0.0 2014.10.17 by Rocky Zhong
--   Initial Revision

SELECT CashOwnerName, ow.CashOwnerDocTypeId, tv.Name, DocumentNumber
FROM [tbl_Accounts_CashOwner_BlackList] ow
      INNER JOIN [tbl_TypeValue] tv ON tv.Value = ow.CashOwnerDocTypeId AND tv.TypeId=193
WHERE CashOwnerName = @CashOwnerName
  OR (ow.CashOwnerDocTypeId = @CashOwnerDocTypeId AND DocumentNumber = @DocumentNumber) 

GO
