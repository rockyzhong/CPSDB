SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[usp_net_DeleteNetworkExtendedValue]
@NetworkExtendedValueId bigint,
@UpdatedUserId          bigint,
@SmartAcquireId         bigint =0
AS
BEGIN
  Declare @networkid bigint
  SET NOCOUNT ON
  SELECT @networkid = networkid from dbo.tbl_NetworkCurrencyExchangeRate WHERE Id=@NetworkExtendedValueId
  UPDATE dbo.tbl_NetworkExtendedValue SET UpdatedUserId=@UpdatedUserId WHERE Id=@NetworkExtendedValueId
  DELETE FROM dbo.tbl_NetworkExtendedValue WHERE Id=@NetworkExtendedValueId
  exec usp_acq_InsertNetworkUpdateCommands @SmartAcquireId,@NetworkId      
  RETURN 0
END

GO
GRANT EXECUTE ON  [dbo].[usp_net_DeleteNetworkExtendedValue] TO [WebV4Role]
GO
