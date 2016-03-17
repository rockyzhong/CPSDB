SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_ics_IsInterchangeSchemeExist] 
@InterchangeSchemeName nvarchar(50),
@IsExist               bigint OUT
AS
BEGIN
  SET NOCOUNT ON
  IF EXISTS(SELECT * FROM dbo.tbl_InterchangeScheme WHERE InterchangeSchemeName=@InterchangeSchemeName)
    SET @IsExist=1
  ELSE
    SET @IsExist=0
  RETURN 0
END
GO
GRANT EXECUTE ON  [dbo].[usp_ics_IsInterchangeSchemeExist] TO [WebV4Role]
GO
