SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE PROCEDURE [dbo].[usp_rec_Reconciliation] 
AS
BEGIN
  DECLARE @i bigint,@BeginDate datetime,@EndDate datetime,@ReconciliationDays bigint
  DECLARE @ReconciliationStatus bigint,@UnreconciledStatus bigint,@NetworkTransactionId bigint,@TerminalName nvarchar(50),@DeviceId0 bigint,@DeviceId1 bigint,@DeviceId3 bigint,@DeviceDate datetime,@DeviceSequence bigint,@PAN nvarchar 
(4),@BINRange nvarchar(6)
  DECLARE @OriginalTransactionId bigint,@TransactionType bigint,@Id0 bigint,@Id1 bigint,@Id2 bigint,@Id3 bigint,@Id4 bigint
  DECLARE @IssuerNetworkId0 nvarchar(50),@IssuerNetworkId1 nvarchar(50),@IssuerNetworkId3 nvarchar(50),@AmountInterchange0 money,@AmountInterchange1 money,@AmountInterchange3 money,@ProcessingFee0 money,@ProcessingFee1  
money,@ProcessingFee3 money
  DECLARE @AmountSettlement0 money,@AmountSettlement1 money,@AmountSettlement2 money,@AmountSettlement3 money,@AmountSettlement4 money,@ResponseCodeInternal1 bigint,@ResponseCodeInternal2 bigint,@AmountComplated1  
money,@AmountComplated2 money
      
  SELECT @ReconciliationDays=CONVERT(bigint,Value) FROM dbo.tbl_Parameter WHERE Name='ReconciliationDays'
  IF @ReconciliationDays IS NULL  SET @ReconciliationDays=7
  SET @BeginDate =DATEADD(dd,-1*@ReconciliationDays,GETUTCDATE())
  SET @EndDate   =GETUTCDATE()

  SET @i=1
  BEGIN TRANSACTION
  DECLARE TempCursor CURSOR LOCAL FOR SELECT Id,NetworkTransactionId,TerminalName,DeviceDate,DeviceSequence,AmountSettlement,AmountInterchange,ResponseCodeInternal,dbo.udf_GetIssuerNetworkId 
(IssuerNetworkId,IssuerInstitutionId),ProcessingFee,PAN,BINRange FROM dbo.tbl_trn_TransactionReconciliation WHERE SystemDate>=@BeginDate AND SystemDate<@EndDate AND ReconciliationStatus IN (1,2) ORDER BY SystemDate
  OPEN TempCursor
  FETCH NEXT FROM TempCursor INTO @Id1,@NetworkTransactionId,@TerminalName,@DeviceDate,@DeviceSequence,@AmountSettlement1,@AmountInterchange1,@ResponseCodeInternal1,@IssuerNetworkId1,@ProcessingFee1,@PAN,@BINRange
  WHILE @@Fetch_Status=0
  BEGIN
    --Remove leading zeroes from @DeviceSequence
    SET @DeviceSequence=CONVERT(bigint,@DeviceSequence)
      
    --Get DeviceId
    SET @DeviceId1=NULL
    IF @TerminalName IS NOT NULL
      SELECT @DeviceId1=Id FROM dbo.tbl_Device WHERE TerminalName=@TerminalName
        
    SET @Id2=0  SET @AmountSettlement2=0  SET @ResponseCodeInternal2=NULL
    SET @Id3=0  SET @AmountSettlement3=0  SET @AmountInterchange3=0        SET @IssuerNetworkId3=@IssuerNetworkId1  SET @ProcessingFee3=0
    SET @Id4=0  SET @AmountSettlement4=0  
      
    IF @DeviceId1 IS NOT NULL AND @DeviceDate IS NOT NULL AND @DeviceSequence IS NOT NULL  --Pulse,Star,Moneries
      SELECT TOP 1 @TransactionType=TransactionType,@OriginalTransactionId=OriginalTransactionId,@Id2=Id,@AmountSettlement2=AmountSettlementDestination,@ResponseCodeInternal2=ResponseCodeInternal FROM dbo.tbl_trn_Transaction WHERE  
DeviceId=@DeviceId1 AND DeviceSequence=@DeviceSequence AND DeviceDate=@DeviceDate ORDER BY Id
    ELSE IF @NetworkTransactionId IS NOT NULL                                              --Certegy
      SELECT TOP 1 @TransactionType=TransactionType,@OriginalTransactionId=OriginalTransactionId,@Id2=Id,@AmountSettlement2=AmountSettlementDestination,@ResponseCodeInternal2=ResponseCodeInternal FROM dbo.tbl_trn_Transaction WHERE  
NetworkTransactionId=@NetworkTransactionId ORDER BY Id
    ELSE IF @PAN IS NOT NULL AND @BINRange IS NOT NULL AND @DeviceDate IS NOT NULL         --RBS
      SELECT TOP 1 @TransactionType=TransactionType,@OriginalTransactionId=OriginalTransactionId,@Id2=Id,@AmountSettlement2=AmountSettlementDestination,@ResponseCodeInternal2=ResponseCodeInternal FROM dbo.tbl_trn_Transaction WHERE  
PAN=@PAN AND BINRange=@BINRange AND AmountSettlement=@AmountSettlement1 AND CONVERT(nvarchar,DeviceDate,112)=CONVERT(nvarchar,@DeviceDate,112) ORDER BY Id
    
    IF @Id2>0  
    BEGIN
      IF @TransactionType>100 
      BEGIN
        SET @Id2=@OriginalTransactionId  
        SELECT @TransactionType=TransactionType,@AmountSettlement2=AmountSettlementDestination,@ResponseCodeInternal2=ResponseCodeInternal FROM dbo.tbl_trn_Transaction WHERE Id=@Id2
      END
      SELECT @Id4=Id,@AmountSettlement4=AmountSettlementDestination FROM dbo.tbl_trn_Transaction WHERE OriginalTransactionId=@Id2

      SELECT @Id3=Id,@DeviceId3=DeviceId,@IssuerNetworkId3=dbo.udf_GetIssuerNetworkId(IssuerNetworkId,IssuerInstitutionId),@AmountSettlement3=AmountSettlement,@AmountInterchange3=AmountInterchange,@ProcessingFee3=ProcessingFee FROM  
dbo.tbl_trn_TransactionReconciliation WHERE TransactionId=@Id2 AND Id<@Id1
      IF @Id3>0
      BEGIN
        SET @Id0=@Id1  SET @DeviceId0=@DeviceId1  SET @IssuerNetworkId0=@IssuerNetworkId1  SET @AmountSettlement0=@AmountSettlement1  SET @AmountInterchange0=@AmountInterchange1  SET @ProcessingFee0=@ProcessingFee1
        SET @Id1=@Id3  SET @DeviceId1=@DeviceId3  SET @IssuerNetworkId1=@IssuerNetworkId3  SET @AmountSettlement1=@AmountSettlement3  SET @AmountInterchange1=@AmountInterchange3  SET @ProcessingFee1=@ProcessingFee3  
        SET @Id3=@Id0  SET @DeviceId3=@DeviceId0  SET @IssuerNetworkId3=@IssuerNetworkId0  SET @AmountSettlement3=@AmountSettlement0  SET @AmountInterchange3=@AmountInterchange0  SET @ProcessingFee3=@ProcessingFee0
      END        
    END

    SET @ReconciliationStatus=2
    SET @UnreconciledStatus=NULL
    IF @Id1>0 AND @ResponseCodeInternal1=0 AND @Id2=0
      --Approved transaction in Gateway with no matching transaction in SmartQcquirer
      SET @UnreconciledStatus=1
    ELSE IF @Id2>0 AND @ResponseCodeInternal2=0 AND @Id1=0
      --Approved transaction in SmartQcquirer with no matching transaction in Gateway
      SET @UnreconciledStatus=2
    ELSE IF @Id1>0 AND @Id2>0 AND @ResponseCodeInternal1=0 AND @ResponseCodeInternal2<>0 
      --Approved transaction in Gateway and declined transaction in SmartQcquirer
      SET @UnreconciledStatus=3
    ELSE IF @Id1>0 AND @Id2>0 AND @ResponseCodeInternal1<>0 AND @ResponseCodeInternal2=0
      --Declined transaction in Gateway and approved transaction in SmartQcquirer
      SET @UnreconciledStatus=4
    ELSE IF @Id1>0 AND @Id2>0 AND @ResponseCodeInternal1=0 AND @ResponseCodeInternal2=0
    BEGIN
      --Approved transaction in both Gateway and SmartQcquirer
      SET @AmountComplated1=ABS(ABS(@AmountSettlement1)-ABS(@AmountSettlement3))
      SET @AmountComplated2=ABS(ABS(@AmountSettlement2)-ABS(@AmountSettlement4))
      IF @AmountComplated1<>@AmountComplated2                       
        --Completed amount is different
        SET @UnreconciledStatus=5
      ELSE                                                          
        --Completed amount is same
        SET @ReconciliationStatus=3     
    END
    ELSE 
      --Others are reconciled
      SET @ReconciliationStatus=3 
          
    IF @Id1>0  UPDATE dbo.tbl_trn_TransactionReconciliation SET TransactionId=@Id2,DeviceId=@DeviceId1,ReconciliationStatus=@ReconciliationStatus,UnreconciledStatus=@UnreconciledStatus WHERE Id=@Id1
    IF @Id3>0  UPDATE dbo.tbl_trn_TransactionReconciliation SET TransactionId=@Id4,DeviceId=@DeviceId3,ReconciliationStatus=@ReconciliationStatus,UnreconciledStatus=@UnreconciledStatus WHERE Id=@Id3
        
    IF @Id2>0  
    Begin
    UPDATE dbo.tbl_trn_Transaction SET IssuerNetworkId=CASE WHEN BINRange IN (SELECT BINRange FROM dbo.tbl_BINRangeNetwork WHERE NetworkCode='BMO') THEN N'BMO' ELSE @IssuerNetworkId1 END,
    AmountSettlementReconciliation=@AmountSettlement1,ProcessingFee=@ProcessingFee1 WHERE Id=@Id2 
    UPDATE tbl_trn_Transactionreconandtrace SET ReconciliationStatus=@ReconciliationStatus,UnreconciledStatus=@UnreconciledStatus WHERE tranId=@Id2
    UPDATE tbl_trn_TransactionAmountInter SET AmountInterchange=@AmountInterchange1 WHERE Tranid=@Id2
    End
    IF @Id4>0  
    Begin
    UPDATE dbo.tbl_trn_Transaction SET IssuerNetworkId=CASE WHEN BINRange IN (SELECT BINRange FROM dbo.tbl_BINRangeNetwork WHERE NetworkCode='BMO') THEN N'BMO' ELSE @IssuerNetworkId1 END,
    AmountSettlementReconciliation=@AmountSettlement3,ProcessingFee=@ProcessingFee3 WHERE Id=@Id4
    UPDATE tbl_trn_Transactionreconandtrace SET ReconciliationStatus=@ReconciliationStatus,UnreconciledStatus=@UnreconciledStatus WHERE tranId=@Id4
    UPDATE tbl_trn_TransactionAmountInter SET AmountInterchange=@AmountInterchange3 WHERE Tranid=@Id4
    End
    FETCH NEXT FROM TempCursor INTO @Id1,@NetworkTransactionId,@TerminalName,@DeviceDate,@DeviceSequence,@AmountSettlement1,@AmountInterchange1,@ResponseCodeInternal1,@IssuerNetworkId1,@ProcessingFee1,@PAN,@BINRange
  
    SET @i=@i+1
    IF @i>100
    BEGIN
      COMMIT TRANSACTION
      BEGIN  TRANSACTION
      SET @i=1
    END
  END
  CLOSE TempCursor
  DEALLOCATE TempCursor
  COMMIT TRANSACTION
END

GO
