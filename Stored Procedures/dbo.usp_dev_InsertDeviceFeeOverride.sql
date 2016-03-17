SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_dev_InsertDeviceFeeOverride] 
@FeeOverrideId       bigint OUTPUT,
@DeviceId            bigint,
@FeeOverridePriority bigint,
@FeeFixed            bigint,
@FeePercentage       bigint,
@UpdatedUserId       bigint,
@SmartAcquireId  bigint =0
AS
BEGIN 
  SET NOCOUNT ON
    DECLARE  @DeviceStatus bigint
  INSERT INTO dbo.tbl_DeviceFeeOverride(DeviceId,FeeOverridePriority,FeeFixed,FeePercentage,UpdatedUserId)
  VALUES(@DeviceId,@FeeOverridePriority,@FeeFixed,@FeePercentage,@UpdatedUserId)
  SELECT @FeeOverrideId=IDENT_CURRENT('tbl_DeviceFeeOverride')
  SELECT @DeviceStatus=DeviceStatus  FROM tbl_Device where Id=@DeviceId
  IF @DeviceStatus=1
  exec usp_acq_InsertDevicesUpdateCommands @SmartAcquireId,@DeviceId
  RETURN 0
END
GO
GRANT EXECUTE ON  [dbo].[usp_dev_InsertDeviceFeeOverride] TO [WebV4Role]
GO
