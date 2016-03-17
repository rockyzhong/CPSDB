SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[usp_iso_DeleteIsoAddress]
@IsoAddressId   bigint,
@UpdatedUserId  bigint
--@SmartAcquireId         bigint =0
AS
BEGIN
  SET NOCOUNT ON

  DECLARE @AddressId bigint,
          @IsoId bigint
      
  SELECT @AddressId=AddressId FROM dbo.tbl_IsoAddress WHERE Id=@IsoAddressId
  SELECT @IsoId=IsoId FROM dbo.tbl_IsoAddress WHERE Id=@IsoAddressId
  UPDATE dbo.tbl_IsoAddress SET UpdatedUserId=@UpdatedUserId WHERE Id=@IsoAddressId
  UPDATE dbo.tbl_Address    SET UpdatedUserId=@UpdatedUserId WHERE Id=@AddressId
  
  DELETE FROM dbo.tbl_IsoAddress WHERE Id=@IsoAddressId
  DELETE FROM dbo.tbl_Address    WHERE Id=@AddressId
 -- exec usp_acq_InsertISOUpdateCommands @SmartAcquireId,@IsoId
  RETURN 0
END
GO
GRANT EXECUTE ON  [dbo].[usp_iso_DeleteIsoAddress] TO [WebV4Role]
GO
