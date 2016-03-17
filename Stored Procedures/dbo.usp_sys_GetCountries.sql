SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_sys_GetCountries]
AS
BEGIN
  SELECT Id CountryId,CountryFullName,CountryShortName,CountryNumberCode FROM dbo.tbl_Country
END
GO
GRANT EXECUTE ON  [dbo].[usp_sys_GetCountries] TO [WebV4Role]
GO
