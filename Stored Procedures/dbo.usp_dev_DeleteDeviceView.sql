SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_dev_DeleteDeviceView]
@DeviceViewId      bigint, 
@UpdatedUserId     bigint
AS
BEGIN
  SET NOCOUNT ON
  UPDATE dbo.tbl_DeviceView SET UpdatedUserId=@UpdatedUserId WHERE Id=@DeviceViewId
  DELETE FROM dbo.tbl_DeviceView WHERE Id=@DeviceViewId
  
  RETURN 0
END
GO
