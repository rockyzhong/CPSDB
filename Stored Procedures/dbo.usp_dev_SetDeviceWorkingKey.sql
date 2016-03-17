SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_dev_SetDeviceWorkingKey]
  @DeviceId				   bigint,
  @WorkingPinKeyCryptogram nvarchar(32),
  @WorkingMacKeyCryptogram nvarchar(32),
  @UpdatedDate             datetime,
  @SmartAcquireId          bigint
AS
BEGIN
  SET NOCOUNT ON
  --declare
  --@upuserid bigint,
  --@did bigint
  --set @upuserid=@UpdatedUserId
  --set @did=@DeviceId
 -- IF @WorkingPinKeyCryptogram IS NOT NULL
    UPDATE dbo.tbl_Device SET WorkingPinKeyCryptogram=@WorkingPinKeyCryptogram,WorkingPinKeyUpdatedDate=@UpdatedDate,UpdatedDate=GETUTCDATE(),UpdatedUserId=@SmartAcquireId
    WHERE Id=@DeviceId AND (WorkingPinKeyUpdatedDate IS NULL OR WorkingPinKeyUpdatedDate<@UpdatedDate)
	
 -- IF @WorkingMacKeyCryptogram IS NOT NULL
    UPDATE dbo.tbl_Device SET WorkingMacKeyCryptogram=@WorkingMacKeyCryptogram,WorkingMACKeyUpdatedDate=@UpdatedDate,UpdatedDate=GETUTCDATE(),UpdatedUserId=@SmartAcquireId
    WHERE Id=@DeviceId AND (WorkingMACKeyUpdatedDate IS NULL OR WorkingMACKeyUpdatedDate<@UpdatedDate)
   
      -- Add update command for Smart Acquirer  
  exec [dbo].[usp_acq_InsertDevicesUpdateCommands] @SmartAcquireId,@DeviceId
 	
  RETURN 0
END
GO
GRANT EXECUTE ON  [dbo].[usp_dev_SetDeviceWorkingKey] TO [WebV4Role]
GO
