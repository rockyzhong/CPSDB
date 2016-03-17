SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_dev_GetDeviceAlertPlus]
@DeviceId           bigint
AS
BEGIN
  SELECT DeviceId,NotificationReason,DeviceErrorRepeatInterval,InactivityRepeatInterval,CashThresholdRepeatInterval,DeviceDownRepeatInterval,InactiveTime,AuditEnabled,AuditEMail
  FROM dbo.tbl_DeviceAlertPlus
  WHERE DeviceId=@DeviceId
END
GO
