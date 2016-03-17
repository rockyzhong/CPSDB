SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_trn_GetCheckTransactionPrintable]
@CustomerId bigint
AS
BEGIN
  SELECT 
    t.OriginalTransactionId,t.Id TransactionId,t.SystemDate,t.SystemTime,t.SystemSettlementDate,t.TransactionType,t.TransactionReason,
    t.DeviceId,t.DeviceDate,t.DeviceSequence,t.NetworkId,t.NetworkSettlementDate1,t.NetworkSettlementDate2,t.NetworkTransactionId,t.NetworkMerchantStationId,
    t.RoutingCode,t.AuthenticationNumber,t.AmountRequest,t.AmountAuthenticate,t.AmountSettlement,t.AmountSettlementDestination,
    t.AmountSurchargeWaived+t.AmountSurcharge,t.AmountSurchargeWaived,t.AmountSurcharge,t.SurchargeWaiveAuthorityId,
    t.CurrencyRequest,t.CurrencySource,t.CurrencyDestination,t.CurrencyDeviceRate,t.CurrencyNetworkRate,
    t.ResponseCodeInternal,t.ResponseCodeExternal,t.ResponseSubCodeExternal,t.CustomerMediaType,t.CustomerMediaEntryMode,
    t.CustomerMediaDataPart1,t.CustomerMediaDataPart2,t.CustomerMediaDataHash,t.CustomerMediaDataEncrypted,
    t.ReferenceNumber,t.ServiceFee,t.ACHEntryClass,t.ACHECheckAck,t.CreatedUserId,
    t.PayoutCash,t.PayoutDeposit,t.PayoutChips,t.PayoutMarker,t.PayoutOther,t.PayoutStatus,
    txc.ImageData,txc.ExtendedColumn,
    c.Id CustomerId,c.FirstName,c.LastName,c.MiddleInitial,c.Suffix,c.Birthday,c.Gender,c.SSN,c.CompanyName,
    c.IdNumber,c.IdState,c.IdExpiryDate,c.IdEntryMode,c.IdEntryCode,c.CreationDate,c.AddressId,
    d.TerminalName
  FROM dbo.tbl_trn_Transaction t
  LEFT JOIN dbo.tbl_trn_TransactionreExtendedColumn txc ON t.Id=txc.TranId 
  LEFT JOIN dbo.tbl_Customer c ON t.CustomerId=c.Id 
  LEFT JOIN dbo.tbl_Device d ON t.DeviceId=d.Id
  WHERE t.CustomerId=@CustomerId
    AND t.SystemDate>=DATEADD(hh,-6,GETUTCDATE())
    AND ((t.TransactionType IN (56) AND t.PayoutStatus IN (3,4,5)) OR (t.TransactionType IN (156) AND t.PayoutStatus IN (2))) AND t.ResponseCodeInternal=0
END
GO
GRANT EXECUTE ON  [dbo].[usp_trn_GetCheckTransactionPrintable] TO [SAV4Role]
GRANT EXECUTE ON  [dbo].[usp_trn_GetCheckTransactionPrintable] TO [WebV4Role]
GO
