SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_dev_getDeviceDefaultViewId] 
@UserId bigint,
@ViewId bigint out
AS
BEGIN
  SET NOCOUNT ON

  SET @ViewId = -1
  SELECT @ViewId=ViewId FROM dbo.tbl_DeviceDefaultView WHERE UserId=@UserId
  IF @ViewId = -1
    SELECT @ViewId=ViewId FROM dbo.tbl_DeviceGlobalDefaultView
END
GO
