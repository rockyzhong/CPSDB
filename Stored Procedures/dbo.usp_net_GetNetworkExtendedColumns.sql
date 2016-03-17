SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_net_GetNetworkExtendedColumns] 
AS
BEGIN
  SELECT Id NetworkExtendedColumnId,ExtendedColumnType,ExtendedColumnLabel,ExtendedColumnDescription
  FROM dbo.tbl_NetworkExtendedColumn
END
GO
GRANT EXECUTE ON  [dbo].[usp_net_GetNetworkExtendedColumns] TO [WebV4Role]
GO
