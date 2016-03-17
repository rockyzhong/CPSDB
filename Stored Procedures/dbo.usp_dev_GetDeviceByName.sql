SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_dev_GetDeviceByName] (@TerminalName nvarchar(50))
AS
BEGIN
  SELECT d.Id DeviceId,d.TerminalName,d.RoutingFlags,d.Currency,
         d.MasterPinKeyCryptogram,d.MasterMacKeyCryptogram,WorkingPinKeyCryptogram,WorkingMacKeyCryptogram,d.UpdatedDate,
         t.Id TimeZoneId,t.TimeZoneName,t.TimeZoneTime,t.TimeZoneOffset,DayLightSavingTime,
         a.Id AddressId,a.City,a.AddressLine1,a.AddressLine2,a.PostalCode,
         r.Id RegionId,r.RegionFullName,r.RegionShortName,
         c.Id CountryId,c.CountryFullName,c.CountryShortName
  FROM dbo.tbl_Device d 
  LEFT JOIN dbo.tbl_TimeZone t ON d.TimeZoneId=t.Id
  LEFT JOIN dbo.tbl_Address  a ON d.AddressId=a.Id LEFT JOIN dbo.tbl_Region r ON a.RegionId=r.Id LEFT JOIN dbo.tbl_Country c ON r.CountryId=c.Id
  WHERE d.TerminalName=@TerminalName AND d.DeviceStatus=1
END
GO
GRANT EXECUTE ON  [dbo].[usp_dev_GetDeviceByName] TO [WebV4Role]
GO
