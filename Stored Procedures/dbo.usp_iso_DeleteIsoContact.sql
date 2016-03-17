SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[usp_iso_DeleteIsoContact]
@IsoContactId   bigint,
@UpdatedUserId  bigint
--@SmartAcquireId         bigint =0
AS
BEGIN
  SET NOCOUNT ON

  DECLARE @ContactId bigint,@AddressId bigint--@IsoId bigint
  SELECT @ContactId=ContactId FROM dbo.tbl_IsoContact WHERE Id=@IsoContactId
  SELECT @AddressId=AddressId FROM dbo.tbl_Contact    WHERE Id=@ContactId
--  SELECT @IsoId=IsoId FROM dbo.tbl_IsoContact WHERE Id=@IsoContactId
  UPDATE dbo.tbl_IsoContact SET UpdatedUserId=@UpdatedUserId WHERE Id=@IsoContactId
  UPDATE dbo.tbl_Contact    SET UpdatedUserId=@UpdatedUserId WHERE Id=@ContactId
  UPDATE dbo.tbl_Address    SET UpdatedUserId=@UpdatedUserId WHERE Id=@AddressId
  
  DELETE FROM dbo.tbl_IsoContact WHERE Id=@IsoContactId
  DELETE FROM dbo.tbl_Contact    WHERE Id=@ContactId
  DELETE FROM dbo.tbl_Address    WHERE Id=@AddressId
 -- exec usp_acq_InsertISOUpdateCommands @SmartAcquireId,@IsoId  
  RETURN 0
END
GO
GRANT EXECUTE ON  [dbo].[usp_iso_DeleteIsoContact] TO [WebV4Role]
GO
