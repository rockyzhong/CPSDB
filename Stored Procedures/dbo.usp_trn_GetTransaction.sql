SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_trn_GetTransaction]
  @TransactionId           bigint
 ,@TransactionDate         datetime
AS
BEGIN
  SELECT 
    t.OriginalTransactionId,t.Id TransactionId,t.SystemDate,t.SystemTime,t.SystemSettlementDate,t.TransactionType,t.TransactionFlags,t.TransactionReason,
    t.DeviceId,t.DeviceDate,t.DeviceSequence,t.NetworkId,t.NetworkSettlementDate1,t.NetworkSettlementDate2,t.NetworkTransactionId,t.NetworkMerchantStationId,
    t.RoutingCode,t.AuthenticationNumber,t.ApprovalCode,t.AmountRequest,t.AmountAuthenticate,t.AmountSettlement,t.AmountSettlementDestination,
    t.AmountSurchargeRequest,t.AmountSurchargeWaived+t.AmountSurcharge,t.AmountSurchargeWaived,t.AmountSurcharge,t.SurchargeWaiveAuthorityId,t.ServiceFee,
    t.CurrencyRequest,t.CurrencySource,t.CurrencyDestination,t.CurrencyDeviceRate,t.CurrencyNetworkRate,t.IssuerNetworkId,
    t.ResponseCodeInternal,t.ResponseCodeExternal,t.ResponseSubCodeExternal,t.CustomerMediaType,t.CustomerMediaEntryMode,
    t.CustomerMediaDataPart1,t.CustomerMediaDataPart2,t.HostTerminalID, t.HostMerchantID,
    CASE 
		WHEN t.CustomerMediaType IN (SELECT value FROM dbo.tbl_TypeValue WHERE TypeId=45) THEN RTRIM(t.BINRange)+'XXXXXX'+t.PAN
		WHEN t.CustomerMediaType IN (SELECT value FROM dbo.tbl_TypeValue WHERE TypeId=59) THEN REPLICATE('X',len(t.CustomerMediaDataPart2)-4)+RIGHT(t.CustomerMediaDataPart2,4)
		ELSE ''
	END 
	AS CustomerMaskedAccountNumber,tv.Description as CustomerMediaTypeName, tv.Name as CustomerMediaShortName,
    t.CustomerMediaDataHash,t.CustomerMediaDataEncrypted,
    t.ReferenceNumber,t.ServiceFee,t.Title31Posted,t.ACHEntryClass,t.ACHECheckAck,t.SourceDeviceId,t.CreatedUserId,
    t.PayoutCash,t.PayoutDeposit,t.PayoutChips,t.PayoutMarker,t.PayoutOther,t.PayoutStatus,
    trx.ImageData,trx.ExtendedColumn,
    c.Id CustomerId,c.FirstName,c.LastName,c.MiddleInitial,c.Suffix,c.Birthday,c.Gender,c.SSN,c.CompanyName,
    c.IdNumber,c.IdState,c.IdExpiryDate,c.IdEntryMode,c.IdEntryCode,c.CreationDate,c.AddressId,
    d.TerminalName
  FROM dbo.tbl_trn_Transaction t
  LEFT JOIN dbo.tbl_trn_TransactionreExtendedColumn trx ON t.Id=trx.TranId
  LEFT JOIN dbo.tbl_Customer c ON t.CustomerId=c.Id 
  LEFT JOIN dbo.tbl_Device d ON t.DeviceId=d.Id
  LEFT JOIN dbo.tbl_TypeValue tv ON tv.Value = t.CustomerMediaType and tv.TypeId in (45,59)
  WHERE t.Id=@TransactionId
END
GO
GRANT EXECUTE ON  [dbo].[usp_trn_GetTransaction] TO [SAV4Role]
GRANT EXECUTE ON  [dbo].[usp_trn_GetTransaction] TO [WebV4Role]
GO
