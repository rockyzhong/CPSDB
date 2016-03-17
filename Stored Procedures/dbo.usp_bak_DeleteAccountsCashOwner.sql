SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[usp_bak_DeleteAccountsCashOwner] 
@AccountId bigint,
@UpdatedUserId bigint
-- Delete new Cash Owner for Account
--
-- Revision 1.0.0 by Rocky Zhong
--   Initial Revision
AS
Update [dbo].[tbl_Accounts_CashOwner] SET UpdatedUserId=@UpdatedUserId WHERE AccountId=@AccountId
Delete FROM [dbo].[tbl_Accounts_CashOwner] WHERE AccountId=@AccountId

RETURN 0
GO
