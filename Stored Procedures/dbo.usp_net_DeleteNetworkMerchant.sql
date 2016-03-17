SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_net_DeleteNetworkMerchant]
@NetworkMerchantId bigint,
@UpdatedUserId     bigint
AS
BEGIN
  --Declare @networkid bigint
  SET NOCOUNT ON
 -- SELECT @networkid = networkid from dbo.tbl_NetworkCurrencyExchangeRate WHERE Id=@NetworkMerchantId
  UPDATE dbo.tbl_NetworkMerchant SET UpdatedUserId=@UpdatedUserId WHERE Id=@NetworkMerchantId
  DELETE FROM dbo.tbl_NetworkMerchant WHERE Id=@NetworkMerchantId
 -- exec usp_acq_InsertNetworkUpdateCommands @SmartAcquireId,@NetworkId
  RETURN 0
END
GO
GRANT EXECUTE ON  [dbo].[usp_net_DeleteNetworkMerchant] TO [WebV4Role]
GO
