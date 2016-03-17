SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[usp_dev_UpdateDeviceRoutingFlags]
@DeviceId        bigint,
@RoutingFlags    bigint,
@UpdatedUserId   bigint,
@SmartAcquireId  bigint =0
AS
BEGIN
  SET NOCOUNT ON
  DECLARE @DeviceStatus bigint
  UPDATE dbo.tbl_Device SET 
  RoutingFlags=@RoutingFlags,UpdatedDate=GETUTCDATE(),UpdatedUserId=@UpdatedUserId 
  WHERE Id=@DeviceId
  SELECT @DeviceStatus=DeviceStatus  FROM tbl_Device where Id=@DeviceId
  IF @DeviceStatus=1
  exec usp_acq_InsertDevicesUpdateCommands @SmartAcquireId,@DeviceId
  RETURN 0
END
GO
GRANT EXECUTE ON  [dbo].[usp_dev_UpdateDeviceRoutingFlags] TO [WebV4Role]
GO
