SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_gam_InsertGamblersAddictionState]
@GamblersAddictionStateId bigint OUT,
@RegionId                 bigint,
@SSN                      nvarchar(50),
@IdState                  nvarchar(2),
@IdNumber                 nvarchar(30),
@UpdatedUserId            bigint
AS
BEGIN
  SET NOCOUNT ON

  INSERT INTO dbo.tbl_GamblersAddictionState(RegionId,SSN,IdState,IdNumber,UpdatedDate,UpdatedUserId) 
  VALUES(@RegionId,@SSN,@IdState,@IdNumber,GETUTCDATE(),@UpdatedUserId)
  
  SELECT @GamblersAddictionStateId=IDENT_CURRENT('tbl_GamblersAddictionState')

  RETURN 0
END
GO
GRANT EXECUTE ON  [dbo].[usp_gam_InsertGamblersAddictionState] TO [WebV4Role]
GO
