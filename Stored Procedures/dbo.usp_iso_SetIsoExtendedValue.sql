SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_iso_SetIsoExtendedValue]
@IsoId               bigint,
@ExtendedColumnType  bigint,
@ExtendedColumnValue nvarchar(200),
@UpdatedUserId       bigint,
@SmartAcquireId  bigint =0
AS
BEGIN
  SET NOCOUNT ON

  IF NOT EXISTS(SELECT * FROM dbo.tbl_IsoExtendedValue WHERE IsoId=@IsoId AND ExtendedColumnType=@ExtendedColumnType)
    INSERT INTO dbo.tbl_IsoExtendedValue(IsoId,ExtendedColumnType,ExtendedColumnValue,UpdatedUserId)
    VALUES(@IsoId,@ExtendedColumnType,@ExtendedColumnValue,@UpdatedUserId)
  ELSE
    UPDATE dbo.tbl_IsoExtendedValue SET ExtendedColumnValue=@ExtendedColumnValue,UpdatedUserId=@UpdatedUserId
    WHERE IsoId=@IsoId AND ExtendedColumnType=@ExtendedColumnType
  EXEC usp_acq_InsertISOUpdateCommands @SmartAcquireId,@IsoId
  RETURN 0
END
GO
GRANT EXECUTE ON  [dbo].[usp_iso_SetIsoExtendedValue] TO [WebV4Role]
GO
