SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[usp_dev_DeleteDeviceCassette]
@DeviceCassetteId      bigint,
@UpdatedUserId         bigint,
@SmartAcquireId  bigint =0
AS
BEGIN
  SET NOCOUNT ON
  DECLARE @DeviceId bigint, @DeviceStatus bigint
  SELECT @DeviceId=DeviceId from dbo.tbl_DeviceCassette WHERE Id=@DeviceCassetteId
  Update dbo.tbl_DeviceCassette SET UpdatedUserId=@UpdatedUserId WHERE Id=@DeviceCassetteId
  DELETE FROM dbo.tbl_DeviceCassette WHERE Id=@DeviceCassetteId
  SELECT @DeviceStatus=DeviceStatus  FROM tbl_Device where Id=@DeviceId
  IF @DeviceStatus=1
  exec usp_acq_InsertDevicesUpdateCommands @SmartAcquireId,@DeviceId
  RETURN 0
END
GO
GRANT EXECUTE ON  [dbo].[usp_dev_DeleteDeviceCassette] TO [WebV4Role]
GO
