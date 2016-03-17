SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_net_GetNetworkMerchants]
@IsoId bigint
AS
BEGIN
  SELECT Id NetworkMerchantId,NetworkId,IsoId,MerchantId FROM dbo.tbl_NetworkMerchant WHERE IsoId=@IsoId
END
GO
GRANT EXECUTE ON  [dbo].[usp_net_GetNetworkMerchants] TO [WebV4Role]
GO
