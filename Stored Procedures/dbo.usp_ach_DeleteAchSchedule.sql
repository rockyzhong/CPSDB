SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_ach_DeleteAchSchedule]
@AchScheduleId            bigint,
@UpdatedUserId            bigint
AS
BEGIN
  SET NOCOUNT ON

  UPDATE dbo.tbl_AchSchedule SET UpdatedUserId=@UpdatedUserId WHERE Id=@AchScheduleId
  DELETE FROM dbo.tbl_AchSchedule WHERE Id=@AchScheduleId

  RETURN 0
END
GO
GRANT EXECUTE ON  [dbo].[usp_ach_DeleteAchSchedule] TO [WebV4Role]
GO
