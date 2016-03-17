SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_ics_DeleteInterchangeSchemeSignature]
@InterchangeSchemeSignatureId bigint,
@UpdatedUserId                bigint
AS
BEGIN
  SET NOCOUNT ON

  UPDATE dbo.tbl_InterchangeSchemeSignatureAmount SET UpdatedUserId=@UpdatedUserId WHERE InterchangeSchemeSignatureId=@InterchangeSchemeSignatureId
  DELETE FROM dbo.tbl_InterchangeSchemeSignatureAmount WHERE InterchangeSchemeSignatureId=@InterchangeSchemeSignatureId

  UPDATE dbo.tbl_InterchangeSchemeSignature SET UpdatedUserId=@UpdatedUserId WHERE Id=@InterchangeSchemeSignatureId
  DELETE FROM dbo.tbl_InterchangeSchemeSignature WHERE Id=@InterchangeSchemeSignatureId
  
  RETURN 0
END
GO
GRANT EXECUTE ON  [dbo].[usp_ics_DeleteInterchangeSchemeSignature] TO [WebV4Role]
GO
