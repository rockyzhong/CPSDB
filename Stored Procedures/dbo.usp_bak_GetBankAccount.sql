SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_bak_GetBankAccount]
@BankAccountId     bigint
AS
BEGIN
  SET NOCOUNT ON

  SELECT b.Id BankAccountId,b.BankAccountType,b.BankAccountCategory,b.HolderName,b.Rta,b.Currency,b.BankName,b.ConsolidationType,b.BankAccountStatus,b.CriminalCheckStatus,b.CriminalCheckIssueDate,
         i.Id IsoId,i.RegisteredName,i.TradeName1,i.TradeName2,i.TradeName3,i.IsoCode,
         a1.Id AddressId,a1.City,a1.AddressLine1,a1.AddressLine2,a1.PostalCode,a1.Telephone1,a1.Extension1,a1.Telephone2,a1.Extension2,a1.Telephone3,a1.Extension3,a1.Fax,a1.Email,
         r1.Id RegionId,r1.RegionFullName,r1.RegionShortName,
         c1.Id CountryId,c1.CountryFullName,c1.CountryShortName,
         a2.Id BankAddressId,a2.City BankCity,a2.AddressLine1 BankAddressLine1,a2.AddressLine2 BankAddressLine2,a2.PostalCode BankPostalCode,a2.Telephone1 BankTelephone1,a2.Extension1 BankExtension1,a2.Telephone2 BankTelephone2,a2.Extension2 BankExtension2,a2.Telephone3 BankTelephone3,a2.Extension3 BankExtension3,a2.Fax BankFax,a2.Email BankEmail,
         r2.Id BankRegionId,r2.RegionFullName BankRegionFullName,r2.RegionShortName BankRegionShortName,
         c2.Id BankCountryId,c2.CountryFullName BankCountryFullName,c2.CountryShortName BankCountryShortName
  FROM dbo.tbl_BankAccount b LEFT JOIN dbo.tbl_Iso i ON b.IsoId=i.Id 
  LEFT JOIN dbo.tbl_Address a1 ON b.AddressId    =a1.Id LEFT JOIN dbo.tbl_Region r1 ON a1.RegionId=r1.Id LEFT JOIN dbo.tbl_Country c1 ON r1.CountryId=c1.Id 
  LEFT JOIN dbo.tbl_Address a2 ON b.BankAddressId=a2.Id LEFT JOIN dbo.tbl_Region r2 ON a2.RegionId=r2.Id LEFT JOIN dbo.tbl_Country c2 ON r2.CountryId=c2.Id 
  WHERE b.Id=@BankAccountId

END
GO
GRANT EXECUTE ON  [dbo].[usp_bak_GetBankAccount] TO [WebV4Role]
GO
