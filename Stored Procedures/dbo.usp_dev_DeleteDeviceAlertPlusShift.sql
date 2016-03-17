SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[usp_dev_DeleteDeviceAlertPlusShift]
@DeviceId      bigint,
@UpdatedUserId bigint
--@SmartAcquireId  bigint =0
AS
BEGIN
  SET NOCOUNT ON
  UPDATE dbo.tbl_DeviceAlertPlusShift SET UpdatedUserId=@UpdatedUserId WHERE DeviceId=@DeviceId
  DELETE FROM dbo.tbl_DeviceAlertPlusShift WHERE DeviceId=@DeviceId
 -- exec usp_acq_InsertDevicesUpdateCommands @SmartAcquireId,@DeviceId
  RETURN 0
END
GO
