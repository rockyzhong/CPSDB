SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_dev_GetDeviceById] (@DeviceId bigint)
AS
BEGIN

  DECLARE @LastTransTime datetime,@LastTransData nvarchar(500),@LastMgmtTime datetime,@LastMgmtData nvarchar(500)
  --SELECT @LastTransTime=SystemDate,@LastTransData=dbo.udf_GetValueName(19,TransactionType)+' '+dbo.udf_GetValueName(105,ResponseCodeInternal)+' [$'+CONVERT(nvarchar,CONVERT(money,CASE WHEN ResponseCodeInternal=0 THEN AmountSettlement ELSE AmountRequest END)/100)+'] SeqNo['+CONVERT(nvarchar,DeviceSequence)+']'
  --FROM dbo.tbl_trn_Transaction WHERE Id=(SELECT MAX(Id) FROM dbo.tbl_trn_Transaction WHERE DeviceId=@DeviceId)

  SELECT 
      @LastTransTime=SystemTime,@LastTransData=dbo.udf_GetValueName(19,TransactionType)+' '+dbo.udf_GetValueName(105,ResponseCodeInternal)
                  +' ['+CONVERT(nvarchar,DeviceSequence)
                  +']'
                  +' for [$'
                  +CONVERT(nvarchar,CONVERT(money, AmountRequest)/100)
                  +' + $'
                  +CONVERT(nvarchar,CONVERT(money, AmountSurchargeRequest)/100)
                  +'] by ['
                  + CASE WHEN SmartAcquierId is NULL THEN 'Cage' ELSE CONVERT(nvarchar,SmartAcquierId) END
                  +']'
  FROM dbo.tbl_trn_Transaction WHERE Id=(SELECT MAX(Id) FROM dbo.tbl_trn_Transaction WHERE DeviceId=@DeviceId)


  SELECT @LastMgmtTime=ManagementDate,@LastMgmtData=ManagementData
  FROM dbo.tbl_DeviceManagementActivity WHERE Id=(SELECT MAX(Id) FROM dbo.tbl_DeviceManagementActivity WHERE DeviceId=@DeviceId)

  SELECT d.Id DeviceId,d.TerminalName,d.ReportName,d.SerialNumber,d.RoutingFlags,d.FunctionFlags,d.Currency,d.QuestionablePolicy,
         d.FeeType,d.LocationType,d.Location,d.RefusedTransactionTypeList,d.MaximumDispensedAmount,d.CreatedDate,d.UpdatedDate,d.DeviceStatus,
         o.Id ModelId,o.Make,o.Model,o.DeviceEmulation,v.Name DeviceEmulationName,
         i.Id IsoId,i.RegisteredName,i.TradeName1,i.TradeName2,i.TradeName3,i.IsoCode,
         t.Id TimeZoneId,t.TimeZoneName,t.TimeZoneTime,t.TimeZoneOffset,DayLightSavingTime,
         a.Id AddressId,a.City,a.AddressLine1,a.AddressLine2,a.PostalCode,a.Telephone1,a.Extension1,a.Telephone2,a.Extension2,a.Telephone3,a.Extension3,a.Fax,a.Email,
         r.Id RegionId,r.RegionFullName,r.RegionShortName,
         c.Id CountryId,c.CountryFullName,c.CountryShortName,
         @LastTransTime LastTransTime,@LastTransData LastTransData,@LastMgmtTime LastMgmtTime,@LastMgmtData LastMgmtData
  FROM dbo.tbl_Device d 
  LEFT JOIN dbo.tbl_DeviceModel o ON d.ModelId=o.Id LEFT JOIN dbo.tbl_TypeValue v ON v.TypeId=131 AND v.Value=o.DeviceEmulation
  LEFT JOIN dbo.tbl_Iso         i ON d.IsoId=i.Id 
  LEFT JOIN dbo.tbl_TimeZone    t ON d.TimeZoneId=t.Id
  LEFT JOIN dbo.tbl_Address     a ON d.AddressId=a.Id LEFT JOIN dbo.tbl_Region r ON a.RegionId=r.Id LEFT JOIN dbo.tbl_Country c ON r.CountryId=c.Id 
  WHERE d.Id=@DeviceId
END
GO
GRANT EXECUTE ON  [dbo].[usp_dev_GetDeviceById] TO [WebV4Role]
GO
