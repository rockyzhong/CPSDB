SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_sys_GetCountry]
@CountryId bigint
AS
BEGIN
  SELECT Id CountryId,CountryFullName,CountryShortName,CountryNumberCode FROM dbo.tbl_Country WHERE Id=@CountryId
END
GO
GRANT EXECUTE ON  [dbo].[usp_sys_GetCountry] TO [WebV4Role]
GO
