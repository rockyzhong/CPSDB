SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[usp_dev_SetNetworkExtendedValue]
@NetworkId           bigint,
@ExtendedColumnType  bigint,
@ExtendedColumnValue nvarchar(200),
@UpdatedUserId       bigint,
@SmartAcquireId      bigint =0
AS
BEGIN
  SET NOCOUNT ON

  IF NOT EXISTS(SELECT * FROM dbo.tbl_NetworkExtendedValue WHERE NetworkId=@NetworkId AND ExtendedColumnType=@ExtendedColumnType)
    INSERT INTO dbo.tbl_NetworkExtendedValue(NetworkId,ExtendedColumnType,ExtendedColumnValue,UpdatedUserId)
    VALUES(@NetworkId,@ExtendedColumnType,@ExtendedColumnValue,@UpdatedUserId)
  ELSE
    UPDATE dbo.tbl_NetworkExtendedValue SET ExtendedColumnValue=@ExtendedColumnValue,UpdatedUserId=@UpdatedUserId
    WHERE NetworkId=@NetworkId AND ExtendedColumnType=@ExtendedColumnType
  
  exec usp_acq_InsertNetworkUpdateCommands @SmartAcquireId,@NetworkId
  
  RETURN 0
END
GO
GRANT EXECUTE ON  [dbo].[usp_dev_SetNetworkExtendedValue] TO [WebV4Role]
GO
