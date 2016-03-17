SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_dev_InsertDeviceFeeOverrideRule] 
@FeeOverrideRuleId   bigint OUTPUT,
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
  INSERT INTO dbo.tbl_DeviceFeeOverrideRule(FeeOverrideId,FeeOverrideType,FeeOverrideData,UpdatedUserId)
  VALUES(@FeeOverrideId,@FeeOverrideType,@FeeOverrideData,@UpdatedUserId)
  SELECT @FeeOverrideRuleId=IDENT_CURRENT('tbl_DeviceFeeOverrideRule')
  SELECT @DeviceStatus=DeviceStatus  FROM tbl_Device where Id=@DeviceId
  IF @DeviceStatus=1
  exec usp_acq_InsertDevicesUpdateCommands @SmartAcquireId,@DeviceId
  RETURN 0
END
GO
GRANT EXECUTE ON  [dbo].[usp_dev_InsertDeviceFeeOverrideRule] TO [WebV4Role]
GO
