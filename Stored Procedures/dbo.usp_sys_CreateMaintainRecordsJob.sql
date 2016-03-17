SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/**/
/**/
/**/
CREATE  PROCEDURE [dbo].[usp_sys_CreateMaintainRecordsJob]
@Add nvarchar(10) = N'Y',
@Delete nvarchar(10) = N'N'
AS
BEGIN
  DECLARE @DBName nvarchar(128),@Script nvarchar(4000)
  SELECT @DBName=db_name(dbid) FROM master..sysprocesses WHERE spid=@@SPID
  SET @Script='
    EXEC '+@DBName+'.dbo.usp_sys_ClearupExpiredRecords
    EXEC '+@DBName+'.dbo.usp_dev_UpdateDeviceFirstTransactionDate
  '

  DECLARE @JobName nvarchar(128)
  SET @JobName=N'Maintain records of '+@DBName
  IF @Delete='Y' AND EXISTS (SELECT job_id FROM msdb.dbo.sysjobs_view WHERE name = @JobName)
    EXEC msdb.dbo.sp_delete_job @job_name = @JobName 
  IF @Add='Y' AND NOT EXISTS (SELECT job_id FROM msdb.dbo.sysjobs_view WHERE name = @JobName)
    EXEC [dbo].[usp_sys_CreateCommonJob] @Name=@JobName,@Script=@Script,@StratTime=4500
END
GO
