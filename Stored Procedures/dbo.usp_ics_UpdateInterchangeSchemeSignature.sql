SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[usp_ics_UpdateInterchangeSchemeSignature]
@InterchangeSchemeSignatureId bigint, 
@InterchangeSchemeId          bigint,
@NetworkId                    bigint,
@TransactionType              bigint,
@UpdatedUserId                bigint
AS
BEGIN
  SET NOCOUNT ON
  
  DECLARE @IssuerNetworkId nvarchar(50)
  SELECT @IssuerNetworkId=NetworkCode FROM dbo.tbl_InterchangeNetwork WHERE Id=@NetworkId
  
  UPDATE dbo.tbl_InterchangeSchemeSignature SET InterchangeSchemeId=@InterchangeSchemeId,IssuerNetworkId=@IssuerNetworkId,TransactionType=@TransactionType,UpdatedUserId=@UpdatedUserId WHERE Id=@InterchangeSchemeSignatureId
  
  RETURN 0
END
GO
GRANT EXECUTE ON  [dbo].[usp_ics_UpdateInterchangeSchemeSignature] TO [WebV4Role]
GO
