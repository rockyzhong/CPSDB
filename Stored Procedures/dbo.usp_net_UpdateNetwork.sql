SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[usp_net_UpdateNetwork]
@NetworkId      bigint,
@NetworkCode    nvarchar(50),
@NetworkName    nvarchar(50),
@Currency       bigint,
@Description    nvarchar(500),
@UpdatedUserId  bigint,
@SmartAcquireId         bigint =0
AS
BEGIN
  SET NOCOUNT ON

  UPDATE dbo.tbl_Network SET 
  NetworkCode=@NetworkCode,NetworkName=@NetworkName,Currency=@Currency,Description=@Description,UpdatedDate=GETUTCDATE(),UpdatedUserId=@UpdatedUserId
  WHERE Id=@NetworkId
  EXEC usp_acq_InsertNetworkUpdateCommands @SmartAcquireId,@NetworkId
  RETURN 0
END
GO
GRANT EXECUTE ON  [dbo].[usp_net_UpdateNetwork] TO [WebV4Role]
GO
