SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[usp_dev_UpdateDeviceError]
@DeviceId         bigint,    
@AccessoryCode    bigint,
@ErrorCode        bigint,
@ResolvedText     nvarchar(80),
@UpdatedUserId    bigint =0,
@SmartAcquireId        bigint =0
AS
BEGIN
  SET NOCOUNT ON
  DECLARE  @DeviceStatus bigint
  
  UPDATE dbo.tbl_DeviceError SET ResolvedDate=GETUTCDATE(),ResolvedText=ISNULL(@ResolvedText,'Cleared from WebMon'),UpdatedUserId=@UpdatedUserId 
  WHERE DeviceId=@DeviceId AND AccessoryCode=@AccessoryCode AND ErrorCode=@ErrorCode AND ResolvedDate IS NULL
   -- Add update command for Smart Acquirer  
  SELECT @DeviceStatus=DeviceStatus  FROM tbl_Device where Id=@DeviceId
  IF @DeviceStatus=1
  exec [dbo].[usp_acq_InsertDevicesUpdateCommands] @SmartAcquireId,@DeviceId
  RETURN 0
END
GO
GRANT EXECUTE ON  [dbo].[usp_dev_UpdateDeviceError] TO [WebV4Role]
GO
