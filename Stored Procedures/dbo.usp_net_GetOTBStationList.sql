SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_net_GetOTBStationList] 
@NetworkId bigint,
@IsoId     bigint
AS
BEGIN
  SELECT ns.*
  FROM dbo.tbl_NetworkMerchantStation ns,dbo.tbl_NetworkMerchant nm,dbo.tbl_TypeValue tv
  WHERE ns.NetworkMerchantId=nm.Id AND ns.CheckType = tv.Value AND tv.TypeId=59 AND ns.StatusId=1 AND OTB_Enabled='Y' 
    AND nm.IsoId=@IsoId AND nm.NetworkId=@NetworkId
END
GO
GRANT EXECUTE ON  [dbo].[usp_net_GetOTBStationList] TO [WebV4Role]
GO
