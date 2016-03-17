SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[usp_dev_GetDevices]
@TerminalName nvarchar(50) = NULL,
@Date         datetime     = NULL
WITH EXECUTE AS 'dbo'
AS
BEGIN
  DECLARE @SQL nvarchar(4000)
  SET @SQL='
  SELECT d.Id DeviceId,d.IsoId,d.TerminalName,d.FunctionFlags,d.RoutingFlags,d.Currency,d.FeeType,d.Location,d.RefusedTransactionTypeList,d.MaximumDispensedAmount,
         d.MasterPinKeyCryptogram,d.MasterMacKeyCryptogram,d.WorkingPinKeyCryptogram,d.WorkingMacKeyCryptogram,d.WorkingPinKeyUpdatedDate,d.WorkingMACKeyUpdatedDate,d.DeviceStatus,d.UpdatedDate,
         o.DeviceEmulation,o.MaxBillsPerCassette,o.MaxBillsPerDispense,
         i.RegisteredName,
         t.TimeZoneTime,t.TimeZoneOffset,DayLightSavingTime,
         a.City,a.AddressLine1,a.AddressLine2,a.PostalCode,
         r.RegionFullName,r.RegionShortName,
         c.CountryNumberCode,c.CountryFullName,c.CountryShortName
  FROM dbo.tbl_Device d 
  LEFT JOIN dbo.tbl_DeviceModel o ON d.ModelId=o.Id 
  LEFT JOIN dbo.tbl_Iso         i ON d.IsoId=i.Id 
  LEFT JOIN dbo.tbl_TimeZone    t ON d.TimeZoneId=t.Id
  LEFT JOIN dbo.tbl_Address     a ON d.AddressId =a.Id LEFT JOIN dbo.tbl_Region r ON a.RegionId=r.Id LEFT JOIN dbo.tbl_Country c ON r.CountryId=c.Id 
  WHERE 1>0'
  IF @Date         IS NOT NULL  SET @SQL=@SQL+' AND d.UpdatedDate>@Date'
  IF @TerminalName IS NOT NULL  SET @SQL=@SQL+' AND d.TerminalName=@TerminalName'
  
  SET @SQL=@SQL+'
  SELECT e.DeviceId,d.TerminalName,e.DeviceEmulation,e.ExtendedColumnType,e.ExtendedColumnValue,e.SwitchUserFlag
  FROM dbo.tbl_DeviceExtendedValue e
  JOIN dbo.tbl_Device d ON e.DeviceId=d.Id
  WHERE d.DeviceStatus=1'
  IF @Date         IS NOT NULL  SET @SQL=@SQL+' AND d.UpdatedDate>@Date'
  IF @TerminalName IS NOT NULL  SET @SQL=@SQL+' AND d.TerminalName=@TerminalName'
  
  SET @SQL=@SQL+'
  SELECT o.DeviceId,d.TerminalName,o.FeeOverridePriority,r.FeeOverrideType,r.FeeOverrideData,o.FeeFixed,o.FeePercentage
  FROM dbo.tbl_DeviceFeeOverride o 
  JOIN dbo.tbl_DeviceFeeOverrideRule r ON r.FeeOverrideId=o.Id
  JOIN dbo.tbl_Device d ON o.DeviceId=d.Id
  WHERE d.DeviceStatus=1'
  IF @Date         IS NOT NULL  SET @SQL=@SQL+' AND d.UpdatedDate>@Date'
  IF @TerminalName IS NOT NULL  SET @SQL=@SQL+' AND d.TerminalName=@TerminalName'
  SET @SQL=@SQL+' ORDER BY o.DeviceId ASC,o.FeeOverridePriority DESC'

  SET @SQL=@SQL+'
  SELECT c.DeviceId,d.TerminalName,c.FromCurrency,c.ToCurrency,ExchangeRate 
  FROM dbo.tbl_DeviceCurrencyExchangeRate c
  JOIN dbo.tbl_Device d ON c.DeviceId=d.Id AND c.FromCurrency=d.Currency 
  WHERE d.DeviceStatus=1'
  IF @Date         IS NOT NULL  SET @SQL=@SQL+' AND d.UpdatedDate>@Date'
  IF @TerminalName IS NOT NULL  SET @SQL=@SQL+' AND d.TerminalName=@TerminalName'
  
  SET @SQL=@SQL+'
  SELECT c.DeviceId,d.TerminalName,c.CassetteId,c.Currency,c.MediaCode,c.MediaValue,c.MediaCurrentCount,c.MediaCurrentUse 
  FROM dbo.tbl_DeviceCassette c
  JOIN dbo.tbl_Device d ON c.DeviceId=d.Id
  WHERE d.DeviceStatus=1'
  IF @Date         IS NOT NULL  SET @SQL=@SQL+' AND d.UpdatedDate>@Date'
  IF @TerminalName IS NOT NULL  SET @SQL=@SQL+' AND d.TerminalName=@TerminalName'
  
  SET @SQL=@SQL+'
  SELECT e.DeviceId,d.TerminalName,e.DeviceEmulation,e.AccessoryCode,e.ErrorCode,e.ErrorText
  FROM dbo.tbl_DeviceError e
  JOIN dbo.tbl_Device d ON e.DeviceId=d.Id
  WHERE d.DeviceStatus=1 AND e.ResolvedDate IS NULL'
  IF @Date         IS NOT NULL  SET @SQL=@SQL+' AND d.UpdatedDate>@Date'
  IF @TerminalName IS NOT NULL  SET @SQL=@SQL+' AND d.TerminalName=@TerminalName'

  SET @SQL=@SQL+'
  SELECT f.DeviceId,d.TerminalName,f.FeeType,f.StartDate,f.EndDate,f.AmountFrom,f.AmountTo,f.FeeFixed,f.FeePercentage,f.FeeAddedPercentage
  FROM dbo.tbl_DeviceFee f
  JOIN dbo.tbl_Device d ON f.DeviceId=d.Id
  WHERE d.DeviceStatus=1 AND f.EndDate>GETUTCDATE() AND f.FeeType in (select FeeType from tbl_DeviceFeeType)'
  IF @Date         IS NOT NULL  SET @SQL=@SQL+' AND d.UpdatedDate>@Date'
  IF @TerminalName IS NOT NULL  SET @SQL=@SQL+' AND d.TerminalName=@TerminalName'

  SET @SQL=@SQL+'
  SELECT c.DeviceId,d.TerminalName,f.ScreenFileName,f.ConfigValueFileName,f.StateFileName,o.OverrideFileName,c.ConfigID,
         s.DefAuthState,s.DefDenyState,s.NextStates,s.LanguageStateOffsets,s.TransactionTypes,s.SourceAccounts,
         s.DestinationAccounts,s.CurrencyCodes,s.FastCashAmounts,s.Languages,s.NoReceiptValues,s.FeeRefuseVal
  FROM dbo.tbl_DeviceConfig c
  JOIN dbo.tbl_DeviceConfigFile   f ON c.DeviceConfigFileId=f.Id
  JOIN dbo.tbl_DeviceStateFile    s ON f.StateFileName=s.StateFileName
  JOIN dbo.tbl_DeviceOverrideFile o ON c.DeviceOverrideFileId=o.Id
  JOIN dbo.tbl_Device d ON c.DeviceId=d.Id
  WHERE d.DeviceStatus=1'
  IF @Date         IS NOT NULL  SET @SQL=@SQL+' AND d.UpdatedDate>@Date'
  IF @TerminalName IS NOT NULL  SET @SQL=@SQL+' AND d.TerminalName=@TerminalName'

  SET @SQL=@SQL+'
  SELECT c.DeviceId,d.TerminalName,c.ProtocolType,c.LocalIPAddress,c.LocalPort,c.RemoteIPAddress,c.RemotePort,c.IPAddressFlags,
         c.Caller,c.LocalAddress,c.CommsAPIType
  FROM dbo.tbl_DeviceConnection c
  JOIN dbo.tbl_Device d ON c.DeviceId=d.Id
  WHERE d.DeviceStatus=1'
  IF @Date         IS NOT NULL  SET @SQL=@SQL+' AND d.UpdatedDate>@Date'
  IF @TerminalName IS NOT NULL  SET @SQL=@SQL+' AND d.TerminalName=@TerminalName'
  
  SET @SQL=@SQL+'
  SELECT CONVERT(nvarchar,GETUTCDATE(),121) Date'
  
  EXEC sp_executesql @SQL,N'@TerminalName nvarchar(50),@Date datetime',@TerminalName,@Date
END
GO
GRANT EXECUTE ON  [dbo].[usp_dev_GetDevices] TO [SAV4Role]
GRANT EXECUTE ON  [dbo].[usp_dev_GetDevices] TO [WebV4Role]
GO
