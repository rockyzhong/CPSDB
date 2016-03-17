SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_sys_CreateCommonJob](
@Name nvarchar(128),
@ScriptType nvarchar(128) = N'TSQL',
@Script nvarchar(4000) = N'',
@StartDate int = 19900101,
@EndDate int = 99991231,
@StratTime int = 0, 
@EndTime int = 235959,
@FreqType int = 4,
@FreqInterval int = 1,
@FreqRecurrenceFactor int = 0
)
AS
BEGIN
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0

/****** Object: Add JobCategory [Database Maintenance] IF Not Exists ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'Database Maintenance' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'Database Maintenance'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
END

/****** Object: Delete Job IF Exists ******/
IF  EXISTS (SELECT job_id FROM msdb.dbo.sysjobs_view WHERE name = @Name)
  EXEC msdb.dbo.sp_delete_job @job_name = @Name 

/****** Object:  Add Job ******/
DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=@Name, 
    @enabled=1, 
    @notify_level_eventlog=2, 
    @notify_level_email=0, 
    @notify_level_netsend=0, 
    @notify_level_page=0, 
    @delete_level=0, 
    @description=@Name, 
    @category_name=N'Database Maintenance', 
    @owner_login_name=N'sa', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

/****** Object:  Add Step ******/
DECLARE @Subsystem nvarchar(128),@DatabaseName nvarchar(128),@OnSuccessAction int
IF @ScriptType='TSQL'     BEGIN SET @Subsystem=@ScriptType        SET @DatabaseName=N'msdb'     END
IF @ScriptType='VBScript' BEGIN SET @Subsystem=N'ActiveScripting' SET @DatabaseName=@ScriptType END

EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=@Name, 
    @step_id=1, 
    @cmdexec_success_code=0, 
    @on_success_action=1, 
    @on_success_step_id=0, 
    @on_fail_action=2, 
    @on_fail_step_id=0, 
    @retry_attempts=0, 
    @retry_interval=0, 
    @os_run_priority=0, 
    @subsystem=@Subsystem, 
    @command=@Script, 
    @database_name=@DatabaseName, 
    @database_user_name=N'dbo', 
    @flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

/****** Object:  Add Schedule ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=@Name, 
    @enabled=1, 
    @freq_type=@FreqType, 
    @freq_interval=@FreqInterval, 
    @freq_subday_type=1, 
    @freq_subday_interval=0, 
    @freq_relative_interval=0, 
    @freq_recurrence_factor=@FreqRecurrenceFactor, 
    @active_start_date=@StartDate, 
    @active_end_date=@EndDate, 
    @active_start_time=@StratTime, 
    @active_end_time=@EndTime
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
END
GO
GRANT EXECUTE ON  [dbo].[usp_sys_CreateCommonJob] TO [WebV4Role]
GO
