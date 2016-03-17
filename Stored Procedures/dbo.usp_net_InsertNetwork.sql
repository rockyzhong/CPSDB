SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[usp_net_InsertNetwork]
@NetworkId      bigint,
@NetworkCode    nvarchar(50),
@NetworkName    nvarchar(50),
@Currency       bigint,
@Description    nvarchar(500),
@UpdatedUserId  bigint
--@SmartAcquireId         bigint =0
AS
BEGIN
  SET NOCOUNT ON

  INSERT INTO dbo.tbl_Network(Id,NetworkCode,NetworkName,Currency,Description,UpdatedUserId) VALUES(@NetworkId,@NetworkCode,@NetworkName,@Currency,@Description,@UpdatedUserId)
  INSERT dbo.tbl_upm_Object(SourceId,SourceType,CreatedUserId) VALUES(@NetworkId,6,@UpdatedUserId)
 -- exec usp_acq_InsertNetworkUpdateCommands @SmartAcquireId,@NetworkId
  RETURN 0
END
GO
GRANT EXECUTE ON  [dbo].[usp_net_InsertNetwork] TO [WebV4Role]
GO
