SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_gam_DeleteGamblersAddictionState]
@GamblersAddictionStateId bigint,
@UpdatedUserId            bigint
AS
BEGIN
  SET NOCOUNT ON

  UPDATE dbo.tbl_GamblersAddictionState SET UpdatedUserId=@UpdatedUserId WHERE Id=@GamblersAddictionStateId
  DELETE FROM dbo.tbl_GamblersAddictionState WHERE Id=@GamblersAddictionStateId

  RETURN 0
END
GO
GRANT EXECUTE ON  [dbo].[usp_gam_DeleteGamblersAddictionState] TO [WebV4Role]
GO
