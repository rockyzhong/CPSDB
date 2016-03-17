SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/**/
/**/
/**/
CREATE PROCEDURE [dbo].[usp_sys_CreateClearupBackupFilesJob1]
@Add nvarchar(10) = N'Y',
@Delete nvarchar(10) = N'N'
AS
BEGIN
DECLARE @BackupDir nvarchar(1000),@BackupExpiredDays int
SELECT @BackupDir=Value FROM dbo.tbl_Parameter WHERE Name='BackupDir'
SELECT @BackupExpiredDays=Value FROM dbo.tbl_Parameter WHERE Name='BackupExpiredDays'

DECLARE @Script nvarchar(4000)
SET @Script=N'
  SET NOCOUNT ON
  DECLARE @BackupDir nvarchar(1000),@Days int
  SET @BackupDir=N'''+@BackupDir+N'''
  SET @Days='+LTRIM(STR(@BackupExpiredDays))+N'

  CREATE TABLE #Line1(Line nvarchar(1000))
  CREATE TABLE #Line2(Line nvarchar(1000))
  DECLARE @File TABLE(FileName nvarchar(128),ModifiedDate datetime)
  DECLARE @Command nvarchar(1000),@SubDir nvarchar(128),@FileName nvarchar(128),@FilePath nvarchar(128),@MaxModifiedDate datetime

  SET @Command = ''DIR "'' + @BackupDir + ''" /TW'' 
  INSERT INTO #Line1 EXEC master..xp_cmdshell @Command 
  DELETE FROM #Line1 WHERE Line NOT LIKE ''%<%>%'' OR Line is null OR substring(Line,len(Line),1)=''.''
  
  DECLARE TempCursor CURSOR LOCAL FOR SELECT REVERSE( LEFT(REVERSE(Line),CHARINDEX('' '',REVERSE(Line))-1 ) ) FROM #Line1
  OPEN TempCursor
  FETCH NEXT FROM TempCursor INTO @SubDir
  WHILE @@FETCH_STATUS=0
  BEGIN
    DELETE FROM #Line2
    DELETE FROM @File
 
    --Insert Lines from dir output and delete Lines not containing FileName
    SET @Command = ''DIR "'' + @BackupDir+''\''+@SubDir + ''" /TW'' 
    INSERT INTO #Line2 EXEC master..xp_cmdshell @Command 
    DELETE FROM #Line2 WHERE  Line NOT LIKE ''%BAK%'' OR Line is null
 
    INSERT INTO @File(FileName) SELECT REVERSE(LEFT(REVERSE(Line),CHARINDEX('' '',REVERSE(Line))-1 )) FROM #Line2
    UPDATE @File SET ModifiedDate=CONVERT(datetime,SUBSTRING(FileName,CHARINDEX(''_'',FileName)+1,8),112)
  
    SET @MaxModifiedDate=CONVERT(datetime,''20000101'',112)
    SELECT @MaxModifiedDate=max(ModifiedDate) FROM @File

    DECLARE TempCursor1 CURSOR LOCAL FOR SELECT FileName FROM @File WHERE FileName LIKE N''%.bak'' AND ModifiedDate<DATEADD(dd,-1*@Days,@MaxModifiedDate)
    OPEN TempCursor1
    FETCH NEXT FROM TempCursor1 INTO @FileName
    WHILE @@FETCH_STATUS=0
    BEGIN
      SET @FilePath=@BackupDir+N''\''+@SubDir +N''\''+@FileName
      SET @Command=''del "''+ @FilePath+''"''
      EXEC master..xp_cmdshell @Command 

      FETCH NEXT FROM TempCursor1 INTO @FileName
    END
    CLOSE TempCursor1
    DEALLOCATE TempCursor1

    FETCH NEXT FROM TempCursor INTO @SubDir
  END
  CLOSE TempCursor
  DEALLOCATE TempCursor
  
  DROP TABLE #Line1
  DROP TABLE #Line2
'

DECLARE @JobName nvarchar(128)
SET @JobName=N'Clear up backup files 1' 
IF @Delete='Y' AND EXISTS (SELECT job_id FROM msdb.dbo.sysjobs_view WHERE name = @JobName)
  EXEC msdb.dbo.sp_delete_job @job_name = @JobName 
IF @Add='Y' AND NOT EXISTS (SELECT job_id FROM msdb.dbo.sysjobs_view WHERE name = @JobName)
  EXEC [dbo].[usp_sys_CreateCommonJob] @Name=@JobName,@Script=@Script,@StratTime=3000

END
GO
GRANT EXECUTE ON  [dbo].[usp_sys_CreateClearupBackupFilesJob1] TO [WebV4Role]
GO
