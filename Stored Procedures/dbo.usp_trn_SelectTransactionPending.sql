SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[usp_trn_SelectTransactionPending]
@BeginDate      datetime,
@Networkid1     bigint,
@Networkid2     bigint,
@Numbers        bigint,
@ProcessMins    bigint,
@Minutes        bigint = 120,
@FlagChoose BIGINT=1


AS
BEGIN
  SET NOCOUNT ON
  DECLARE @DeviceExValue TABLE (DeviceId BIGINT,ExValue NVARCHAR(200))
  DECLARE @TransTemp TABLE(Transid BIGINT,DeviceMin FLOAT)
  
  --OPEN SYMMETRIC KEY sk_EncryptionKey DECRYPTION BY CERTIFICATE ec_EncryptionCert 
  OPEN SYMMETRIC KEY SymKey_SPS_20150825 DECRYPTION BY ASYMMETRIC KEY AsymKey_SPS_20150825
  INSERT INTO @DeviceExValue
  SELECT td.id,ie.ExtendedColumnValue FROM dbo.tbl_IsoExtendedValue ie LEFT JOIN tbl_device td ON ie.IsoId=td.IsoId WHERE ie.ExtendedColumnType=34
  

  IF @FlagChoose=1  -- 1: returns pending credit, 2: returns pending  debit without pinless, 3: return pending credit and debit
  BEGIN
  
  INSERT INTO @transtemp
  SELECT top (@Numbers) t.Id TransactionId,ISNULL(CASE WHEN  CONVERT(FLOAT,dxv.ExValue)*60<60 THEN 60 WHEN CONVERT(FLOAT,dxv.ExValue)*60>720 THEN 720 ELSE CONVERT(FLOAT,dxv.ExValue)*60 END,@Minutes) AS DeviceMin
  FROM dbo.tbl_trn_Transaction t WITH (NOLOCK)
  LEFT JOIN @DeviceExValue dxv ON t.DeviceId=dxv.DeviceId
  WHERE PayoutStatus IN (1,3) AND ((ResponseCodeInternal=0 AND TransactionType=8) OR (ResponseCodeInternal=37 AND TransactionType IN (7,8) AND ApprovalCode IS NOT NULL AND ApprovalCode != ''))
    AND SystemDate>@BeginDate AND SystemDate<GETUTCDATE()
    AND (NetworkId=@Networkid1 OR NetworkId=@Networkid2)
    AND ProcessedDate<=DATEADD(mi,@ProcessMins,GETUTCDATE()) AND t.TransactionFlags & 0x00080000 <> 0 ORDER BY t.id DESC
  
  SELECT t.Id TransactionId,TransactionType,TransactionFlags,DeviceId,TerminalName,DeviceSequence,CONVERT(nvarchar(max),DECRYPTBYKEY(CustomerMediaDataEncrypted)) CustomerMediaData
  FROM dbo.tbl_trn_Transaction t WITH (NOLOCK)
  LEFT JOIN dbo.tbl_Device  d  WITH (NOLOCK) ON d.Id=t.DeviceId
  WHERE t.id IN (SELECT transid FROM @transtemp tt JOIN dbo.tbl_trn_Transaction t WITH (NOLOCK) ON tt.Transid=t.Id AND t.SystemDate<DATEADD(mi,-tt.DeviceMin,GETUTCDATE()))

  UPDATE dbo.tbl_trn_Transaction SET ProcessedDate=GETUTCDATE()
  WHERE id IN (SELECT transid FROM @transtemp tt JOIN dbo.tbl_trn_Transaction t WITH (NOLOCK) ON tt.Transid=t.Id AND t.SystemDate<DATEADD(mi,-tt.DeviceMin,GETUTCDATE()))

 

  END

  IF @FlagChoose=2 
  BEGIN
 
  INSERT INTO @transtemp
  SELECT top (@Numbers) t.Id TransactionId,ISNULL(CASE WHEN  CONVERT(FLOAT,dxv.ExValue)*60<60 THEN 60 WHEN CONVERT(FLOAT,dxv.ExValue)*60>720 THEN 720 ELSE CONVERT(FLOAT,dxv.ExValue)*60 END,@Minutes) AS DeviceMin
  FROM dbo.tbl_trn_Transaction t WITH (NOLOCK)
  LEFT JOIN @DeviceExValue dxv ON t.DeviceId=dxv.DeviceId
  WHERE PayoutStatus IN (1,3) AND ((ResponseCodeInternal=0 AND TransactionType=8) OR (ResponseCodeInternal=37 AND TransactionType IN (7,8) AND ApprovalCode IS NOT NULL AND ApprovalCode != ''))
    AND SystemDate>@BeginDate AND SystemDate<GETUTCDATE()
    AND (NetworkId=@Networkid1 OR NetworkId=@Networkid2)
    AND ProcessedDate<=DATEADD(mi,@ProcessMins,GETUTCDATE()) AND t.TransactionFlags & 0x00080000 = 0 AND t.TransactionFlags & 0x00000002 = 0 ORDER BY t.id desc
   
  SELECT t.Id TransactionId,TransactionType,TransactionFlags,DeviceId,TerminalName,DeviceSequence,CONVERT(nvarchar(max),DECRYPTBYKEY(CustomerMediaDataEncrypted)) CustomerMediaData
  FROM dbo.tbl_trn_Transaction t WITH (NOLOCK)
  LEFT JOIN dbo.tbl_Device  d  WITH (NOLOCK) ON d.Id=t.DeviceId
  WHERE t.id IN (SELECT transid FROM @transtemp tt JOIN dbo.tbl_trn_Transaction t WITH (NOLOCK) ON tt.Transid=t.Id AND t.SystemDate<DATEADD(mi,-tt.DeviceMin,GETUTCDATE()))

  UPDATE dbo.tbl_trn_Transaction SET ProcessedDate=GETUTCDATE()
  WHERE id IN (SELECT transid FROM @transtemp tt JOIN dbo.tbl_trn_Transaction t WITH (NOLOCK) ON tt.Transid=t.Id AND t.SystemDate<DATEADD(mi,-tt.DeviceMin,GETUTCDATE()))

  END

  IF @FlagChoose=3 
  BEGIN
    
  INSERT INTO @transtemp
  SELECT top (@Numbers) t.Id TransactionId,ISNULL(CASE WHEN  CONVERT(FLOAT,dxv.ExValue)*60<60 THEN 60 WHEN CONVERT(FLOAT,dxv.ExValue)*60>720 THEN 720 ELSE CONVERT(FLOAT,dxv.ExValue)*60 END,@Minutes) AS DeviceMin
  FROM dbo.tbl_trn_Transaction t WITH (NOLOCK)
  LEFT JOIN @DeviceExValue dxv ON t.DeviceId=dxv.DeviceId
  WHERE PayoutStatus IN (1,3) AND ((ResponseCodeInternal=0 AND TransactionType=8) OR (ResponseCodeInternal=37 AND TransactionType IN (7,8) AND ApprovalCode IS NOT NULL AND ApprovalCode != ''))
    AND SystemDate>@BeginDate AND SystemDate<GETUTCDATE()
    AND (NetworkId=@Networkid1 OR NetworkId=@Networkid2)
    AND ProcessedDate<=DATEADD(mi,@ProcessMins,GETUTCDATE()) AND (t.TransactionFlags & 0x00080000 <> 0 OR (t.TransactionFlags & 0x00080000 = 0 AND t.TransactionFlags & 0x00000002 = 0)) ORDER BY t.id desc

  SELECT t.Id TransactionId,TransactionType,TransactionFlags,DeviceId,TerminalName,DeviceSequence,CONVERT(nvarchar(max),DECRYPTBYKEY(CustomerMediaDataEncrypted)) CustomerMediaData
  FROM dbo.tbl_trn_Transaction t WITH (NOLOCK)
  LEFT JOIN dbo.tbl_Device  d  WITH (NOLOCK) ON d.Id=t.DeviceId
  WHERE t.id IN (SELECT transid FROM @transtemp tt JOIN dbo.tbl_trn_Transaction t WITH (NOLOCK) ON tt.Transid=t.Id AND t.SystemDate<DATEADD(mi,-tt.DeviceMin,GETUTCDATE()))

  UPDATE dbo.tbl_trn_Transaction SET ProcessedDate=GETUTCDATE()
  WHERE id IN (SELECT transid FROM @transtemp tt JOIN dbo.tbl_trn_Transaction t WITH (NOLOCK) ON tt.Transid=t.Id AND t.SystemDate<DATEADD(mi,-tt.DeviceMin,GETUTCDATE()))

  END
--------------------------------------------------------------------------------------------------------------
IF not exists (select Id from tbl_trn_Transaction  where  TransactionFlags& 0x00080000<>0 and SystemDate<dateadd(HH,-2,GETUTCDATE())and TransactionType=8 
            and PayoutStatus = 1 and Id in (select OriginalTransactionId from tbl_trn_Transaction)) 
 Begin
  insert into tbl_trn_Transaction 
  ( OriginalTransactionId,
	SystemDate,
	SystemTime,
	SystemSettlementDate,
	TransactionType,
	TransactionFlags,
	TransactionReason,
	TransactionState,
	DeviceId,
	DeviceDate,
	DeviceSequence,
	NetworkId,
	NetworkSequence,
	NetworkSettlementDate1,
	NetworkSettlementDate2,
	NetworkTransactionId,
	NetworkMerchantStationId,
	RoutingCode,
	AmountRequest,
	AmountAuthenticate,
	AmountSettlement,
	AmountSettlementDestination,
	AmountSettlementReconciliation,
	AmountSurchargeRequest,
	AmountSurchargeFixed,
	AmountSurchargeWaived,
	AmountSurcharge,
	AmountCommission,
	--AmountInterchange,
	--AmountInterchangePaid,
	AmountCashBack,
	AmountConvinience,
	SurchargeWaiveAuthorityId,
	CurrencyRequest,
	CurrencySource,
	CurrencyDestination,
	CurrencyDeviceRate,
	CurrencyNetworkRate,
	ResponseTypeId,
	ResponseCodeInternal,
	ResponseCodeExternal,
	ResponseSubCodeExternal,
	CustomerId,
	CustomerMediaType,
	CustomerMediaEntryMode,
	CustomerMediaDataPart1,
	CustomerMediaDataPart2,
	CustomerMediaDataHash,
	CustomerMediaDataEncrypted,
	CustomerMediaExpiryDate,
	AuthenticationNumber,
	ReferenceNumber,
	ApprovalCode,
	BatchId,
	PAN,
	BINRange,
	BINGroup,
	SourceAccountType,
	DestinationAccountType,
	SourcePCode,
	IssuerNetworkId,
	ProcessingFee,
	ServiceFee,
	ReversalType,
	Title31Posted,
	ACHEntryClass,
	ACHECheckAck,
	SourceDeviceId,
	NetAddr,
	NetAPI,
	--ReconciliationStatus,
	--UnreconciledStatus,
	--ReconciliationComment,
	PayoutCash,
	PayoutDeposit,
	PayoutChips,
	PayoutMarker,
	PayoutOther,
	PayoutStatus,
	--ImageData,
	--TraceInitiator,
	--TraceOpenedDate,
	--TraceOpenedUserId,
	--TraceReopenedDate,
	--TraceReopenedUserId,
	--TraceDueDate,
	--TraceClosedDate,
	--TraceClosedUserId,
	--TraceStatus,
	--TraceDispensedStatus,
	--TraceBankNo,
	--TraceBankClaimNo,
	--TraceCreditDate,
	--TraceCreditAmount,
	--TraceTranmissionType,
	--TraceMailAddress,
	--TraceLetterComment,
	--TraceInternalComment,
	CreatedUserId,
	SmartAcquierId,
	ProcessedDate
	--ExtendedColumn
  )
  select Id,GETUTCDATE(),SystemTime,SystemSettlementDate,108,TransactionFlags,2,TransactionState,
    DeviceId,
	DeviceDate,
	DeviceSequence,
	NetworkId,
	NetworkSequence,
	NetworkSettlementDate1,
	NetworkSettlementDate2,
	NetworkTransactionId,
	NetworkMerchantStationId,
	RoutingCode,
	AmountRequest,
	0,AmountSettlement,
	AmountSettlementDestination,
	AmountSettlementReconciliation,
	AmountSurchargeRequest,
	AmountSurchargeFixed,
	AmountSurchargeWaived,
	AmountSurcharge,
	AmountCommission,
	--AmountInterchange,
	--AmountInterchangePaid,
	AmountCashBack,
	AmountConvinience,
	SurchargeWaiveAuthorityId,
	CurrencyRequest,
	CurrencySource,
	CurrencyDestination,
	CurrencyDeviceRate,
	CurrencyNetworkRate,
	ResponseTypeId,
	ResponseCodeInternal,
	ResponseCodeExternal,
	ResponseSubCodeExternal,
	CustomerId,
	CustomerMediaType,
	CustomerMediaEntryMode,
	CustomerMediaDataPart1,
	CustomerMediaDataPart2,
	CustomerMediaDataHash,
	CustomerMediaDataEncrypted,
	CustomerMediaExpiryDate,
	AuthenticationNumber,
	ReferenceNumber,
	ApprovalCode,
	BatchId,
	PAN,
	BINRange,
	BINGroup,
	SourceAccountType,
	DestinationAccountType,
	SourcePCode,
	IssuerNetworkId,
	ProcessingFee,
	ServiceFee,
	ReversalType,
	Title31Posted,
	ACHEntryClass,
	ACHECheckAck,
	SourceDeviceId,-1,-1,
	--ReconciliationStatus,
	--UnreconciledStatus,
	--ReconciliationComment,
	PayoutCash,
	PayoutDeposit,
	PayoutChips,
	PayoutMarker,
	PayoutOther,
	2,
	--ImageData,
	--TraceInitiator,
	--TraceOpenedDate,
	--TraceOpenedUserId,
	--TraceReopenedDate,
	--TraceReopenedUserId,
	--TraceDueDate,
	--TraceClosedDate,
	--TraceClosedUserId,
	--TraceStatus,
	--TraceDispensedStatus,
	--TraceBankNo,
	--TraceBankClaimNo,
	--TraceCreditDate,
	--TraceCreditAmount,
	--TraceTranmissionType,
	--TraceMailAddress,
	--TraceLetterComment,
	--TraceInternalComment,
	CreatedUserId,
	SmartAcquierId,
	ProcessedDate
	--ExtendedColumn 
	FROM tbl_trn_Transaction 
	where TransactionFlags & 0x00080000<>0 and SystemDate<dateadd(HH,-2,GETUTCDATE())and TransactionType=8 
            and PayoutStatus = 1
    
    
    
    Update tbl_trn_Transaction set PayoutStatus=2 where TransactionFlags & 0x00080000<>0 and SystemDate<dateadd(HH,-2,GETUTCDATE())and TransactionType=8 
            and PayoutStatus = 1
           
  END
  
END
GO
