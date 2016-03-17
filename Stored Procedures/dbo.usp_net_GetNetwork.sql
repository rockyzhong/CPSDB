SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_net_GetNetwork]
@NetworkId      bigint
AS
BEGIN
  SELECT n.Id NetworkId,n.NetworkCode,n.NetworkName,n.Description,
         t.Value Currency,t.Name CurrencyName,t.Description CurrencyDescription
  FROM dbo.tbl_Network n
  LEFT JOIN dbo.tbl_TypeValue t ON n.Currency=t.Value AND t.TypeId=67
  WHERE n.Id=@NetworkId
END
GO
GRANT EXECUTE ON  [dbo].[usp_net_GetNetwork] TO [WebV4Role]
GO
