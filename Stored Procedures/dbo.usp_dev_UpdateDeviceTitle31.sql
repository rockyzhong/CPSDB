SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[usp_dev_UpdateDeviceTitle31]
@DeviceTitle31Id bigint ,
@DeviceId        bigint,
@WindowNumber    nvarchar(50),
@AreaID          nvarchar(50),
@UpdatedUserId   bigint
--@SmartAcquireId  bigint =0
AS
BEGIN
  SET NOCOUNT ON

  UPDATE dbo.tbl_DeviceTitle31 SET 
  DeviceId=@DeviceId,WindowNumber=@WindowNumber,AreaID=@AreaID,UpdatedUserId=@UpdatedUserId 
  WHERE Id=@DeviceTitle31Id
  --exec usp_acq_InsertDevicesUpdateCommands @SmartAcquireId,@DeviceId
  RETURN 0
END
GO
GRANT EXECUTE ON  [dbo].[usp_dev_UpdateDeviceTitle31] TO [WebV4Role]
GO
