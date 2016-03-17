SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_dev_SetDeviceToInterchangeScheme] 
  @DeviceId                      bigint,
  @InterchangeSchemeId           bigint,
  @UpdatedUserId                 bigint
  --@SmartAcquireId  bigint =0
AS
BEGIN 
  SET NOCOUNT ON
  
  IF NOT EXISTS(SELECT * FROM dbo.tbl_DeviceToInterchangeScheme WHERE DeviceId=@DeviceId)
    INSERT INTO dbo.tbl_DeviceToInterchangeScheme(DeviceId,InterchangeSchemeId,UpdatedUserId) VALUES(@DeviceId,@InterchangeSchemeId,@UpdatedUserId)
  ELSE
    UPDATE dbo.tbl_DeviceToInterchangeScheme SET InterchangeSchemeId=@InterchangeSchemeId,UpdatedUserId=@UpdatedUserId WHERE DeviceId=@DeviceId
  --  exec usp_acq_InsertDevicesUpdateCommands @SmartAcquireId,@DeviceId
  RETURN 0
END
GO
GRANT EXECUTE ON  [dbo].[usp_dev_SetDeviceToInterchangeScheme] TO [WebV4Role]
GO
