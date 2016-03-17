SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_iso_GetIsoAddress]
@IsoId          bigint,
@IsoAddressType bigint
AS
BEGIN
  SELECT i.Id IsoAddressId,i.IsoId,i.IsoAddressType,
         a.Id AddressId,a.City,a.AddressLine1,a.AddressLine2,a.PostalCode,a.Telephone1,a.Extension1,a.Telephone2,a.Extension2,a.Telephone3,a.Extension3,a.Fax,a.Email,
         r.Id RegionId,r.RegionFullName, r.RegionShortName,
         c.Id CountryId,c.CountryFullName,c.CountryShortName
  FROM dbo.tbl_IsoAddress i LEFT JOIN dbo.tbl_Address a ON i.AddressId =a.Id LEFT JOIN dbo.tbl_Region r ON a.RegionId=r.Id LEFT JOIN dbo.tbl_Country c ON r.CountryId=c.Id 
  WHERE IsoId=@IsoId AND IsoAddressType=@IsoAddressType
END
GO
GRANT EXECUTE ON  [dbo].[usp_iso_GetIsoAddress] TO [WebV4Role]
GO
