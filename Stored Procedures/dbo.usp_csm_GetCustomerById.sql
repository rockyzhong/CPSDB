SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_csm_GetCustomerById] (@CustomerId bigint)
AS
BEGIN
    SET NOCOUNT ON
    SELECT s.Id,s.FirstName,s.LastName,s.MiddleInitial,s.Suffix,s.CompanyName,s.Birthday,s.Gender,s.SSN,
           s.IdNumber, s.IdType,s.IdState,IdExpiryDate,s.IdEntryMode,s.IdEntryCode,s.CreationDate,
           a.City,a.AddressLine1,a.AddressLine2,a.PostalCode,a.Telephone1,a.Extension1,a.Telephone2,a.Extension2,a.Telephone3,a.Extension3,a.Fax,a.Email,
           r.RegionFullName, r.RegionShortName,
           c.CountryFullName,c.CountryShortName
    FROM dbo.tbl_Customer s LEFT JOIN dbo.tbl_Address a ON s.AddressId=a.Id LEFT JOIN dbo.tbl_Region r ON a.RegionId=r.Id LEFT JOIN dbo.tbl_Country c ON r.CountryId=c.Id 
    WHERE s.Id=@CustomerId
END
GO
GRANT EXECUTE ON  [dbo].[usp_csm_GetCustomerById] TO [WebV4Role]
GO
