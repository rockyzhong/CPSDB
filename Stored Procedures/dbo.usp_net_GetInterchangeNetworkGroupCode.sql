SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[usp_net_GetInterchangeNetworkGroupCode]
AS
BEGIN
  SELECT DISTINCT GroupCode
  FROM dbo.tbl_InterchangeNetwork
  WHERE NetworkCode <> 'ALL' AND GroupCode IS NOT NULL
  ORDER BY GroupCode
END
GO
GRANT EXECUTE ON  [dbo].[usp_net_GetInterchangeNetworkGroupCode] TO [WebV4Role]
GO
