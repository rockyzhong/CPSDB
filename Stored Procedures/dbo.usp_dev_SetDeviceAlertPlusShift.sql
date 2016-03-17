SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_dev_SetDeviceAlertPlusShift]
@DeviceId           bigint,
@ShiftId            bigint,
@WeekdayType        bigint,
@StartHour          bigint,
@EndHour            bigint,
@DeviceErrorEMail   nvarchar(200),
@InactivityEMail    nvarchar(200),
@CashThresholdEMail nvarchar(200),
@UpdatedUserId      bigint
--@SmartAcquireId  bigint =0
AS
BEGIN
  SET NOCOUNT ON
  IF NOT EXISTS(SELECT Id FROM dbo.tbl_DeviceAlertPlusShift WHERE DeviceId=@DeviceId AND ShiftId=@ShiftId)
    INSERT INTO dbo.tbl_DeviceAlertPlusShift(DeviceId,ShiftId,WeekdayType,StartHour,EndHour,DeviceErrorEMail,InactivityEMail,CashThresholdEMail,UpdatedUserId)
    VALUES(@DeviceId,@ShiftId,@WeekdayType,@StartHour,@EndHour,@DeviceErrorEMail,@InactivityEMail,@CashThresholdEMail,@UpdatedUserId)
  ELSE
    UPDATE dbo.tbl_DeviceAlertPlusShift SET 
    WeekdayType=@WeekdayType,StartHour=@StartHour,EndHour=@EndHour,DeviceErrorEMail=@DeviceErrorEMail,
    InactivityEMail=@InactivityEMail,CashThresholdEMail=@CashThresholdEMail,UpdatedUserId=@UpdatedUserId
    WHERE DeviceId=@DeviceId AND ShiftId=@ShiftId
    
  --  exec usp_acq_InsertDevicesUpdateCommands @SmartAcquireId,@DeviceId  
  RETURN 0
END
GO
