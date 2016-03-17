SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_dev_SetDeviceAlertPlusThreshold]
@DeviceId           bigint,
@CassetteId         bigint,
@WarningLevel       bigint,
@UrgentLevel        bigint,
@UpdatedUserId      bigint
--@SmartAcquireId  bigint =0
AS
BEGIN
  SET NOCOUNT ON
  IF NOT EXISTS(SELECT Id FROM dbo.tbl_DeviceCassette WHERE DeviceId=@DeviceId AND CassetteId=@CassetteId)
    INSERT INTO dbo.tbl_DeviceCassette(DeviceId,CassetteId,WarningLevel,UrgentLevel,UpdatedUserId)
    VALUES(@DeviceId,@CassetteId,@WarningLevel,@UrgentLevel,@UpdatedUserId)
  ELSE
    UPDATE dbo.tbl_DeviceCassette SET 
    WarningLevel=@WarningLevel,UrgentLevel=@UrgentLevel,UpdatedUserId=@UpdatedUserId
    WHERE DeviceId=@DeviceId AND CassetteId=@CassetteId
 -- exec usp_acq_InsertDevicesUpdateCommands @SmartAcquireId,@DeviceId  
    
  RETURN 0
END
GO
