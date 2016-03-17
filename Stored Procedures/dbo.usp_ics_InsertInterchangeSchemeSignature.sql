SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[usp_ics_InsertInterchangeSchemeSignature]
@InterchangeSchemeSignatureId bigint OUTPUT, 
@InterchangeSchemeId          bigint,
@NetworkId                    bigint,
@TransactionType              bigint,
@UpdatedUserId                bigint
AS
BEGIN
  SET NOCOUNT ON

  DECLARE @IssuerNetworkId nvarchar(50)
  SELECT @IssuerNetworkId=NetworkCode FROM dbo.tbl_InterchangeNetwork WHERE Id=@NetworkId

  INSERT INTO dbo.tbl_InterchangeSchemeSignature(InterchangeSchemeId,IssuerNetworkId,TransactionType,UpdatedUserId) VALUES(@InterchangeSchemeId,@IssuerNetworkId,@TransactionType,@UpdatedUserId)
  SELECT @InterchangeSchemeSignatureId=IDENT_CURRENT('tbl_InterchangeSchemeSignature')
  
  RETURN 0
END
GO
GRANT EXECUTE ON  [dbo].[usp_ics_InsertInterchangeSchemeSignature] TO [WebV4Role]
GO
