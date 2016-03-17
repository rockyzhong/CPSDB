SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_dev_GetDeviceAlertPlusShift]
@DeviceId           bigint
AS
BEGIN
  SELECT DeviceId,ShiftId,WeekdayType,StartHour,EndHour,DeviceErrorEMail,InactivityEMail,CashThresholdEMail
  FROM dbo.tbl_DeviceAlertPlusShift
  WHERE DeviceId=@DeviceId
END
GO
