SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[usp_ics_GetInterchangeSchemeSignature]
@InterchangeSchemeId          bigint
AS
BEGIN
  SELECT s.Id InterchangeSchemeSignatureId,s.InterchangeSchemeId,n.Id NetworkId,s.TransactionType
  FROM dbo.tbl_InterchangeSchemeSignature s
  JOIN dbo.tbl_InterchangeNetwork         n ON n.NetworkCode=s.IssuerNetworkId
  WHERE InterchangeSchemeId=@InterchangeSchemeId
END
GO
GRANT EXECUTE ON  [dbo].[usp_ics_GetInterchangeSchemeSignature] TO [WebV4Role]
GO
