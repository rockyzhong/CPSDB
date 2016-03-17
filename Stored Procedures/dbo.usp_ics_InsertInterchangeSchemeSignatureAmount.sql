SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_ics_InsertInterchangeSchemeSignatureAmount]
@InterchangeSchemeSignatureAmountId bigint OUTPUT, 
@InterchangeSchemeSignatureId       bigint,
@Recipient                          bigint,
@AmountApproval                     bigint,
@AmountDeclined                     bigint,
@UpdatedUserId                      bigint
AS
BEGIN
  SET NOCOUNT ON

  INSERT INTO dbo.tbl_InterchangeSchemeSignatureAmount(InterchangeSchemeSignatureId,Recipient,AmountApproval,AmountDeclined,UpdatedUserId) VALUES(@InterchangeSchemeSignatureId,@Recipient,@AmountApproval,@AmountDeclined,@UpdatedUserId)
  SELECT @InterchangeSchemeSignatureAmountId=IDENT_CURRENT('tbl_InterchangeSchemeSignatureAmount')
  
  RETURN 0
END
GO
GRANT EXECUTE ON  [dbo].[usp_ics_InsertInterchangeSchemeSignatureAmount] TO [WebV4Role]
GO
