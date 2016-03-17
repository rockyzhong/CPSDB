SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[usp_iso_InsertIsoAddress]
@IsoAddressId   bigint OUTPUT, 
@IsoId          bigint,
@IsoAddressType bigint,
@AddressId      bigint OUTPUT,
@UpdatedUserId  bigint
--@SmartAcquireId         bigint =0
AS
BEGIN
  SET NOCOUNT ON

  INSERT INTO dbo.tbl_Address(UpdatedUserId) VALUES(@UpdatedUserId)
  SELECT @AddressId=IDENT_CURRENT('tbl_Address')

  INSERT INTO dbo.tbl_IsoAddress(IsoId,AddressId,IsoAddressType,UpdatedUserId) VALUES(@IsoId,@AddressId,@IsoAddressType,@UpdatedUserId)
  SELECT @IsoAddressId=IDENT_CURRENT('tbl_IsoAddress')
  --EXEC usp_acq_InsertISOUpdateCommands @SmartAcquireId,@IsoId
  RETURN 0
END
GO
GRANT EXECUTE ON  [dbo].[usp_iso_InsertIsoAddress] TO [WebV4Role]
GO
