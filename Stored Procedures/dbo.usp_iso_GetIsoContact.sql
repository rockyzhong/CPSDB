SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_iso_GetIsoContact]
@IsoId          bigint
AS
BEGIN
  SELECT i.Id IsoContactId,i.IsoId,i.IsoContactType,
         n.Id ContactId,n.FirstName,n.LastName,n.MiddleInitial,n.Title,
         a.Id AddressId,a.City,a.AddressLine1,a.AddressLine2,a.PostalCode,a.Telephone1,a.Extension1,a.Telephone2,a.Extension2,a.Telephone3,a.Extension3,a.Fax,a.Email,
         r.Id RegionId,r.RegionFullName,r.RegionShortName,
         c.Id CountryId,c.CountryFullName,c.CountryShortName
  FROM dbo.tbl_IsoContact i
  LEFT JOIN dbo.tbl_Contact n ON i.ContactId=n.Id
  LEFT JOIN dbo.tbl_Address a ON n.AddressId=a.Id LEFT JOIN dbo.tbl_Region r ON a.RegionId=r.Id LEFT JOIN dbo.tbl_Country c ON r.CountryId=c.Id 
  WHERE i.IsoId=@IsoId ORDER BY IsoContactType
END
GO
GRANT EXECUTE ON  [dbo].[usp_iso_GetIsoContact] TO [WebV4Role]
GO
