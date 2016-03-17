SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_sys_GetRegions]
@CountryId bigint
AS
BEGIN
  SELECT Id RegionId,RegionFullName,RegionShortName FROM dbo.tbl_Region WHERE CountryId in (@CountryId)
END
GO
GRANT EXECUTE ON  [dbo].[usp_sys_GetRegions] TO [WebV4Role]
GO
