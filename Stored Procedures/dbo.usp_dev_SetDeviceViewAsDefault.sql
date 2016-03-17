SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[usp_dev_SetDeviceViewAsDefault] 
@UserId bigint,
@ViewId bigint,
@UpdateUserId bigint
AS
BEGIN
  SET NOCOUNT ON

  IF EXISTS (SELECT Id FROM dbo.tbl_DeviceDefaultView WHERE UserId = @UserId)
    UPDATE dbo.tbl_DeviceDefaultView SET ViewId = @ViewId,UpdateUserId=@UpdateUserId  WHERE UserId=@UserId
  ELSE
    INSERT INTO dbo.tbl_DeviceDefaultView(UserId,ViewId,UpdateUserId) VALUES(@UserId, @ViewId, @UpdateUserId)
END
GO
