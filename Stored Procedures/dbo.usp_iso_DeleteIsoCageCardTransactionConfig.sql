SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_iso_DeleteIsoCageCardTransactionConfig]
@IsoCageCardTransactionConfigId bigint,
@UpdatedUserId                  bigint
--@SmartAcquireId  bigint =0
AS
BEGIN
  SET NOCOUNT ON
  --DECLARE @IsoId bigint
  --Select @IsoId=IsoId  from tbl_IsoCageCardTransactionConfig where Id=@IsoCageCardTransactionConfigId
  UPDATE dbo.tbl_IsoCageCardTransactionConfig SET UpdatedUserId=@UpdatedUserId WHERE Id=@IsoCageCardTransactionConfigId
  DELETE FROM dbo.tbl_IsoCageCardTransactionConfig WHERE Id=@IsoCageCardTransactionConfigId
 -- EXEC usp_acq_InsertISOUpdateCommands @SmartAcquireId,@IsoId
  RETURN 0
END

GO
GRANT EXECUTE ON  [dbo].[usp_iso_DeleteIsoCageCardTransactionConfig] TO [WebV4Role]
GO
