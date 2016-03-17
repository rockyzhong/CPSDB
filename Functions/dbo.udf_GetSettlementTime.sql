SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE FUNCTION [dbo].[udf_GetSettlementTime] (@DepositExec bigint,@DeviceId bigint,@SettlementDeviceOffDays bigint,@SettlementDate datetime,@Minute bigint,@ScheduleType bigint,@ScheduleDay bigint)
RETURNS datetime
AS
BEGIN
  DECLARE @Date datetime,@ThresholdClosedDate datetime
  IF @DepositExec=1
  BEGIN
    SET @ThresholdClosedDate=DATEADD(dd,-1*@SettlementDeviceOffDays,dbo.udf_GetScheduleDate(@SettlementDate,@Minute,1,0))
    SELECT @Date=MAX(ClosedDate) FROM dbo.tbl_DeviceDayClose WHERE DeviceId=@DeviceId AND ClosedDate>=@ThresholdClosedDate
    IF @Date IS NULL  SET @Date=@ThresholdClosedDate
  END
  ELSE 
    SET @Date=dbo.udf_GetScheduleDate(@SettlementDate,@Minute,@ScheduleType,@ScheduleDay)
  RETURN @Date
END
GO
