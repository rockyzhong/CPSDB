SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[usp_dev_SetDeviceExtendedValues]
@DeviceId              bigint,
@DeviceEmulation1      bigint,
@ExtendedColumnType1   bigint,
@ExtendedColumnValue1  nvarchar(256),
@DeviceEmulation2      bigint,
@ExtendedColumnType2   bigint,
@ExtendedColumnValue2  nvarchar(256),
@DeviceEmulation3      bigint,
@ExtendedColumnType3   bigint,
@ExtendedColumnValue3  nvarchar(256),
@DeviceEmulation4      bigint,
@ExtendedColumnType4   bigint,
@ExtendedColumnValue4  nvarchar(256),
@DeviceEmulation5      bigint,
@ExtendedColumnType5   bigint,
@ExtendedColumnValue5  nvarchar(256),
@SwitchUserFlag        nvarchar(1),
@SmartAcquireId        bigint 
AS
BEGIN
  SET NOCOUNT ON

  IF @DeviceEmulation1 IS NOT NULL AND @ExtendedColumnType1 IS NOT NULL
    EXEC dbo.usp_dev_SetDeviceExtendedValue @DeviceId,@DeviceEmulation1,@ExtendedColumnType1,@ExtendedColumnValue1,@SwitchUserFlag,0,@SmartAcquireId
  IF @DeviceEmulation2 IS NOT NULL AND @ExtendedColumnType2 IS NOT NULL
    EXEC dbo.usp_dev_SetDeviceExtendedValue @DeviceId,@DeviceEmulation2,@ExtendedColumnType2,@ExtendedColumnValue2,@SwitchUserFlag,0,@SmartAcquireId
  IF @DeviceEmulation3 IS NOT NULL AND @ExtendedColumnType3 IS NOT NULL
    EXEC dbo.usp_dev_SetDeviceExtendedValue @DeviceId,@DeviceEmulation3,@ExtendedColumnType3,@ExtendedColumnValue3,@SwitchUserFlag,0,@SmartAcquireId
  IF @DeviceEmulation4 IS NOT NULL AND @ExtendedColumnType4 IS NOT NULL
    EXEC dbo.usp_dev_SetDeviceExtendedValue @DeviceId,@DeviceEmulation4,@ExtendedColumnType4,@ExtendedColumnValue4,@SwitchUserFlag,0,@SmartAcquireId
  IF @DeviceEmulation5 IS NOT NULL AND @ExtendedColumnType5 IS NOT NULL
    EXEC dbo.usp_dev_SetDeviceExtendedValue @DeviceId,@DeviceEmulation5,@ExtendedColumnType5,@ExtendedColumnValue5,@SwitchUserFlag,0,@SmartAcquireId

 

  RETURN 0
END
GO
GRANT EXECUTE ON  [dbo].[usp_dev_SetDeviceExtendedValues] TO [WebV4Role]
GO
