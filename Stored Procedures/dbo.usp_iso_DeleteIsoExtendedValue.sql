SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_iso_DeleteIsoExtendedValue]
@IsoExtendedValueId bigint,
@UpdatedUserId          bigint,
@SmartAcquireId  bigint =0
AS
BEGIN
  DECLARE @IsoId bigint
  SET NOCOUNT ON
  SELECT @IsoId=IsoId from dbo.tbl_IsoExtendedValue WHERE Id=@IsoExtendedValueId
  UPDATE dbo.tbl_IsoExtendedValue SET UpdatedUserId=@UpdatedUserId WHERE Id=@IsoExtendedValueId
  DELETE FROM dbo.tbl_IsoExtendedValue WHERE Id=@IsoExtendedValueId
  EXEC usp_acq_InsertISOUpdateCommands @SmartAcquireId,@IsoId
  RETURN 0
END
GO
GRANT EXECUTE ON  [dbo].[usp_iso_DeleteIsoExtendedValue] TO [WebV4Role]
GO
