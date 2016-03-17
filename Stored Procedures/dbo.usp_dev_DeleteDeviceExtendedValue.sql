SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[usp_dev_DeleteDeviceExtendedValue]
@DeviceExtendedValueId bigint,
@UpdatedUserId         bigint,
@SmartAcquireId  bigint =0
AS
BEGIN
  SET NOCOUNT ON
  DECLARE @DeviceId bigint, @DeviceStatus bigint
  Select @DeviceId=DeviceId  FROM dbo.tbl_DeviceExtendedValue where Id=@DeviceExtendedValueId
  UPDATE dbo.tbl_DeviceExtendedValue SET UpdatedUserId=@UpdatedUserId WHERE Id=@DeviceExtendedValueId
  DELETE FROM dbo.tbl_DeviceExtendedValue WHERE Id=@DeviceExtendedValueId
  SELECT @DeviceStatus=DeviceStatus  FROM tbl_Device where Id=@DeviceId
  IF @DeviceStatus=1
  exec usp_acq_InsertDevicesUpdateCommands @SmartAcquireId,@DeviceId
  RETURN 0
END
GO
GRANT EXECUTE ON  [dbo].[usp_dev_DeleteDeviceExtendedValue] TO [WebV4Role]
GO
