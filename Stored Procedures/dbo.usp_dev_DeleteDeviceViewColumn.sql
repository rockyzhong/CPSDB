SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_dev_DeleteDeviceViewColumn]
@ViewId            bigint,
@UpdatedUserId     bigint
AS
BEGIN
  SET NOCOUNT ON
  
  UPDATE dbo.tbl_DeviceViewColumn SET UpdatedUserId=@UpdatedUserId WHERE ViewId=@ViewId
  DELETE FROM dbo.tbl_DeviceViewColumn WHERE ViewId=@ViewId
  
  RETURN 0
END
GO
