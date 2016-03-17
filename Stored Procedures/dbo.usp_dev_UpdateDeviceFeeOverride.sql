SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[usp_dev_UpdateDeviceFeeOverride] 
@FeeOverrideId       bigint,
@FeeOverridePriority bigint,
@FeeFixed            bigint,
@FeePercentage       bigint,
@UpdatedUserId       bigint,
@SmartAcquireId  bigint =0
AS
BEGIN 
  SET NOCOUNT ON
  DECLARE @DeviceId bigint , @DeviceStatus bigint
  SELECT @DeviceId=deviceid FROM tbl_DeviceFeeOverride  WHERE Id=@FeeOverrideId
  UPDATE dbo.tbl_DeviceFeeOverride SET 
  FeeOverridePriority=@FeeOverridePriority,FeeFixed=@FeeFixed,FeePercentage=@FeePercentage,UpdatedUserId=@UpdatedUserId
  WHERE Id=@FeeOverrideId
  
  SELECT @DeviceStatus=DeviceStatus  FROM tbl_Device where Id=@DeviceId
  IF @DeviceStatus=1
  exec usp_acq_InsertDevicesUpdateCommands @SmartAcquireId,@DeviceId
  RETURN 0
END
GO
GRANT EXECUTE ON  [dbo].[usp_dev_UpdateDeviceFeeOverride] TO [WebV4Role]
GO
