SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_sys_GetCountriesByCountryShortNameList]
@CountryShortNameList  nvarchar(50)
AS
BEGIN
  SET NOCOUNT ON 
  DECLARE @Name TABLE(name nvarchar(2))
  INSERT INTO @Name EXEC dbo.usp_sys_Split @CountryShortNameList
  SELECT Id CountryId,CountryFullName,CountryShortName,CountryNumberCode FROM dbo.tbl_Country WHERE CountryShortName IN (SELECT name FROM @Name)
END
GO
GRANT EXECUTE ON  [dbo].[usp_sys_GetCountriesByCountryShortNameList] TO [WebV4Role]
GO
