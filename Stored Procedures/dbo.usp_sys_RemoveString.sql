SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[usp_sys_RemoveString]
@String1 nvarchar(max) OUTPUT,
@String2 nvarchar(max)
AS
BEGIN
  SET NOCOUNT ON

  DECLARE @S nvarchar(max)
  DECLARE @S1 TABLE(S nvarchar(max))
  DECLARE @S2 TABLE(S nvarchar(max))

  INSERT INTO @S1 EXEC dbo.usp_sys_Split @String1
  INSERT INTO @S2 EXEC dbo.usp_sys_Split @String2
  
  SET @String1=NULL
  DECLARE TempCursor CURSOR LOCAL FOR SELECT S FROM @S1 WHERE S NOT IN (SELECT S FROM @S2)
  OPEN TempCursor
  FETCH NEXT FROM TempCursor INTO @S
  WHILE @@FETCH_STATUS=0
  BEGIN
    IF @String1 IS NULL
      SET @String1=@S
    ELSE
      SET @String1=@String1+','+@S  
    FETCH NEXT FROM TempCursor INTO @S
  END
  CLOSE TempCursor
  DEALLOCATE TempCursor
END
GO
GRANT EXECUTE ON  [dbo].[usp_sys_RemoveString] TO [WebV4Role]
GO
