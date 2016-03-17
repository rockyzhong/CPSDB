SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_dev_UpdateDeviceContact]
@DeviceContactId   bigint, 
@DeviceContactType bigint,
@UpdatedUserId     bigint
AS
BEGIN
  SET NOCOUNT ON
  UPDATE dbo.tbl_DeviceContact SET DeviceContactType=@DeviceContactType,UpdatedUserId=@UpdatedUserId WHERE Id=@DeviceContactId
  RETURN 0
END
GO
GRANT EXECUTE ON  [dbo].[usp_dev_UpdateDeviceContact] TO [WebV4Role]
GO
