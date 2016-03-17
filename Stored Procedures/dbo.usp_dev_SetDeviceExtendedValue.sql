SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[usp_dev_SetDeviceExtendedValue]
@DeviceId            bigint,
@DeviceEmulation     bigint,
@ExtendedColumnType  bigint,
@ExtendedColumnValue nvarchar(256),
@SwitchUserFlag      nvarchar(1),
@UpdatedUserId       bigint =0,
@SmartAcquireId      bigint =0

AS
BEGIN
  SET NOCOUNT ON
  DECLARE  @DeviceStatus bigint
  IF NOT EXISTS(SELECT * FROM dbo.tbl_DeviceExtendedValue WHERE DeviceId=@DeviceId AND DeviceEmulation=@DeviceEmulation AND ExtendedColumnType=@ExtendedColumnType)
    INSERT INTO dbo.tbl_DeviceExtendedValue(DeviceId,DeviceEmulation,ExtendedColumnType,ExtendedColumnValue,SwitchUserFlag,UpdatedUserId)
    VALUES(@DeviceId,@DeviceEmulation,@ExtendedColumnType,@ExtendedColumnValue,@SwitchUserFlag,@UpdatedUserId)
  ELSE
    UPDATE dbo.tbl_DeviceExtendedValue SET ExtendedColumnValue=@ExtendedColumnValue,SwitchUserFlag=@SwitchUserFlag,UpdatedUserId=@UpdatedUserId
    WHERE DeviceId=@DeviceId AND DeviceEmulation=@DeviceEmulation AND ExtendedColumnType=@ExtendedColumnType
  

      -- Add update command for Smart Acquirer  
  SELECT @DeviceStatus=DeviceStatus  FROM tbl_Device where Id=@DeviceId
  IF @DeviceStatus=1
  exec [dbo].[usp_acq_InsertDevicesUpdateCommands] @SmartAcquireId,@DeviceId
 
  RETURN 0
END
GO
GRANT EXECUTE ON  [dbo].[usp_dev_SetDeviceExtendedValue] TO [WebV4Role]
GO
