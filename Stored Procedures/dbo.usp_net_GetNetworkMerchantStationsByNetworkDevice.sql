SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_net_GetNetworkMerchantStationsByNetworkDevice] 
@NetworkId bigint,
@DeviceId  bigint
AS
BEGIN
  --SELECT TOP 1
  --       m.Id NetworkMerchantId,m.NetworkId,m.IsoId,m.MerchantId,
  --       s.Id NetworkMerchantStationId,s.StationNumber,s.CheckType,s.ServiceType,s.AccountChain,s.CheckLimit,s.SDelayDays,s.VarianceLimit,s.OverridePermitted,
  --       s.AdjustToCAP,s.CheckNumberRequired,s.StandInModeAPermitted,s.StandInModeCPermitted,s.StandInLimit,s.ACHEntryClass,s.ExpiryDays,s.DVariancePermitted,
  --       s.DefaultStation,s.StationName,s.PayToName,s.CreditEligible,s.SSNNumberReqFlag,s.IDType,s.SettlementType,s.StatusId,s.CreditLimit,s.ManualFMEntryAllowed,
  --       s.SettlementOption,s.SettleSmartOption,s.FrankingOption,s.OTB_Enabled,s.OTB_Casino_Day_FLG,s.Cust_Trans_Hist_Option,s.Cust_Trans_Hist_Days,s.TXNORGID,
  --       s.Service_Fee_Option,s.ACH_Manual_Entry_Override,s.Tribal_ID_Option,s.Mexican_ID_Option,s.Kiosk_Enabled
  --FROM dbo.tbl_NetworkMerchantStation s
  --JOIN dbo.tbl_NetworkMerchant m ON s.NetworkMerchantId=m.Id 
  --JOIN dbo.tbl_Device d ON m.IsoId=d.IsoId
  --WHERE m.NetworkId=@NetworkId AND d.Id=@DeviceId AND s.Kiosk_Enabled='Y'
  
  SELECT TOP 1 * 
  FROM tbl_NetworkMerchantStation s
	LEFT JOIN tbl_Device d ON d.Id = @DeviceId
	LEFT JOIN tbl_NetworkMerchant m ON m.Id = s.NetworkMerchantId
  WHERE m.IsoId = d.IsoId 
	AND m.NetworkId = @NetworkId
	AND s.StationNumber=(SELECT ExtendedColumnValue 
							FROM tbl_DeviceExtendedValue
							WHERE DeviceId=@DeviceId 
								AND DeviceEmulation=199 
								AND ExtendedColumnType=5)  
END
GO
GRANT EXECUTE ON  [dbo].[usp_net_GetNetworkMerchantStationsByNetworkDevice] TO [WebV4Role]
GO
