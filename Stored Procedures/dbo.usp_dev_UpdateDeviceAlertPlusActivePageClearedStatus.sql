SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[usp_dev_UpdateDeviceAlertPlusActivePageClearedStatus]
@DeviceId       bigint,
@AccessoryCode  bigint,
@ErrorCode      bigint,
@Pagetype       bigint,
@UpdatedUserId  bigint
--@SmartAcquireId  bigint =0
AS
BEGIN
  SET NOCOUNT ON
  
  UPDATE dbo.tbl_DeviceAlertPlusActivePage SET ClearedStatus=1,UpdatedUserId=@UpdatedUserId
  WHERE DeviceId=@DeviceId AND AccessoryCode=@AccessoryCode AND ErrorCode=@ErrorCode AND Pagetype=@Pagetype
 -- exec usp_acq_InsertDevicesUpdateCommands @SmartAcquireId,@DeviceId
  RETURN 0
END
GO
