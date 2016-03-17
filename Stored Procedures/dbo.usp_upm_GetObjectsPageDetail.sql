SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_upm_GetObjectsPageDetail]
@Source         SourceTable READONLY,
@SourceType     bigint,
@OrderColumn    nvarchar(200),
@OrderDirection nvarchar(200),
@StartRow       bigint,
@EndRow         bigint
WITH EXECUTE AS 'dbo'
AS
BEGIN
  DECLARE @SQL nvarchar(max)
  IF @SourceType=1
  SET @SQL=N'
    WITH Devices AS (
    SELECT d.Id DeviceId,d.TerminalName,d.ReportName,d.SerialNumber,
           d.RoutingFlags,d.FunctionFlags,d.Currency,d.CreatedDate,d.UpdatedDate,d.DeviceStatus,
           o.Id ModelId,o.Make,o.Model,
           i.Id IsoId,i.RegisteredName,i.TradeName1,i.TradeName2,i.TradeName3,i.IsoCode,
           t.Id TimeZoneId,t.TimeZoneName,t.TimeZoneTime,
           a.Id AddressId,a.City,a.AddressLine1,a.AddressLine2,a.PostalCode,a.Telephone1,a.Extension1,a.Telephone2,a.Extension2,a.Telephone3,a.Extension3,a.Fax,a.Email,
           r.Id RegionId,r.RegionFullName,r.RegionShortName,
           c.Id CountryId,c.CountryFullName,c.CountryShortName,
           ROW_NUMBER() OVER(ORDER BY '+@OrderColumn+N' '+@OrderDirection+N') AS RowNumber
    FROM dbo.tbl_Device d JOIN @Source s ON d.Id=s.Id 
    LEFT JOIN dbo.tbl_DeviceModel o ON d.ModelId=o.Id 
    LEFT JOIN dbo.tbl_Iso         i ON d.IsoId=i.Id 
    LEFT JOIN dbo.tbl_TimeZone    t ON d.TimeZoneId=t.Id
    LEFT JOIN dbo.tbl_Address     a ON d.AddressId=a.Id LEFT JOIN dbo.tbl_Region r ON a.RegionId=r.Id LEFT JOIN dbo.tbl_Country c ON r.CountryId=c.Id)
    
    SELECT DeviceId,TerminalName,ReportName,SerialNumber,
           RoutingFlags,FunctionFlags,Currency,CreatedDate,UpdatedDate,DeviceStatus,
           ModelId,Make,Model,
           IsoId,RegisteredName,TradeName1,TradeName2,TradeName3,IsoCode,
           TimeZoneId,TimeZoneName,TimeZoneTime,
           AddressId,City,AddressLine1,AddressLine2,PostalCode,Telephone1,Extension1,Telephone2,Extension2,Telephone3,Extension3,Fax,Email,
           RegionId,RegionFullName,RegionShortName,
           CountryId,CountryFullName,CountryShortName
    FROM Devices WHERE RowNumber>=@StartRow AND RowNumber<@EndRow ORDER BY '+@OrderColumn+N' '+@OrderDirection+N'
  '
  EXEC SP_EXECUTESQL @SQL,N'@Source SourceTable READONLY,@StartRow bigint,@EndRow bigint',@Source,@StartRow,@EndRow
END
GO
GRANT EXECUTE ON  [dbo].[usp_upm_GetObjectsPageDetail] TO [WebV4Role]
GO
