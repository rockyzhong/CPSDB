SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_ics_GetInterchangeScheme]
@InterchangeSchemeId bigint
AS
BEGIN
  SELECT Id InterchangeSchemeId,InterchangeSchemeName,Description FROM dbo.tbl_InterchangeScheme WHERE Id=@InterchangeSchemeId
END
GO
GRANT EXECUTE ON  [dbo].[usp_ics_GetInterchangeScheme] TO [WebV4Role]
GO
