SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/**/
/**/
/**/
CREATE PROCEDURE [dbo].[usp_sys_CreateClearupBackupFilesJob]
@Add nvarchar(10) = N'Y',
@Delete nvarchar(10) = N'N'
AS
BEGIN
DECLARE @BackupDir nvarchar(1000),@BackupExpiredDays int
SELECT @BackupDir=Value FROM dbo.tbl_Parameter WHERE Name='BackupDir'
SELECT @BackupExpiredDays=Value FROM dbo.tbl_Parameter WHERE Name='BackupExpiredDays'

DECLARE @Script nvarchar(4000)
SET @Script=N'
 Option Explicit
 Dim oFSO
 Dim oFolder
 Dim oSubFolder
 Dim oFile
 Dim sDirectoryPath
 Dim iDaysOld
 Dim dMaxDate

 sDirectoryPath = "' + @BackupDir + N'"
 iDaysOld = '+LTRIM(STR(@BackupExpiredDays))+N'

 Set oFSO = CreateObject("Scripting.FileSystemObject")
 set oFolder = oFSO.GetFolder(sDirectoryPath)
 For each oSubFolder in oFolder.SubFolders 
   dMaxDate=DateSerial(2000,1,1)
   For each oFile in oSubFolder.Files
     If oFile.DateLastModified > dMaxDate Then
         dMaxDate=oFile.DateLastModified
     End If
   Next
   
   For each oFile in oSubFolder.Files
     If oFile.DateLastModified < (dMaxDate - iDaysOld) Then
         oFile.Delete(True)
     End If
   Next
 Next

 Set oFSO = Nothing
 Set oFolder = Nothing
 Set oSubFolder = Nothing
 Set oFile = Nothing'

DECLARE @JobName nvarchar(128)
SET @JobName=N'Clear up backup files' 
IF @Delete='Y' AND EXISTS (SELECT job_id FROM msdb.dbo.sysjobs_view WHERE name = @JobName)
  EXEC msdb.dbo.sp_delete_job @job_name = @JobName 
IF @Add='Y' AND NOT EXISTS (SELECT job_id FROM msdb.dbo.sysjobs_view WHERE name = @JobName)
  EXEC [dbo].[usp_sys_CreateCommonJob] @Name=@JobName,@ScriptType=N'VBScript',@Script=@Script,@StratTime=1500

END
GO
GRANT EXECUTE ON  [dbo].[usp_sys_CreateClearupBackupFilesJob] TO [WebV4Role]
GO
