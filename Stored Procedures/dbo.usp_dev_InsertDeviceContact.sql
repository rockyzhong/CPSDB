SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[usp_dev_InsertDeviceContact]
@DeviceContactId   bigint OUTPUT, 
@DeviceId          bigint,
@DeviceContactType bigint,
@ContactId         bigint OUTPUT,
@AddressId         bigint OUTPUT,
@UpdatedUserId     bigint
--@SmartAcquireId  bigint =0
AS
BEGIN
  SET NOCOUNT ON
  
  INSERT INTO dbo.tbl_Address(UpdatedUserId) VALUES(@UpdatedUserId)  
  SELECT @AddressId=IDENT_CURRENT('tbl_Address')

  INSERT INTO dbo.tbl_Contact(AddressId,UpdatedUserId) VALUES(@AddressId,@UpdatedUserId)
  SELECT @ContactId=IDENT_CURRENT('tbl_Contact')
  
  INSERT INTO dbo.tbl_DeviceContact(DeviceId,ContactId,DeviceContactType,UpdatedUserId) VALUES(@DeviceId,@ContactId,@DeviceContactType,@UpdatedUserId)
  SELECT @DeviceContactId=IDENT_CURRENT('tbl_DeviceContact')
 -- exec usp_acq_InsertDevicesUpdateCommands @SmartAcquireId,@DeviceId
  RETURN 0
END
GO
GRANT EXECUTE ON  [dbo].[usp_dev_InsertDeviceContact] TO [WebV4Role]
GO
