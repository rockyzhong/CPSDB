SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_ics_UpdateInterchangeSchemeSignatureAmount]
@InterchangeSchemeSignatureAmountId bigint, 
@InterchangeSchemeSignatureId       bigint,
@Recipient                          bigint,
@AmountApproval                     bigint,
@AmountDeclined                     bigint,
@UpdatedUserId                      bigint
AS
BEGIN
  SET NOCOUNT ON
  
  UPDATE dbo.tbl_InterchangeSchemeSignatureAmount SET InterchangeSchemeSignatureId=@InterchangeSchemeSignatureId,Recipient=@Recipient,AmountApproval=@AmountApproval,AmountDeclined=@AmountDeclined,UpdatedUserId=@UpdatedUserId WHERE Id=@InterchangeSchemeSignatureAmountId
  
  RETURN 0
END
GO
GRANT EXECUTE ON  [dbo].[usp_ics_UpdateInterchangeSchemeSignatureAmount] TO [WebV4Role]
GO
