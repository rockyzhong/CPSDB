SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[usp_upm_GetObjectsDetail]
@Source     SourceTable READONLY,
@SourceType bigint 
AS
BEGIN
  IF @SourceType=1
    SELECT d.Id DeviceId,d.TerminalName,d.ReportName,d.SerialNumber,
           d.RoutingFlags,d.FunctionFlags,d.Currency,d.CreatedDate,d.UpdatedDate,d.DeviceStatus,
           o.Id ModelId,o.Make,o.Model,
           i.Id IsoId,i.RegisteredName,i.TradeName1,i.TradeName2,i.TradeName3,i.IsoCode,
           t.Id TimeZoneId,t.TimeZoneName,t.TimeZoneTime,
           a.Id AddressId,a.City,a.AddressLine1,a.AddressLine2,a.PostalCode,a.Telephone1,a.Extension1,a.Telephone2,a.Extension2,a.Telephone3,a.Extension3,a.Fax,a.Email,
           r.Id RegionId,r.RegionFullName,r.RegionShortName,
           c.Id CountryId,c.CountryFullName,c.CountryShortName
    FROM dbo.tbl_Device d JOIN @Source s ON d.Id=s.Id 
    LEFT JOIN dbo.tbl_DeviceModel o ON d.ModelId=o.Id
    LEFT JOIN dbo.tbl_Iso         i ON d.IsoId=i.Id 
    LEFT JOIN dbo.tbl_TimeZone    t ON d.TimeZoneId=t.Id
    LEFT JOIN dbo.tbl_Address     a ON d.AddressId=a.Id LEFT JOIN dbo.tbl_Region r ON a.RegionId=r.Id LEFT JOIN dbo.tbl_Country c ON r.CountryId=c.Id
    WHERE d.DeviceStatus<>4

  ELSE IF @SourceType=2
    SELECT u.Id UserId,u.UserType UserType,u.UserName,u.FirstName,u.LastName,u.MiddleInitial,u.Password,
           u.PasswordChangeDate,u.PasswordExpiryDate,u.LockoutDate,u.LockCount,u.ParentId,u.UserStatus,
           i.Id IsoId,i.RegisteredName,i.TradeName1,i.TradeName2,i.TradeName3,i.IsoCode,
           a.Id AddressId,a.City,a.AddressLine1,a.AddressLine2,a.PostalCode,a.Telephone1,a.Extension1,a.Telephone2,a.Extension2,a.Telephone3,a.Extension3,a.Fax,a.Email,
           r.Id RegionId,r.RegionFullName, r.RegionShortName,
           c.Id CountryId,c.CountryFullName,c.CountryShortName
    FROM dbo.tbl_upm_User u JOIN @Source s ON u.Id=s.Id LEFT JOIN dbo.tbl_Iso i ON u.IsoId=i.Id 
    LEFT JOIN dbo.tbl_Address a ON u.AddressId=a.Id LEFT JOIN dbo.tbl_Region r ON a.RegionId=r.Id LEFT JOIN dbo.tbl_Country c ON r.CountryId=c.Id 
    WHERE u.UserStatus<>4
  
  ELSE IF @SourceType=3
    SELECT b.Id BankAccountId,b.BankAccountType,b.BankAccountCategory,b.HolderName,b.Rta,b.Currency,b.BankName,b.ConsolidationType,b.BankAccountStatus,
           i.Id IsoId,i.RegisteredName,i.TradeName1,i.TradeName2,i.TradeName3,i.IsoCode,
           a1.Id AddressId,a1.City,a1.AddressLine1,a1.AddressLine2,a1.PostalCode,a1.Telephone1,a1.Extension1,a1.Telephone2,a1.Extension2,a1.Telephone3,a1.Extension3,a1.Fax,a1.Email,
           r1.Id RegionId,r1.RegionFullName,r1.RegionShortName,
           c1.Id CountryId,c1.CountryFullName,c2.CountryShortName,
           a2.Id BankAddressId,a2.City BankCity,a2.AddressLine1 BankAddressLine1,a2.AddressLine2 BankAddressLine2,a2.PostalCode BankPostalCode,a2.Telephone1 BankTelephone1,a2.Extension1 BankExtension1,a2.Telephone2 BankTelephone2,a2.Extension2 BankExtension2,a2.Telephone3 BankTelephone3,a2.Extension3 BankExtension3,a2.Fax BankFax,a2.Email BankEmail,
           r2.Id BankRegionId,r2.RegionFullName BankRegionFullName,r2.RegionFullName BankRegionShortName,
           c2.Id BankCountryId,c2.CountryFullName BankCountryFullName,c2.CountryFullName BankCountryShortName
    FROM dbo.tbl_BankAccount b JOIN @Source s ON b.Id=s.Id LEFT JOIN dbo.tbl_Iso i ON b.IsoId=i.Id 
    LEFT JOIN dbo.tbl_Address a1 ON b.AddressId    =a1.Id LEFT JOIN dbo.tbl_Region r1 ON a1.RegionId=r1.Id LEFT JOIN dbo.tbl_Country c1 ON r1.CountryId=c1.Id 
    LEFT JOIN dbo.tbl_Address a2 ON b.BankAddressId=a2.Id LEFT JOIN dbo.tbl_Region r2 ON a2.RegionId=r2.Id LEFT JOIN dbo.tbl_Country c2 ON r2.CountryId=c2.Id 
    WHERE b.BankAccountStatus<>4

  ELSE IF @SourceType=4
    SELECT i.Id IsoId,i.RegisteredName,i.TradeName1,i.TradeName2,i.TradeName3,i.Website,i.IsoCode,i.IsoStatus,i.ParentId,p.RegisteredName ParentRegisteredName,
           t.Id TimeZoneId,t.TimeZoneName,t.TimeZoneTime,t.TimeZoneOffset,t.DayLightSavingTime
    FROM dbo.tbl_Iso i JOIN @Source s ON i.Id=s.Id LEFT JOIN dbo.tbl_Iso p ON p.Id=i.ParentId JOIN dbo.tbl_TimeZone t ON t.Id=i.TimeZoneId
    WHERE i.IsoStatus<>4

  ELSE IF @SourceType=5
    SELECT i.Id InterchangeSchemeId,i.InterchangeSchemeName,i.Description
    FROM dbo.tbl_InterchangeScheme i JOIN @Source s ON i.Id=s.Id

  ELSE IF @SourceType=6
    SELECT n.Id NetworkId,n.NetworkCode,n.NetworkName,n.Description,t.Value Currency,t.Name CurrencyName,t.Description CurrencyDescription
    FROM dbo.tbl_Network n JOIN @Source s ON n.Id=s.Id JOIN dbo.tbl_TypeValue t ON n.Currency=t.Value AND t.TypeId=67
  
  ELSE IF @SourceType=7
    SELECT r.Id ReportId,r.ReportGroup,r.ReportName,r.ReportSchemas,r.ReportSequence,r.IsBatchReport, r.IsOnlineReport, r.OutputFormats, r.Description, g.ClassName
    FROM dbo.tbl_Report r JOIN @Source s ON r.Id=s.Id JOIN dbo.tbl_Report_Generator g on r.GeneratorId = g.Id
    ORDER BY r.ReportSequence
END
GO
GRANT EXECUTE ON  [dbo].[usp_upm_GetObjectsDetail] TO [WebV4Role]
GO
