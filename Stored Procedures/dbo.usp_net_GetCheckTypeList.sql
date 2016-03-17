SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_net_GetCheckTypeList] 
@NetworkId bigint,
@IsoId     bigint
AS
BEGIN
  SELECT DISTINCT ms.CHECKTYPE,tc.Name,tc.Value,tc.description,tc.id
  FROM dbo.tbl_NetworkMerchantStation ms, dbo.tbl_networkmerchant nm, dbo.tbl_TypeValue tc
  WHERE ms.NetworkMerchantId=nm.Id AND ms.CheckType=tc.Value AND tc.TypeId=59 AND ms.statusId=1 
    AND nm.IsoId=@IsoId AND nm.NetworkId=@NetworkId
  ORDER BY ms.CheckType asc
END
GO
GRANT EXECUTE ON  [dbo].[usp_net_GetCheckTypeList] TO [WebV4Role]
GO
