SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_ics_GetInterchangeSchemeSignatureAmount]
@InterchangeSchemeSignatureId          bigint
AS
BEGIN
  SELECT Id InterchangeSchemeSignatureAmountId,InterchangeSchemeSignatureId,Recipient,AmountApproval,AmountDeclined
  FROM dbo.tbl_InterchangeSchemeSignatureAmount
  WHERE InterchangeSchemeSignatureId=@InterchangeSchemeSignatureId
END
GO
GRANT EXECUTE ON  [dbo].[usp_ics_GetInterchangeSchemeSignatureAmount] TO [WebV4Role]
GO
