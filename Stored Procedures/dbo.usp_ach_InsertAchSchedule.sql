SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_ach_InsertAchSchedule]
@AchScheduleId            bigint OUTPUT,
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
@CreatedUserId            bigint,
@UpdatedUserId            bigint
AS
BEGIN
  SET NOCOUNT ON
  
  IF @EndDate IS NULL  SET @EndDate=CONVERT(datetime,'39991231',112)
  
  SET @StartDate=DATEADD(dd,0,DATEDIFF(dd,0,@StartDate))  --Remove time
  SET @EndDate  =DATEADD(dd,0,DATEDIFF(dd,0,@EndDate))    --Remove time

  INSERT INTO dbo.tbl_AchSchedule(AchFileId,ScheduleType,ScheduleDay,StartDate,EndDate,SourceType,SourceId,FundsType,SourceBankAccountId,DestinationBankAccountId,Amount,TaxList,StandardEntryClassCode,BatchHeader,Description,AchScheduleStatus,CreatedUserId,UpdatedUserId)
  VALUES(@AchFileId,@ScheduleType,@ScheduleDay,@StartDate,@EndDate,@SourceType,@SourceId,@FundsType,@SourceBankAccountId,@DestinationBankAccountId,@Amount,@TaxList,@StandardEntryClassCode,@BatchHeader,@Description,@AchScheduleStatus,@CreatedUserId,@UpdatedUserId)
  SELECT @AchScheduleId=IDENT_CURRENT('tbl_AchSchedule')

  RETURN 0
END
GO
GRANT EXECUTE ON  [dbo].[usp_ach_InsertAchSchedule] TO [WebV4Role]
GO
