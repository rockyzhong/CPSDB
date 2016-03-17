SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_gam_DeleteGamblersAddictionIso]
@GamblersAddictionIsoId bigint,
@UpdatedUserId          bigint
AS
BEGIN
  SET NOCOUNT ON

  UPDATE dbo.tbl_GamblersAddictionIso SET UpdatedUserId=@UpdatedUserId WHERE Id=@GamblersAddictionIsoId
  DELETE FROM dbo.tbl_GamblersAddictionIso WHERE Id=@GamblersAddictionIsoId

  RETURN 0
END
GO
GRANT EXECUTE ON  [dbo].[usp_gam_DeleteGamblersAddictionIso] TO [WebV4Role]
GO
