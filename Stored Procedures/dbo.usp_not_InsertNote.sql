SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[usp_not_InsertNote]
@NoteId        bigint OUTPUT,
@SourceType    bigint,
@SourceId      bigint,
@NoteType      bigint,
@NoteText      nvarchar(500),
@UpdatedUserId bigint
AS
BEGIN
  SET NOCOUNT ON

  INSERT INTO dbo.tbl_Note(SourceType,SourceId,NoteType,NoteText,UpdatedDate,UpdatedUserId) 
  VALUES(@SourceType,@SourceId,@NoteType,@NoteText,GETUTCDATE(),@UpdatedUserId)
  SELECT @NoteId=IDENT_CURRENT('tbl_Note')

  RETURN 0
END
GO
GRANT EXECUTE ON  [dbo].[usp_not_InsertNote] TO [WebV4Role]
GO
