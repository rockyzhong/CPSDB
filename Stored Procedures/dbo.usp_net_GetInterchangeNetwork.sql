SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_net_GetInterchangeNetwork]
AS
BEGIN
  SELECT Id InterchangeNetworkId,NetworkCode, NetworkDesc,GroupCode
  FROM dbo.tbl_InterchangeNetwork
  --WHERE NetworkCode <> 'ALL'
  ORDER BY NetworkCode
END
GO
GRANT EXECUTE ON  [dbo].[usp_net_GetInterchangeNetwork] TO [WebV4Role]
GO
