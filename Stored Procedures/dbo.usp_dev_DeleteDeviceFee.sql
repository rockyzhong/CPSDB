SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


---------------------------   Rzhong modified Deletled fee about iso level ---------

CREATE PROCEDURE [dbo].[usp_dev_DeleteDeviceFee] 
@DeviceFeeId        bigint,
@UpdatedUserId      bigint,
@SmartAcquireId  bigint =0
AS
BEGIN 
  SET NOCOUNT ON
  DECLARE @DeviceId bigint,@IsoId bigint,@DeviceStatus bigint
  select @DeviceId=DeviceId from dbo.tbl_DeviceFee where Id=@DeviceFeeId
  SELECT @DeviceStatus=DeviceStatus  FROM tbl_Device where Id=@DeviceId
  IF @DeviceStatus=1
  EXEC usp_acq_InsertDevicesUpdateCommands @SmartAcquireId,@DeviceId
  
  UPDATE dbo.tbl_DeviceFee SET UpdatedUserId=@UpdatedUserId WHERE Id=@DeviceFeeId
  DELETE FROM dbo.tbl_DeviceFee WHERE Id=@DeviceFeeId
 
  select @IsoId=IsoId from dbo.tbl_Device where Id=@DeviceId
  EXEC usp_acq_InsertISOUpdateCommands @SmartAcquireId,@IsoId
  RETURN 0
END
GO
GRANT EXECUTE ON  [dbo].[usp_dev_DeleteDeviceFee] TO [WebV4Role]
GO
