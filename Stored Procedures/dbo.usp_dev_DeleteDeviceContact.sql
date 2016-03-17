SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[usp_dev_DeleteDeviceContact]
@DeviceContactId   bigint,
@UpdatedUserId     bigint
--@SmartAcquireId  bigint =0
AS
BEGIN
  SET NOCOUNT ON

  DECLARE @ContactId bigint,@AddressId bigint--,@DeviceId bigint
  
  SELECT @ContactId=ContactId FROM dbo.tbl_DeviceContact WHERE Id=@DeviceContactId
  SELECT @AddressId=AddressId FROM dbo.tbl_Contact       WHERE Id=@ContactId

  UPDATE dbo.tbl_DeviceContact SET UpdatedUserId=@UpdatedUserId WHERE Id=@DeviceContactId
  UPDATE dbo.tbl_Contact       SET UpdatedUserId=@UpdatedUserId WHERE Id=@ContactId
  UPDATE dbo.tbl_Address       SET UpdatedUserId=@UpdatedUserId WHERE Id=@AddressId
  
  DELETE FROM dbo.tbl_DeviceContact WHERE Id=@DeviceContactId
  DELETE FROM dbo.tbl_Contact       WHERE Id=@ContactId
  DELETE FROM dbo.tbl_Address       WHERE Id=@AddressId
   
--  exec usp_acq_InsertDevicesUpdateCommands @SmartAcquireId,@DeviceId
  RETURN 0
END
GO
GRANT EXECUTE ON  [dbo].[usp_dev_DeleteDeviceContact] TO [WebV4Role]
GO
