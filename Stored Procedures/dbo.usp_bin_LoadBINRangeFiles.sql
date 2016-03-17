SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_bin_LoadBINRangeFiles]
AS 
BEGIN
  SET NOCOUNT ON

  DECLARE @BINRangeImportDir nvarchar(1000),@BINRangeHistoryDir nvarchar(1000)
  SELECT @BINRangeImportDir =Value FROM dbo.tbl_Parameter where Name='BINRangeImportDir'
  SELECT @BINRangeHistoryDir=Value FROM dbo.tbl_Parameter where Name='BINRangeHistoryDir'
  IF @BINRangeImportDir IS NOT NULL AND @BINRangeHistoryDir IS NOT NULL
  BEGIN
    DECLARE @Command nvarchar(1000),@FileName nvarchar(200),@FilePath nvarchar(200),@FilePath0 nvarchar(200)
    DECLARE @Line TABLE(Line nvarchar(1000))
    DECLARE @File TABLE(FileName nvarchar(200))
  
    SET @Command = 'DIR "' + @BINRangeImportDir+'" /TW' 
    INSERT INTO @Line EXEC master..xp_cmdshell @Command 
    DELETE FROM @Line WHERE Line IS NULL OR Line LIKE '%<%>%' OR Line LIKE '%Directory%' OR Line NOT LIKE '%:%'
    INSERT INTO @File(FileName) SELECT REVERSE(LEFT(REVERSE(Line),CHARINDEX(' ',REVERSE(Line))-1 )) FROM @Line

    DECLARE TempCursor CURSOR LOCAL FOR SELECT a.FileName FROM @File a JOIN dbo.tbl_BINRangeFile b ON a.FileName LIKE b.FileName ORDER BY b.Priority
    OPEN TempCursor
    FETCH NEXT FROM TempCursor INTO @FileName
    WHILE @@FETCH_STATUS=0
    BEGIN
      SET @FilePath=@BINRangeImportDir+'\'+@FileName
      EXEC dbo.usp_bin_LoadBINRangeFile @FilePath 

      SET @FilePath0=@BINRangeHistoryDir+'\'+@FileName
      SET @Command = 'MOVE /Y "' + @FilePath+'" "'+ @FilePath0+'"'
      EXEC master..xp_cmdshell @Command
      
      FETCH NEXT FROM TempCursor INTO @FileName
    END
    CLOSE TempCursor
    DEALLOCATE TempCursor
  END  
END
GO
