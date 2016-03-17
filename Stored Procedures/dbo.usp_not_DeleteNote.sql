SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[usp_not_DeleteNote]
@NoteId        bigint,
@UpdatedUserId bigint
AS
BEGIN
  SET NOCOUNT ON

  UPDATE dbo.tbl_Note SET UpdatedUserId=@UpdatedUserId WHERE Id=@NoteId
  DELETE FROM dbo.tbl_Note WHERE Id=@NoteId

  RETURN 0
END
GO
GRANT EXECUTE ON  [dbo].[usp_not_DeleteNote] TO [WebV4Role]
GO
