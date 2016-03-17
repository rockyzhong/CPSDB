SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_iso_DeleteIsoCageCheckTransactionConfig]
@IsoCageCheckTransactionConfigId bigint,
@UpdatedUserId                   bigint
--@SmartAcquireId  bigint =0
AS
BEGIN
  SET NOCOUNT ON
 -- DECLARE @IsoId bigint
 -- Select @IsoId=IsoId  from tbl_IsoCageCheckTransactionConfig where Id=@IsoCageCheckTransactionConfigId
  UPDATE dbo.tbl_IsoCageCheckTransactionConfig SET UpdatedUserId=@UpdatedUserId WHERE Id=@IsoCageCheckTransactionConfigId
  DELETE FROM dbo.tbl_IsoCageCheckTransactionConfig WHERE Id=@IsoCageCheckTransactionConfigId
  --EXEC usp_acq_InsertISOUpdateCommands @SmartAcquireId,@IsoId
  RETURN 0
END
GO
GRANT EXECUTE ON  [dbo].[usp_iso_DeleteIsoCageCheckTransactionConfig] TO [WebV4Role]
GO
