SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
 CREATE PROCEDURE [dbo].[usp_trn_GetTransactionByNetworkTransactionId]
  @NetworkTransactionId    NVARCHAR(50),
  @NetworkId BIGINT=NULL
AS
BEGIN
  IF @NetworkId IS NULL
  SELECT TOP 1
    t.OriginalTransactionId,t.Id TransactionId,t.SystemDate,t.SystemTime,t.SystemSettlementDate,t.TransactionType,t.TransactionReason,
    t.DeviceId,t.DeviceDate,t.DeviceSequence,t.NetworkId,t.NetworkSettlementDate1,t.NetworkSettlementDate2,t.NetworkTransactionId,t.NetworkMerchantStationId,
    t.RoutingCode,t.AuthenticationNumber,t.AmountRequest,t.AmountAuthenticate,t.AmountSettlement,t.AmountSettlementDestination,
    t.AmountSurchargeWaived+t.AmountSurcharge,t.AmountSurchargeWaived,t.AmountSurcharge,t.SurchargeWaiveAuthorityId,
    t.CurrencyRequest,t.CurrencySource,t.CurrencyDestination,t.CurrencyDeviceRate,t.CurrencyNetworkRate,
    t.ResponseCodeInternal,t.ResponseCodeExternal,t.ResponseSubCodeExternal,t.CustomerMediaType,t.CustomerMediaEntryMode,
    t.CustomerMediaDataPart1,t.CustomerMediaDataPart2,t.CustomerMediaDataHash,t.CustomerMediaDataEncrypted,
    t.ReferenceNumber,t.ServiceFee,t.Title31Posted,t.ACHEntryClass,t.ACHECheckAck,t.CreatedUserId,
    t.PayoutCash,t.PayoutDeposit,t.PayoutChips,t.PayoutMarker,t.PayoutOther,t.PayoutStatus,
    trx.ImageData,trx.ExtendedColumn,
    c.Id CustomerId,c.FirstName,c.LastName,c.MiddleInitial,c.Suffix,c.Birthday,c.Gender,c.SSN,c.CompanyName,
    c.IdNumber,c.IdState,c.IdExpiryDate,c.IdEntryMode,c.IdEntryCode,c.CreationDate,c.AddressId,
    d.TerminalName
  FROM dbo.tbl_trn_Transaction t
  LEFT JOIN dbo.tbl_trn_TransactionreExtendedColumn trx ON t.Id=trx.TranId
  LEFT JOIN dbo.tbl_Customer c ON t.CustomerId=c.Id 
  LEFT JOIN dbo.tbl_Device d ON t.DeviceId=d.Id
  WHERE t.NetworkTransactionId=@NetworkTransactionId AND t.TransactionType<100 AND t.PayoutStatus=3
  ELSE
  SELECT TOP 1
    t.OriginalTransactionId,t.Id TransactionId,t.SystemDate,t.SystemTime,t.SystemSettlementDate,t.TransactionType,t.TransactionReason,
    t.DeviceId,t.DeviceDate,t.DeviceSequence,t.NetworkId,t.NetworkSettlementDate1,t.NetworkSettlementDate2,t.NetworkTransactionId,t.NetworkMerchantStationId,
    t.RoutingCode,t.AuthenticationNumber,t.AmountRequest,t.AmountAuthenticate,t.AmountSettlement,t.AmountSettlementDestination,
    t.AmountSurchargeWaived+t.AmountSurcharge,t.AmountSurchargeWaived,t.AmountSurcharge,t.SurchargeWaiveAuthorityId,
    t.CurrencyRequest,t.CurrencySource,t.CurrencyDestination,t.CurrencyDeviceRate,t.CurrencyNetworkRate,
    t.ResponseCodeInternal,t.ResponseCodeExternal,t.ResponseSubCodeExternal,t.CustomerMediaType,t.CustomerMediaEntryMode,
    t.CustomerMediaDataPart1,t.CustomerMediaDataPart2,t.CustomerMediaDataHash,t.CustomerMediaDataEncrypted,
    t.ReferenceNumber,t.ServiceFee,t.Title31Posted,t.ACHEntryClass,t.ACHECheckAck,t.CreatedUserId,
    t.PayoutCash,t.PayoutDeposit,t.PayoutChips,t.PayoutMarker,t.PayoutOther,t.PayoutStatus,
    trx.ImageData,trx.ExtendedColumn,
    c.Id CustomerId,c.FirstName,c.LastName,c.MiddleInitial,c.Suffix,c.Birthday,c.Gender,c.SSN,c.CompanyName,
    c.IdNumber,c.IdState,c.IdExpiryDate,c.IdEntryMode,c.IdEntryCode,c.CreationDate,c.AddressId,
    d.TerminalName
  FROM dbo.tbl_trn_Transaction t
  LEFT JOIN dbo.tbl_trn_TransactionreExtendedColumn trx ON t.Id=trx.TranId
  LEFT JOIN dbo.tbl_Customer c ON t.CustomerId=c.Id 
  LEFT JOIN dbo.tbl_Device d ON t.DeviceId=d.Id
  WHERE t.NetworkId=@NetworkId AND t.NetworkTransactionId=@NetworkTransactionId AND t.TransactionType<100 AND t.PayoutStatus=3
END
GO
GRANT EXECUTE ON  [dbo].[usp_trn_GetTransactionByNetworkTransactionId] TO [SAV4Role]
GRANT EXECUTE ON  [dbo].[usp_trn_GetTransactionByNetworkTransactionId] TO [WebV4Role]
GO
