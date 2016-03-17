SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_sys_GetRegion]
@RegionId bigint
AS
BEGIN
  SELECT r.Id RegionId,r.RegionFullName,r.RegionShortName,
         c.Id CountryId,c.CountryFullName,c.CountryShortName,c.CountryNumberCode
  FROM dbo.tbl_Region r JOIN tbl_Country c ON r.CountryId=c.Id WHERE r.Id=@RegionId
END
GO
GRANT EXECUTE ON  [dbo].[usp_sys_GetRegion] TO [WebV4Role]
GO
