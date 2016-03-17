SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_net_GetNetworkMerchant]
@NetworkMerchantId bigint
AS
BEGIN
  SELECT Id NetworkMerchantId,NetworkId,IsoId,MerchantId FROM dbo.tbl_NetworkMerchant WHERE Id=@NetworkMerchantId
END
GO
GRANT EXECUTE ON  [dbo].[usp_net_GetNetworkMerchant] TO [WebV4Role]
GO
