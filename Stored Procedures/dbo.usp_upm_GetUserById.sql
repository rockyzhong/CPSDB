SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[usp_upm_GetUserById] (@UserId bigint)
AS
BEGIN
  SELECT u.Id UserId,u.UserType UserType,u.UserName,u.FirstName,u.LastName,u.MiddleInitial,u.Password,
		 u.PasswordChangeDate,u.PasswordExpiryDate,u.LockoutDate,u.LockCount,u.ParentId,u.UserStatus,
		 u.BADGENAME,i.RegisteredName,i.TradeName1,i.TradeName2,i.TradeName3,i.Id IsoId,i.IsoCode,
         a.Id AddressId,a.City,a.AddressLine1,a.AddressLine2,a.PostalCode,a.Telephone1,a.Extension1,a.Telephone2,a.Extension2,a.Telephone3,a.Extension3,a.Fax,a.Email,
         r.Id RegionId,r.RegionFullName, r.RegionShortName,
         c.Id CountryId,c.CountryFullName,c.CountryShortName
  FROM dbo.tbl_upm_User u 
  LEFT JOIN dbo.tbl_Iso i ON u.IsoId=i.Id
  LEFT JOIN dbo.tbl_Address a ON u.AddressId =a.Id LEFT JOIN dbo.tbl_Region r ON a.RegionId=r.Id LEFT JOIN dbo.tbl_Country c ON r.CountryId=c.Id 
  WHERE u.Id=@UserId
END
GO
GRANT EXECUTE ON  [dbo].[usp_upm_GetUserById] TO [WebV4Role]
GO
