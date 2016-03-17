SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_net_GetNetInterfaceByNetId]
@NetworId bigint
AS
BEGIN
SET NOCOUNT ON

SELECT InterfaceName from dbo.tbl_Network where Id=@NetworId
      
END
GO
