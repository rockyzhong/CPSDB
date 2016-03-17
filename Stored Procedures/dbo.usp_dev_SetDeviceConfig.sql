SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[usp_dev_SetDeviceConfig] 
@DeviceId              bigint,
@DeviceConfigFileId    bigint,
@DeviceOverrideFileId  bigint,
@ConfigID              nvarchar(5),
@UpdatedUserId         bigint,
@SmartAcquireId  bigint =0
AS
BEGIN
  SET NOCOUNT ON
  DECLARE  @DeviceStatus bigint
  IF NOT EXISTS(SELECT Id FROM dbo.tbl_DeviceConfig WHERE DeviceId=@DeviceId)
    INSERT INTO dbo.tbl_DeviceConfig(DeviceId,DeviceConfigFileId,DeviceOverrideFileId,ConfigID,UpdatedUserId)
    VALUES(@DeviceId,@DeviceConfigFileId,@DeviceOverrideFileId,@ConfigID,@UpdatedUserId)
  ELSE
    UPDATE dbo.tbl_DeviceConfig SET
    DeviceConfigFileId=@DeviceConfigFileId,DeviceOverrideFileId=@DeviceOverrideFileId,
    ConfigID=@ConfigID,UpdatedUserId=@UpdatedUserId
    WHERE DeviceId=@DeviceId
  SELECT @DeviceStatus=DeviceStatus  FROM tbl_Device where Id=@DeviceId
  IF @DeviceStatus=1
  exec usp_acq_InsertDevicesUpdateCommands @SmartAcquireId,@DeviceId
  RETURN 0
END
GO
