SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_trn_UpdateReferralTransaction]
@TransactionId bigint,
@SystemDate datetime,
@ApprovalCode nvarchar(50)
AS
BEGIN
  SET NOCOUNT ON
  UPDATE dbo.tbl_trn_Transaction SET ApprovalCode=@ApprovalCode where Id=@TransactionId
  RETURN 0
END
GO
GRANT EXECUTE ON  [dbo].[usp_trn_UpdateReferralTransaction] TO [SAV4Role]
GRANT EXECUTE ON  [dbo].[usp_trn_UpdateReferralTransaction] TO [WebV4Role]
GO
