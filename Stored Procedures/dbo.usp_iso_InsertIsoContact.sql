SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[usp_iso_InsertIsoContact]
@IsoContactId   bigint OUTPUT, 
@IsoId          bigint,
@IsoContactType bigint,
@ContactId      bigint OUTPUT,
@AddressId      bigint OUTPUT,
@UpdatedUserId  bigint
--@SmartAcquireId  bigint =0
AS
BEGIN
  SET NOCOUNT ON
  
  INSERT INTO dbo.tbl_Address(UpdatedUserId) VALUES(@UpdatedUserId)  
  SELECT @AddressId=IDENT_CURRENT('tbl_Address')

  INSERT INTO dbo.tbl_Contact(AddressId,UpdatedUserId) VALUES(@AddressId,@UpdatedUserId)
  SELECT @ContactId=IDENT_CURRENT('tbl_Contact')
  
  INSERT INTO dbo.tbl_IsoContact(IsoId,ContactId,IsoContactType,UpdatedUserId) VALUES(@IsoId,@ContactId,@IsoContactType,@UpdatedUserId)
  SELECT @IsoContactId=IDENT_CURRENT('tbl_IsoContact')
 -- EXEC usp_acq_InsertISOUpdateCommands @SmartAcquireId,@IsoId
  RETURN 0
END
GO
GRANT EXECUTE ON  [dbo].[usp_iso_InsertIsoContact] TO [WebV4Role]
GO
