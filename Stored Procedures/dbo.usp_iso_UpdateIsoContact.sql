SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[usp_iso_UpdateIsoContact]
@IsoContactId   bigint, 
@IsoContactType bigint,
@UpdatedUserId  bigint
--@SmartAcquireId  bigint =0
AS
BEGIN
 -- DECLARE @IsoId bigint
  SET NOCOUNT ON
  --SELECT @IsoId=IsoId from tbl_IsoAddress where Id=@IsoContactId
  UPDATE dbo.tbl_IsoContact SET IsoContactType=@IsoContactType,UpdatedUserId=@UpdatedUserId WHERE Id=@IsoContactId
 -- EXEC usp_acq_InsertISOUpdateCommands @SmartAcquireId,@IsoId
  RETURN 0
END
GO
GRANT EXECUTE ON  [dbo].[usp_iso_UpdateIsoContact] TO [WebV4Role]
GO
