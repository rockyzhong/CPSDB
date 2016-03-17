SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/**/
/**/
/**/
CREATE PROCEDURE [dbo].[usp_dev_GetDeviceContact]
@DeviceId          bigint
AS
BEGIN
  SELECT d.Id DeviceContactId,d.DeviceId,d.DeviceContactType,
         n.Id ContactId,n.FirstName,n.LastName,n.MiddleInitial,n.Title,
         a.Id AddressId,a.City,a.AddressLine1,a.AddressLine2,a.PostalCode,a.Telephone1,a.Extension1,a.Telephone2,a.Extension2,a.Telephone3,a.Extension3,a.Fax,a.Email,
         r.Id RegionId,r.RegionFullName,r.RegionShortName,
         c.Id CountryId,c.CountryFullName,c.CountryShortName
  FROM dbo.tbl_DeviceContact d
  LEFT JOIN dbo.tbl_Contact n ON d.ContactId=n.Id
  LEFT JOIN dbo.tbl_Address a ON n.AddressId=a.Id LEFT JOIN dbo.tbl_Region r ON a.RegionId=r.Id LEFT JOIN dbo.tbl_Country c ON r.CountryId=c.Id 
  WHERE d.DeviceId=@DeviceId ORDER BY DeviceContactType
END
GO
GRANT EXECUTE ON  [dbo].[usp_dev_GetDeviceContact] TO [WebV4Role]
GO
