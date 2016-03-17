SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[usp_not_UpdateNote]
@NoteId        bigint,
@SourceType    bigint,
@SourceId      bigint,
@NoteType      bigint,
@NoteText      nvarchar(500),
@UpdatedUserId bigint
AS
BEGIN
  SET NOCOUNT ON

  UPDATE dbo.tbl_Note SET
  SourceType=@SourceType,SourceId=@SourceId,NoteType=@NoteType,NoteText=@NoteText,UpdatedDate=GETUTCDATE(),UpdatedUserId=@UpdatedUserId
  WHERE Id=@NoteId

  RETURN 0
END
GO
GRANT EXECUTE ON  [dbo].[usp_not_UpdateNote] TO [WebV4Role]
GO
