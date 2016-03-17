SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_ics_DeleteInterchangeSchemeSignatureAmount]
@InterchangeSchemeSignatureAmountId bigint,
@UpdatedUserId                      bigint
AS
BEGIN
  SET NOCOUNT ON

  UPDATE dbo.tbl_InterchangeSchemeSignatureAmount SET UpdatedUserId=@UpdatedUserId WHERE Id=@InterchangeSchemeSignatureAmountId
  DELETE FROM dbo.tbl_InterchangeSchemeSignatureAmount WHERE Id=@InterchangeSchemeSignatureAmountId
  
  RETURN 0
END
GO
GRANT EXECUTE ON  [dbo].[usp_ics_DeleteInterchangeSchemeSignatureAmount] TO [WebV4Role]
GO
