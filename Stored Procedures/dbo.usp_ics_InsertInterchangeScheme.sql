SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_ics_InsertInterchangeScheme]
@InterchangeSchemeId   bigint       OUTPUT,
@InterchangeSchemeName nvarchar(50),
@Description           nvarchar(500),
@UpdatedUserId         bigint
AS
BEGIN
  SET NOCOUNT ON

  INSERT INTO dbo.tbl_InterchangeScheme(InterchangeSchemeName,Description,UpdatedUserId) VALUES(@InterchangeSchemeName,@Description,@UpdatedUserId)
  SELECT @InterchangeSchemeId=IDENT_CURRENT('tbl_InterchangeScheme')
  INSERT dbo.tbl_upm_Object(SourceId,SourceType,CreatedUserId) VALUES(@InterchangeSchemeId,5,@UpdatedUserId)

  RETURN 0
END
GO
GRANT EXECUTE ON  [dbo].[usp_ics_InsertInterchangeScheme] TO [WebV4Role]
GO
