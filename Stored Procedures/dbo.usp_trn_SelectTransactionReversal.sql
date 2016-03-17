SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_trn_SelectTransactionReversal]
@BeginDate      datetime,
@SmartAcquireId bigint
AS
BEGIN
  SET NOCOUNT ON
  
  --OPEN SYMMETRIC KEY sk_EncryptionKey DECRYPTION BY CERTIFICATE ec_EncryptionCert 
  OPEN SYMMETRIC KEY SymKey_SPS_20150825 DECRYPTION BY ASYMMETRIC KEY AsymKey_SPS_20150825

  SELECT r.Id TransactionReversalId,r.SystemDate,r.TransactionType,r.TransactionFlags,r.TransactionReason,r.DeviceId,r.DeviceDate,r.DeviceSequence,
         r.NetworkId,r.NetworkSequence,r.NetworkSettlementDate1,r.NetworkSettlementDate2,r.NetworkData,r.AmountRequest,r.AmountAuthenticate,
         r.AmountDispense,r.AmountSurcharge,r.AmountDispenseDestination,r.AmountSurchargeDestination,r.AmountSurchargeWaived,r.AmountCashBack,
         r.AmountConvinience,r.SurchargeWaiveAuthorityId,r.CurrencyRequest,r.CurrencySource,r.CurrencyDestination,r.CurrencyDeviceRate,
         r.CurrencyNetworkRate,CONVERT(nvarchar(max),DECRYPTBYKEY(r.CustomerMediaDataEncrypted)) CustomerMediaData,r.CustomerMediaExpiryDate,
         r.AuthenticationNumber,r.ReferenceNumber,r.ApprovalCode,r.BatchId,r.BINGroup,r.SourceAccountType,r.DestinationAccountType,
         r.IssuerNetworkId,r.SourceDeviceName,r.CreatedUserId,r.SmartAcquierId
  FROM dbo.tbl_trn_TransactionReversal r
  JOIN dbo.tbl_trn_Transaction t 
    ON t.CustomerMediaDataHash=r.CustomerMediaDataHash AND t.DeviceId=r.DeviceId AND t.DeviceSequence=r.DeviceSequence AND t.TransactionType<100 AND t.ReversalType=0
  WHERE r.SystemDate>@BeginDate AND (@SmartAcquireId=0 OR r.SmartAcquierId=@SmartAcquireId) AND r.ProcessedDate<=DATEADD(mi,-30,GETUTCDATE())
  
  UPDATE dbo.tbl_trn_TransactionReversal SET ProcessedDate=GETUTCDATE()
  WHERE SystemDate>@BeginDate AND (@SmartAcquireId=0 OR SmartAcquierId=@SmartAcquireId) AND ProcessedDate<=DATEADD(mi,-30,GETUTCDATE())
END
GO
