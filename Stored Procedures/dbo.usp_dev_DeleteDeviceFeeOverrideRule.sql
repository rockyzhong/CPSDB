SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[usp_dev_DeleteDeviceFeeOverrideRule] 
@FeeOverrideRuleId bigint,
@UpdatedUserId     bigint,
@SmartAcquireId  bigint =0
AS
BEGIN 
  SET NOCOUNT ON
  DECLARE @DeviceId bigint,@DeviceStatus bigint
  SELECT @DeviceId=deviceid from dbo.tbl_DeviceFeeOverride where Id= (SELECT FeeOverrideId from dbo.tbl_DeviceFeeOverrideRule WHERE Id=@FeeOverrideRuleId)
  UPDATE dbo.tbl_DeviceFeeOverrideRule SET UpdatedUserId=@UpdatedUserId WHERE Id=@FeeOverrideRuleId
  DELETE FROM dbo.tbl_DeviceFeeOverrideRule WHERE Id=@FeeOverrideRuleId
  SELECT @DeviceStatus=DeviceStatus  FROM tbl_Device where Id=@DeviceId
  IF @DeviceStatus=1
  exec usp_acq_InsertDevicesUpdateCommands @SmartAcquireId,@DeviceId
  RETURN 0
END


GO
GRANT EXECUTE ON  [dbo].[usp_dev_DeleteDeviceFeeOverrideRule] TO [WebV4Role]
GO
