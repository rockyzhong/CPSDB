SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[usp_dev_DeleteDeviceAlertPlusThreshold]
@DeviceId      bigint,
@UpdatedUserId bigint
--@SmartAcquireId  bigint =0
AS
BEGIN
  SET NOCOUNT ON
  UPDATE dbo.tbl_DeviceCassette SET WarningLevel=NULL,UrgentLevel=NULL,ActiveThreshold=NULL,UpdatedUserId=@UpdatedUserId WHERE DeviceId=@DeviceId
  --exec usp_acq_InsertDevicesUpdateCommands @SmartAcquireId,@DeviceId
  RETURN 0
END
GO
