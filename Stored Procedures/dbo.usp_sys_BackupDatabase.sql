SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/**/
/**/
/**/
CREATE PROCEDURE [dbo].[usp_sys_BackupDatabase]
AS
BEGIN
  SET NOCOUNT ON

  DECLARE @DBName nvarchar(128),@BackupDir nvarchar(1000),@BackupDBDir nvarchar(1000),@BackupFile nvarchar(1000),@BacupkDate datetime,@Command nvarchar(1000)
  SELECT @DBName=db_name(dbid) FROM master..sysprocesses WHERE spid=@@SPID
  SELECT @BackupDir=Value FROM dbo.tbl_Parameter WHERE Name=N'BackupDir'

  SET @BackupDBDir=@BackupDir+'\'+@DBName
  SET @Command = 'mkdir "' + @BackupDBDir+'"'
  EXEC master.dbo.xp_cmdshell @command , no_output  

  SET @BacupkDate=GETDATE()
  SET @BackupFile=@BackupDBDir+'\'+@DBName+'_'+LTRIM(STR(YEAR(@BacupkDate)))+RIGHT('0'+LTRIM(STR(MONTH(@BacupkDate))),2)+RIGHT('0'+LTRIM(STR(Day(@BacupkDate))),2)+RIGHT('0'+LTRIM(STR(DatePart(hh,@BacupkDate))),2)+RIGHT('0'+LTRIM(STR(DatePart(mi,@BacupkDate))),2)+'_FULL.BAK'
  BACKUP DATABASE @DBName TO DISK=@BackupFile WITH DESCRIPTION=@BackupFile
END
GO
GRANT EXECUTE ON  [dbo].[usp_sys_BackupDatabase] TO [WebV4Role]
GO
