SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_net_GetNetworkMerchantStation] (@NetworkMerchantStationId bigint)
AS
BEGIN
  SELECT m.Id NetworkMerchantId,m.NetworkId,m.IsoId,m.MerchantId,
         s.Id NetworkMerchantStationId,s.StationNumber,s.CheckType,s.ServiceType,s.AccountChain,s.CheckLimit,s.SDelayDays,s.VarianceLimit,s.OverridePermitted,
         s.AdjustToCAP,s.CheckNumberRequired,s.StandInModeAPermitted,s.StandInModeCPermitted,s.StandInLimit,s.ACHEntryClass,s.ExpiryDays,s.DVariancePermitted,
         s.DefaultStation,s.StationName,s.PayToName,s.CreditEligible,s.SSNNumberReqFlag,s.IDType,s.SettlementType,s.StatusId,s.CreditLimit,s.ManualFMEntryAllowed,
         s.SettlementOption,s.SettleSmartOption,s.FrankingOption,s.OTB_Enabled,s.OTB_Casino_Day_FLG,s.Cust_Trans_Hist_Option,s.Cust_Trans_Hist_Days,s.TXNORGID,
         s.Service_Fee_Option,s.ACH_Manual_Entry_Override,s.Tribal_ID_Option,s.Mexican_ID_Option,s.Kiosk_Enabled
   FROM dbo.tbl_NetworkMerchantStation s
   JOIN dbo.tbl_NetworkMerchant m ON s.NetworkMerchantId=m.Id
   WHERE s.Id=@NetworkMerchantStationId
END
GO
GRANT EXECUTE ON  [dbo].[usp_net_GetNetworkMerchantStation] TO [WebV4Role]
GO
