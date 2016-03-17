SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_net_GetNetworkMerchantsByNetwork]
@NetworkId bigint
AS
BEGIN
  SELECT Id NetworkMerchantId,NetworkId,IsoId,MerchantId FROM dbo.tbl_NetworkMerchant WHERE NetworkId=@NetworkId
END
GO
GRANT EXECUTE ON  [dbo].[usp_net_GetNetworkMerchantsByNetwork] TO [WebV4Role]
GO
