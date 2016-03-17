SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_sys_GetRegionsByCountryShortNameList]
@CountryShortNameList  nvarchar(50)
AS
BEGIN
  SET NOCOUNT ON
  DECLARE @Name TABLE(name nvarchar(2))
  INSERT INTO @Name EXEC dbo.usp_sys_Split @CountryShortNameList
  SELECT r.Id RegionId,r.RegionFullName,r.RegionShortName,r.CountryId FROM dbo.tbl_Region r, dbo.tbl_Country c WHERE r.CountryId = c.Id AND c.CountryShortName IN (SELECT name FROM @Name)
END
GO
GRANT EXECUTE ON  [dbo].[usp_sys_GetRegionsByCountryShortNameList] TO [WebV4Role]
GO
