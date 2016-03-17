SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_dev_UpdateDeviceFeeOverrideRule] 
@FeeOverrideRuleId   bigint,
@FeeOverrideId       bigint,
@FeeOverrideType     bigint,
@FeeOverrideData     nvarchar(200),
@UpdatedUserId       bigint,
@SmartAcquireId      bigint =0
AS
BEGIN 
  SET NOCOUNT ON
  DECLARE @DeviceId bigint, @DeviceStatus bigint
  SELECT @DeviceId=deviceid FROM tbl_DeviceFeeOverride  WHERE Id=@FeeOverrideId
  UPDATE dbo.tbl_DeviceFeeOverrideRule SET 
  FeeOverrideId=@FeeOverrideId,FeeOverrideType=@FeeOverrideType,FeeOverrideData=@FeeOverrideData,UpdatedUserId=@UpdatedUserId
  WHERE Id=@FeeOverrideRuleId
  SELECT @DeviceStatus=DeviceStatus  FROM tbl_Device where Id=@DeviceId
  IF @DeviceStatus=1
  exec usp_acq_InsertDevicesUpdateCommands @SmartAcquireId,@DeviceId
  RETURN 0
END
GO
GRANT EXECUTE ON  [dbo].[usp_dev_UpdateDeviceFeeOverrideRule] TO [WebV4Role]
GO
