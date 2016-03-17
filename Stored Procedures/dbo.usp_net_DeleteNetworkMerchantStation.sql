SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_net_DeleteNetworkMerchantStation]
@NetworkMerchantStationId bigint,
@UpdatedUserId            bigint
AS
BEGIN
 -- Declare @networkid bigint
  SET NOCOUNT ON
 -- SELECT @networkid = networkid from dbo.tbl_NetworkCurrencyExchangeRate WHERE Id=@NetworkMerchantStationId
  UPDATE dbo.tbl_NetworkMerchantStation SET UpdatedUserId=@UpdatedUserId WHERE Id=@NetworkMerchantStationId
  DELETE FROM dbo.tbl_NetworkMerchantStation WHERE Id=@NetworkMerchantStationId
 -- exec usp_acq_InsertNetworkUpdateCommands @SmartAcquireId,@NetworkId      
  RETURN 0
END
GO
GRANT EXECUTE ON  [dbo].[usp_net_DeleteNetworkMerchantStation] TO [WebV4Role]
GO
