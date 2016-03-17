SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_trn_GetCheckTransactionVoidable] 
@CustomerId bigint,
@Isoid bigint,
@BussinessTime nvarchar(16)
AS
BEGIN
  SELECT 
    t.OriginalTransactionId,t.Id TransactionId,t.SystemDate,t.SystemTime,t.SystemSettlementDate,t.TransactionType,t.TransactionReason,
    t.NetworkMerchantStationId,ns.StationNumber,t.DeviceId,t.DeviceDate,t.DeviceSequence,t.NetworkId,t.NetworkSettlementDate1,t.NetworkSettlementDate2,t.NetworkTransactionId,t.NetworkMerchantStationId,
    t.RoutingCode,t.AuthenticationNumber,t.AmountRequest,t.AmountAuthenticate,t.AmountSettlement,t.AmountSettlementDestination,
    t.AmountSurchargeWaived+t.AmountSurcharge,t.AmountSurchargeWaived,t.AmountSurcharge,t.SurchargeWaiveAuthorityId,
    t.CurrencyRequest,t.CurrencySource,t.CurrencyDestination,t.CurrencyDeviceRate,t.CurrencyNetworkRate,
    t.ResponseCodeInternal,t.ResponseCodeExternal,t.ResponseSubCodeExternal,t.CustomerMediaType,t.CustomerMediaEntryMode,
    t.CustomerMediaDataPart1,t.CustomerMediaDataPart2,t.CustomerMediaDataHash,t.CustomerMediaDataEncrypted,
    t.ReferenceNumber,t.ServiceFee,t.ACHEntryClass,t.ACHECheckAck,t.CreatedUserId,
    t.PayoutCash,t.PayoutDeposit,t.PayoutChips,t.PayoutMarker,t.PayoutOther,t.PayoutStatus,
    trx.ImageData,trx.ExtendedColumn,
    d.TerminalName
  FROM dbo.tbl_trn_Transaction t
  JOIN dbo.tbl_Device d ON d.IsoId = @IsoId AND t.DeviceId = d.Id
  LEFT JOIN dbo.tbl_trn_TransactionreExtendedColumn trx ON t.Id=trx.TranId
 -- LEFT JOIN dbo.tbl_Device d ON t.DeviceId=d.Id 
  LEFT JOIN dbo.tbl_NetworkMerchantStation ns on ns.Id=t.NetworkMerchantStationId
  WHERE t.CustomerId=@CustomerId
   AND t.SystemDate>CONVERT(datetime,@BussinessTime)
    AND t.TransactionType=56 AND t.PayoutStatus >2  AND t.ResponseCodeInternal=0
    AND t.Id NOT IN (SELECT OriginalTransactionId from dbo.tbl_trn_Transaction t1 WHERE t1.CustomerId=@CustomerId AND t1.TransactionType=156)
END
GO
GRANT EXECUTE ON  [dbo].[usp_trn_GetCheckTransactionVoidable] TO [SAV4Role]
GRANT EXECUTE ON  [dbo].[usp_trn_GetCheckTransactionVoidable] TO [WebV4Role]
GO
