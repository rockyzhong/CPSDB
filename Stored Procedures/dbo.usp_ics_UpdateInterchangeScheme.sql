SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_ics_UpdateInterchangeScheme]
@InterchangeSchemeId   bigint,
@InterchangeSchemeName nvarchar(50),
@Description           nvarchar(500),
@UpdatedUserId         bigint
AS
BEGIN
  SET NOCOUNT ON

  UPDATE dbo.tbl_InterchangeScheme SET 
  InterchangeSchemeName=@InterchangeSchemeName,Description=@Description,UpdatedUserId=@UpdatedUserId
  WHERE Id=@InterchangeSchemeId
  
  RETURN 0
END
GO
GRANT EXECUTE ON  [dbo].[usp_ics_UpdateInterchangeScheme] TO [WebV4Role]
GO
