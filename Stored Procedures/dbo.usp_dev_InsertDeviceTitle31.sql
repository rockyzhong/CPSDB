SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[usp_dev_InsertDeviceTitle31]
@DeviceTitle31Id bigint OUTPUT,
@DeviceId        bigint,
@WindowNumber    nvarchar(50),
@AreaID          nvarchar(50),
@UpdatedUserId   bigint
--@SmartAcquireId  bigint =0
AS
BEGIN
  SET NOCOUNT ON
  
  INSERT INTO dbo.tbl_DeviceTitle31(DeviceId,WindowNumber,AreaID,UpdatedUserId)
  VALUES(@DeviceId,@WindowNumber,@AreaID,@UpdatedUserId)
  SELECT @DeviceTitle31Id=IDENT_CURRENT('tbl_DeviceTitle31')
 -- exec usp_acq_InsertDevicesUpdateCommands @SmartAcquireId,@DeviceId
  RETURN 0
END
GO
GRANT EXECUTE ON  [dbo].[usp_dev_InsertDeviceTitle31] TO [WebV4Role]
GO
