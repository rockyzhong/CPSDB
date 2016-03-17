SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[usp_bak_InsertAccountsCashOwner]
	@AccountId  bigint  OUTPUT,
	@CashOwnerName nvarchar(128),
	@CashOwnerDocTypeId bigint,
	@DocumentNumber nvarchar(128), 
	@UpdatedUserId bigint =NULL
AS
-- Add new Cash Owner for Account
--
-- Revision 1.0.0 by Rocky Zhong
--   Initial Revision

INSERT INTO [tbl_Accounts_CashOwner]
(AccountID, CashOwnerName, CashOwnerDocTypeId, DocumentNumber,UpdatedUserId)
VALUES
(
  @AccountID,@CashOwnerName, @CashOwnerDocTypeId, @DocumentNumber,@UpdatedUserId
)
RETURN 0
GO
