SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[usp_dev_DeleteDeviceFeeOverride] 
@FeeOverrideId bigint,
@UpdatedUserId bigint,
@SmartAcquireId  bigint =0
AS
BEGIN 
  SET NOCOUNT ON
  DECLARE @DeviceId bigint, @DeviceStatus bigint
  UPDATE dbo.tbl_DeviceFeeOverrideRule SET UpdatedUserId=@UpdatedUserId WHERE FeeOverrideId=@FeeOverrideId
  DELETE FROM dbo.tbl_DeviceFeeOverrideRule WHERE FeeOverrideId=@FeeOverrideId
  SELECT @DeviceId=deviceid from dbo.tbl_DeviceFeeOverride where Id=@FeeOverrideId
  UPDATE dbo.tbl_DeviceFeeOverride SET UpdatedUserId=@UpdatedUserId WHERE Id=@FeeOverrideId
  DELETE FROM dbo.tbl_DeviceFeeOverride WHERE Id=@FeeOverrideId
  SELECT @DeviceStatus=DeviceStatus  FROM tbl_Device where Id=@DeviceId
  IF @DeviceStatus=1
  exec usp_acq_InsertDevicesUpdateCommands @SmartAcquireId,@DeviceId
  RETURN 0
END
GO
GRANT EXECUTE ON  [dbo].[usp_dev_DeleteDeviceFeeOverride] TO [WebV4Role]
GO
