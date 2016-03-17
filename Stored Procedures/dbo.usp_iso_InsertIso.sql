SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[usp_iso_InsertIso]
@IsoId          bigint OUTPUT,
@RegisteredName nvarchar(50),
@TimeZoneId     bigint,
@ParentId       bigint,
@UpdatedUserId  bigint,
@SmartAcquireId         bigint =0
AS
BEGIN
  SET NOCOUNT ON

  INSERT INTO dbo.tbl_Iso(RegisteredName,TimeZoneId,ParentId,UpdatedUserId) VALUES(@RegisteredName,@TimeZoneId,@ParentId,@UpdatedUserId)
  SELECT @IsoId=IDENT_CURRENT('tbl_Iso')
  INSERT dbo.tbl_upm_Object(SourceId,SourceType,CreatedUserId) VALUES(@IsoId,4,@UpdatedUserId)
  INSERT dbo.tbl_IsoSetCutover(IsoId,CutoverTime) VALUES (@IsoId,'0000')
  DECLARE @AddressId bigint
  INSERT INTO dbo.tbl_Address(UpdatedUserId) VALUES(@UpdatedUserId)
  SELECT @AddressId=IDENT_CURRENT('tbl_Address')
  INSERT INTO dbo.tbl_IsoAddress(IsoId,AddressId,IsoAddressType,UpdatedUserId) VALUES(@IsoId,@AddressId,1,@UpdatedUserId)
  EXEC usp_acq_InsertISOUpdateCommands @SmartAcquireId,@IsoId
  RETURN 0
END
GO
GRANT EXECUTE ON  [dbo].[usp_iso_InsertIso] TO [WebV4Role]
GO
