SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_dev_SetDeviceAlertPlus]
@DeviceId                    bigint,
@NotificationReason          bigint,
@DeviceErrorRepeatInterval   bigint,
@InactivityRepeatInterval    bigint,
@CashThresholdRepeatInterval bigint,
@DeviceDownRepeatInterval    bigint,
@InactiveTime                bigint,
@AuditEnabled                bigint,
@AuditEmail                  nvarchar(200),
@UpdatedUserId               bigint
--@SmartAcquireId              bigint =0
AS
BEGIN
  SET NOCOUNT ON
  IF NOT EXISTS(SELECT Id FROM dbo.tbl_DeviceAlertPlus WHERE DeviceId=@DeviceId)
    INSERT INTO dbo.tbl_DeviceAlertPlus(DeviceId,NotificationReason,DeviceErrorRepeatInterval,InactivityRepeatInterval,CashThresholdRepeatInterval,DeviceDownRepeatInterval,InactiveTime,AuditEnabled,AuditEMail,UpdatedUserId)
    VALUES(@DeviceId,@NotificationReason,@DeviceErrorRepeatInterval,@InactivityRepeatInterval,@CashThresholdRepeatInterval,@DeviceDownRepeatInterval,@InactiveTime,@AuditEnabled,@AuditEMail,@UpdatedUserId)
  ELSE
    UPDATE dbo.tbl_DeviceAlertPlus SET 
    NotificationReason=@NotificationReason,DeviceErrorRepeatInterval=@DeviceErrorRepeatInterval,InactivityRepeatInterval=@InactivityRepeatInterval,
    CashThresholdRepeatInterval=@CashThresholdRepeatInterval,DeviceDownRepeatInterval=@DeviceDownRepeatInterval,InactiveTime=@InactiveTime,
    AuditEnabled=@AuditEnabled,AuditEmail=@AuditEmail,UpdatedUserId=@UpdatedUserId
    WHERE DeviceId=@DeviceId
 --   exec usp_acq_InsertDevicesUpdateCommands @SmartAcquireId,@DeviceId  
  RETURN 0
END
GO
