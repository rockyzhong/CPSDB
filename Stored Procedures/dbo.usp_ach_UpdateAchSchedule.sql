SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_ach_UpdateAchSchedule]
@AchScheduleId            bigint,
@AchFileId                bigint,
@ScheduleType             bigint,
@ScheduleDay              bigint,
@StartDate                datetime,
@EndDate                  datetime,
@SourceType               bigint,
@SourceId                 bigint,
@FundsType                bigint,
@SourceBankAccountId      bigint,
@DestinationBankAccountId bigint,
@Amount                   money,
@TaxList                  nvarchar(50),
@StandardEntryClassCode   nvarchar(50),
@BatchHeader              nvarchar(50),
@Description              nvarchar(200),
@AchScheduleStatus        bigint,
@UpdatedUserId            bigint
AS
BEGIN
  SET NOCOUNT ON

  IF @EndDate IS NULL  SET @EndDate=CONVERT(datetime,'39991231',112)

  SET @StartDate=DATEADD(dd,0,DATEDIFF(dd,0,@StartDate))  --Remove time
  SET @EndDate  =DATEADD(dd,0,DATEDIFF(dd,0,@EndDate))    --Remove time

  DECLARE @TodayDate datetime,@OpenDate datetime
  SET @TodayDate=DATEADD(dd,0,DATEDIFF(dd,0,GETUTCDATE()))             --Remove time
  IF @AchScheduleStatus=1 AND EXISTS(SELECT * FROM dbo.tbl_AchSchedule WHERE Id=@AchScheduleId AND AchScheduleStatus=2)
    SET @OpenDate=@TodayDate            

  UPDATE dbo.tbl_AchSchedule SET
  AchFileId=@AchFileId,ScheduleType=@ScheduleType,ScheduleDay=@ScheduleDay,StartDate=@StartDate,EndDate=@EndDate,OpenDate=ISNULL(@OpenDate,OpenDate),
  SourceType=@SourceType,SourceId=@SourceId,FundsType=@FundsType,SourceBankAccountId=@SourceBankAccountId,
  DestinationBankAccountId=@DestinationBankAccountId,Amount=@Amount,TaxList=@TaxList,StandardEntryClassCode=@StandardEntryClassCode,
  BatchHeader=@BatchHeader,Description=@Description,AchScheduleStatus=@AchScheduleStatus,UpdatedDate=GETUTCDATE(),UpdatedUserId=@UpdatedUserId
  WHERE Id=@AchScheduleId

  RETURN 0
END
GO
GRANT EXECUTE ON  [dbo].[usp_ach_UpdateAchSchedule] TO [WebV4Role]
GO
