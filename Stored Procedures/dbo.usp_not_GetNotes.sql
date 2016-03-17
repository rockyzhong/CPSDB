SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_not_GetNotes]
@SourceType bigint,
@SourceId   bigint,
@UserId     bigint
AS
BEGIN
  SELECT Id NoteId,NoteType,NoteText,UpdatedDate,UpdatedUserId
  FROM dbo.tbl_Note
  WHERE SourceType=@SourceType AND SourceId=@SourceId AND (NoteType=0 OR UpdatedUserId=@UserId)
  ORDER BY Id
END
GO
GRANT EXECUTE ON  [dbo].[usp_not_GetNotes] TO [WebV4Role]
GO
