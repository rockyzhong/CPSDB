SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_gam_UpdateGamblersAddictionState]
@GamblersAddictionStateId bigint,
@RegionId                 bigint,
@SSN                      nvarchar(50),
@IdState                  nvarchar(2),
@IdNumber                 nvarchar(30),
@UpdatedUserId            bigint
AS
BEGIN
  SET NOCOUNT ON

  UPDATE dbo.tbl_GamblersAddictionState SET RegionId=@RegionId,SSN=@SSN,IdState=@IdState,IdNumber=@IdNumber,UpdatedDate=GETUTCDATE(),UpdatedUserId=@UpdatedUserId
  WHERE Id=@GamblersAddictionStateId

  RETURN 0
END
GO
GRANT EXECUTE ON  [dbo].[usp_gam_UpdateGamblersAddictionState] TO [WebV4Role]
GO
