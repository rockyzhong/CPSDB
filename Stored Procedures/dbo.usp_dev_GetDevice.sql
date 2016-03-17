SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[usp_dev_GetDevice] (@TerminalName nvarchar(50))
WITH EXECUTE AS 'dbo'
AS
BEGIN
  SELECT d.Id DeviceId,d.TerminalName,d.ReportName,d.SerialNumber,d.RoutingFlags,d.FunctionFlags,d.Currency,
         d.FeeType,d.Location,d.RefusedTransactionTypeList,d.MaximumDispensedAmount,d.CreatedDate,d.UpdatedDate,d.DeviceStatus,
         o.Id ModelId,o.Make,o.Model,o.DeviceEmulation,v.Name DeviceEmulationName,
         i.Id IsoId,i.RegisteredName,i.TradeName1,i.TradeName2,i.TradeName3,i.IsoCode,
         t.Id TimeZoneId,t.TimeZoneName,t.TimeZoneTime,t.TimeZoneOffset,DayLightSavingTime,
         a.Id AddressId,a.City,a.AddressLine1,a.AddressLine2,a.PostalCode,a.Telephone1,a.Extension1,a.Telephone2,a.Extension2,a.Telephone3,a.Extension3,a.Fax,a.Email,
         r.Id RegionId,r.RegionFullName,r.RegionShortName,
         c.Id CountryId,c.CountryFullName,c.CountryShortName,
		 dc.protocolType,dc.Caller,dc.LocalAddress,dc.LocalIPAddress,dc.CommsAPIType,dc.LocalAddress,dc.RemoteIPAddress,dc.RemotePort,dc.IPAddressFlags
  FROM dbo.tbl_Device d 
  LEFT JOIN dbo.tbl_DeviceModel o ON d.ModelId=o.Id LEFT JOIN dbo.tbl_TypeValue v ON v.TypeId=131 AND v.Value=o.DeviceEmulation
  LEFT JOIN dbo.tbl_Iso         i ON d.IsoId=i.Id 
  LEFT JOIN dbo.tbl_TimeZone    t ON d.TimeZoneId=t.Id
  LEFT JOIN dbo.tbl_Address     a ON d.AddressId=a.Id LEFT JOIN dbo.tbl_Region r ON a.RegionId=r.Id LEFT JOIN dbo.tbl_Country c ON r.CountryId=c.Id
  LEFT JOIN dbo.tbl_DeviceConnection dc ON d.id=dc.DeviceId
  WHERE d.TerminalName=@TerminalName --AND d.DeviceStatus=1
END
GO
GRANT EXECUTE ON  [dbo].[usp_dev_GetDevice] TO [WebV4Role]
GO
