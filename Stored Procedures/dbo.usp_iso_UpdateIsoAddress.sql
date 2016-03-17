SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[usp_iso_UpdateIsoAddress]
@IsoAddressId   bigint, 
@IsoAddressType bigint,
@UpdatedUserId  bigint
--@SmartAcquireId  bigint =0
AS
BEGIN
 -- DECLARE @IsoId bigint
  SET NOCOUNT ON
 -- SELECT @IsoId=IsoId from tbl_IsoAddress where Id=@IsoAddressId
  UPDATE dbo.tbl_IsoAddress SET IsoAddressType=@IsoAddressType,UpdatedUserId=@UpdatedUserId WHERE Id=@IsoAddressId
  
 -- EXEC usp_acq_InsertISOUpdateCommands @SmartAcquireId,@IsoId
  RETURN 0
END
GO
GRANT EXECUTE ON  [dbo].[usp_iso_UpdateIsoAddress] TO [WebV4Role]
GO
