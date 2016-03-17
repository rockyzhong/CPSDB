SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_net_GetNetworkExtendedValues] 
@NetworkId            bigint
AS
BEGIN
  SELECT v.Id NetworkExtendedValueId,v.NetworkId,v.ExtendedColumnType,c.ExtendedColumnLabel,v.ExtendedColumnValue
  FROM dbo.tbl_NetworkExtendedValue v 
  LEFT JOIN dbo.tbl_NetworkExtendedColumn c ON v.ExtendedColumnType=c.ExtendedColumnType
  WHERE v.NetworkId=@NetworkId
  ORDER BY c.ExtendedColumnLabel
END
GO
GRANT EXECUTE ON  [dbo].[usp_net_GetNetworkExtendedValues] TO [WebV4Role]
GO
