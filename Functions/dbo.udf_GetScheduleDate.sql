SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/***** Get schedule date *****/
CREATE FUNCTION [dbo].[udf_GetScheduleDate](@SettlementDate datetime,@Minute bigint,@ScheduleType bigint,@ScheduleDay bigint)
RETURNS datetime
AS
BEGIN
  DECLARE @ScheduleDate datetime
  IF @ScheduleType=2       -- Weekly
  BEGIN
     SET @ScheduleDate=DATEADD(dd,@ScheduleDay-DATEPART(dw,@SettlementDate),@SettlementDate)
     IF @ScheduleDate>@SettlementDate  SET @ScheduleDate=DATEADD(dd,-7,@ScheduleDate)
  END
  ELSE IF @ScheduleType=3  -- Monthly
  BEGIN
    SET @ScheduleDate=DATEADD(dd,@ScheduleDay-DATEPART(dd,@SettlementDate),@SettlementDate)
    IF @ScheduleDate>@SettlementDate  SET @ScheduleDate=DATEADD(mm,-1,@ScheduleDate)
  END
  ELSE                     -- Daily,threshold
    SET @ScheduleDate=@SettlementDate
  
  SET @ScheduleDate=DATEADD(mi,@Minute,@ScheduleDate)
  
  DECLARE @Year bigint,@DaylightSavingTimeBeginDate datetime,@DaylightSavingTimeEndDate datetime
  SET @Year=DATEPART(yy,@ScheduleDate)
  SET @DaylightSavingTimeBeginDate=DATEADD(hh,2,dbo.udf_GetSunday(@Year,3,2))
  SET @DaylightSavingTimeEndDate  =DATEADD(hh,2,dbo.udf_GetSunday(@Year,11,1))
  IF @ScheduleDate>=@DaylightSavingTimeBeginDate AND @ScheduleDate<@DaylightSavingTimeEndDate
    SET @ScheduleDate=DATEADD(hh,1,@ScheduleDate)
  
  RETURN @ScheduleDate
END
GO
