SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[usp_bak_UpdateAccountsCashOwner]
@Id bigint,
@AccountId  bigint  ,
@CashOwnerName nvarchar(128),
@CashOwnerDocTypeId bigint,
@DocumentNumber nvarchar(128), 
@UpdatedUserId bigint
-- Update new Cash Owner for Account
--
-- Revision 1.0.0 by Rocky Zhong
--   Initial Revision
AS
Update [dbo].[tbl_Accounts_CashOwner] SET  AccountID=@AccountId, CashOwnerName=@CashOwnerName, CashOwnerDocTypeId=@CashOwnerDocTypeId, DocumentNumber=@DocumentNumber,UpdatedUserId=@UpdatedUserId
WHERE Id=@Id
RETURN 0
GO
