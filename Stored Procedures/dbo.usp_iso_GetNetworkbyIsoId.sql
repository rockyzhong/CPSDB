SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_iso_GetNetworkbyIsoId] 
@IsoId bigint
AS
BEGIN
  SET NOCOUNT ON

  SELECT nw.Id, nw.NetworkCode, nw.NetworkName, nw.Description, nw.InterfaceName
  FROM dbo.tbl_Network nw
  JOIN dbo.tbl_IsoCageCheckTransactionConfig cc ON  cc.NetworkId = nw.Id
  WHERE cc.IsoId = @IsoId 
END
GO
