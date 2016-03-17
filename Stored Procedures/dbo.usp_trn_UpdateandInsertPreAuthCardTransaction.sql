SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
		--------------------- added trans between update and insert CCCA ---------------
CREATE PROCEDURE [dbo].[usp_trn_UpdateandInsertPreAuthCardTransaction]
 @OrigTransId                BIGINT
,@DeviceId                bigint
,@DeviceSequence          bigint        
,@CustomerMediaDataHash   varbinary(512)
,@ISystemTime             varchar (10)     -- Java time import 
,@ISystemDate             varchar (10)     -- Java date import
,@DeviceDate              DATETIME
,@SurchageWaivedUserId    bigint
,@CustomerId              bigint
,@CustomerMediaType       bigint
,@CustomerMediaEntryMode  nvarchar (1)
,@AmountRequest           bigint
,@CreatedUserId           bigint
AS
-- Revision 1.1.0 2015.12.05 by Adam Glover
--  Populate Settlement, Surcharge and Commission Fields
BEGIN
  SET NOCOUNT ON

  -- Set payout status to finish when transaction is card transaction and is approved
  DECLARE @PayoutStatus BIGINT,@CombineTime DATETIME, @TransId BIGINT, @AmountInterchangePaid BIGINT,@ExtendedColumn NVARCHAR(200)
  SET @CombineTime= CONVERT(Datetime, @ISystemDate+' '+@ISystemTime, 120)
  SET @PayoutStatus=5


  --Calculate commission amount
  DECLARE @TransactionFlags bigint
  DECLARE @AmountDispense bigint
  DECLARE @AmountSurcharge bigint
  DECLARE @AmountDispenseDestination bigint
  DECLARE @AmountSurchargeDestination bigint
  DECLARE @SourceAccountType bigint
  DECLARE @ResponseCodeInternal bigint
  DECLARE @BinRange nvarchar(10)
  DECLARE @BinGroup bigint
  DECLARE @IssuerNetworkId nvarchar(10)
  
  SELECT @TransactionFlags = ISNULL(max(TransactionFlags), 0),
    @AmountDispense = ISNULL(max(AmountRequest), 0),
    @AmountSurcharge = ISNULL(max(AmountSurchargeRequest), 0),
    @SourceAccountType = ISNULL(max(SourceAccountType), 0),
    @ResponseCodeInternal = ISNULL(max(ResponseCodeInternal), 0),
    @BinRange = ISNULL(max(BinRange), ''),
    @BinGroup = ISNULL(max(BinGroup), 0),
    @IssuerNetworkId = ISNULL(max(IssuerNetworkId), '')
  FROM dbo.tbl_trn_Transaction WITH (NOLOCK) WHERE id=@OrigTransId
  
  SET @AmountDispenseDestination = @AmountDispense
  SET @AmountSurchargeDestination = @AmountSurcharge

  DECLARE @AmountSettlement bigint,@AmountSettlementDestination bigint
  SET @AmountSettlement=@AmountDispense+@AmountSurcharge
  SET @AmountSettlementDestination=@AmountDispenseDestination+@AmountSurchargeDestination
  
  DECLARE @CommissionType bigint,@AmountSurchargeFixed bigint=0,@AmountSurchargePercentage bigint=0,@DispenseAmountPercent money = 0,@SurchargeFixedAmountPercent money = 0,@SurchargeVariableAmountPercent money = 0,@AmountCommission bigint = 0
  IF      @TransactionFlags & 0x00080000 = 0  SET @CommissionType=1   -- POS Debit
  ELSE IF @TransactionFlags & 0x00080000 > 0  SET @CommissionType=2   -- POS Credit
  IF @CommissionType IS NOT NULL
  BEGIN
    SELECT @DispenseAmountPercent=DispenseAmountPercent,@SurchargeFixedAmountPercent=SurchargeFixedAmountPercent,@SurchargeVariableAmountPercent=SurchargeVariableAmountPercent FROM dbo.tbl_DeviceCommission WHERE DeviceId=@DeviceId AND CommissionType=@CommissionType
    IF @DispenseAmountPercent<>0 OR @SurchargeFixedAmountPercent<>0 OR @SurchargeVariableAmountPercent<>0
    BEGIN
      --Get fixed surcharge amount
      DECLARE @Count1 bigint = 0,@Count2 bigint = 0,@Count3 bigint = 0,@IsoId bigint
      SELECT @IsoId=IsoId FROM dbo.tbl_Device WHERE Id=@DeviceId
      
      SELECT @Count1=COUNT(Id) FROM dbo.tbl_DeviceFeeOverride WHERE DeviceId=@DeviceId AND FeeFixed+@AmountRequest*FeePercentage/10000=@AmountSurcharge
      SELECT @Count2=COUNT(Id) FROM dbo.tbl_DeviceFee         WHERE DeviceId=@DeviceId AND FeeFixed+@AmountRequest*(FeePercentage+FeeAddedPercentage)/10000=@AmountSurcharge
      SELECT @Count3=COUNT(Id) FROM dbo.tbl_DeviceFee         WHERE IsoId=@IsoId       AND FeeFixed+@AmountRequest*(FeePercentage+FeeAddedPercentage)/10000=@AmountSurcharge
      
      IF @Count1=1 AND @Count2=0 AND @Count3=0
        SELECT @AmountSurchargeFixed=FeeFixed FROM dbo.tbl_DeviceFeeOverride WHERE DeviceId=@DeviceId AND FeeFixed+@AmountRequest*FeePercentage/10000=@AmountSurcharge
      ELSE IF @Count1=0 AND @Count2=1 AND @Count3=0
        SELECT @AmountSurchargeFixed=FeeFixed FROM dbo.tbl_DeviceFee         WHERE DeviceId=@DeviceId AND FeeFixed+@AmountRequest*(FeePercentage+FeeAddedPercentage)/10000=@AmountSurcharge
      ELSE IF @Count1=0 AND @Count2=0 AND @Count3=1
        SELECT @AmountSurchargeFixed=FeeFixed FROM dbo.tbl_DeviceFee         WHERE IsoId=@IsoId       AND FeeFixed+@AmountRequest*(FeePercentage+FeeAddedPercentage)/10000=@AmountSurcharge
      ELSE  
        EXEC dbo.usp_dev_GetDeviceFeeFixed @DeviceId,@AmountRequest,9,@TransactionFlags,@BinRange,@BinGroup,@SourceAccountType,@AmountSurchargeFixed OUTPUT,@AmountSurchargePercentage OUTPUT
    END
    
    SET @AmountCommission=@AmountDispense*@DispenseAmountPercent+@AmountSurchargeFixed*@SurchargeFixedAmountPercent+(@AmountSurcharge-@AmountSurchargeFixed)*@SurchargeVariableAmountPercent
  END
  
  -- Calculate interchange amount
  SET @AmountInterchangePaid = 0

    SELECT @AmountInterchangePaid=ISNULL(SUM(CASE WHEN @ResponseCodeInternal=0 --approved
    THEN a.AmountApproval ELSE a.AmountDeclined END),0)
    FROM dbo.tbl_DeviceToInterchangeScheme        i  
    LEFT JOIN dbo.tbl_InterchangeSchemeSignature  g1 ON g1.InterchangeSchemeId=i.InterchangeSchemeId AND g1.IssuerNetworkId=@IssuerNetworkId AND g1.TransactionType=9
    LEFT JOIN dbo.tbl_InterchangeSchemeSignature  g2 ON g2.InterchangeSchemeId=i.InterchangeSchemeId AND g2.IssuerNetworkId=N'ALL'           AND g2.TransactionType=9
    LEFT JOIN dbo.tbl_InterchangeSchemeSignature  g3 ON g3.InterchangeSchemeId=i.InterchangeSchemeId AND g3.IssuerNetworkId=@IssuerNetworkId AND g3.TransactionType=0
    LEFT JOIN dbo.tbl_InterchangeSchemeSignature  g4 ON g4.InterchangeSchemeId=i.InterchangeSchemeId AND g4.IssuerNetworkId=N'ALL'           AND g4.TransactionType=0
    JOIN dbo.tbl_InterchangeSchemeSignatureAmount a  ON a.InterchangeSchemeSignatureId=ISNULL(ISNULL(ISNULL(g1.id,g2.id),g3.Id),g4.Id)
    WHERE i.DeviceId=@DeviceId


  SELECT @AmountInterchangePaid=AmountInterchangePaid FROM tbl_trn_TransactionAmountInter WITH (NOLOCK) WHERE TranId=@OrigTransId
  --SELECT @ExtendedColumn=ExtendedColumn FROM dbo.tbl_trn_TransactionReExtendedColumn WITH (NOLOCK) WHERE TranId=@OrigTransId
  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  BEGIN TRANSACTION
  --BEGIN TRY
           UPDATE dbo.tbl_trn_Transaction SET PayoutStatus=@PayoutStatus WHERE Id=@OrigTransId 

		   INSERT INTO dbo.tbl_trn_Transaction
				  ( OriginalTransactionId ,
					SystemDate ,
					SystemTime ,
					SystemSettlementDate ,
					TransactionType ,
					TransactionFlags ,
					TransactionReason ,
					TransactionState ,
					DeviceId ,
					DeviceDate ,
					DeviceSequence ,
					NetworkId ,
					NetworkSequence ,
					NetworkSettlementDate1 ,
					NetworkSettlementDate2 ,
					NetworkTransactionId ,
					NetworkMerchantStationId ,
					RoutingCode ,
					AmountRequest ,
					AmountAuthenticate ,
					AmountSettlement ,
					AmountSettlementDestination ,
					AmountSettlementReconciliation ,
					AmountSurchargeRequest ,
					AmountSurchargeFixed ,
					AmountSurchargeWaived ,
					AmountSurcharge ,
					AmountCommission ,
					AmountCashBack ,
					AmountConvinience ,
					SurchargeWaiveAuthorityId ,
					CurrencyRequest ,
					CurrencySource ,
					CurrencyDestination ,
					CurrencyDeviceRate ,
					CurrencyNetworkRate ,
					ResponseTypeId ,
					ResponseCodeInternal ,
					ResponseCodeExternal ,
					ResponseSubCodeExternal ,
					CustomerId ,
					CustomerMediaType ,
					CustomerMediaEntryMode ,
					CustomerMediaDataPart1 ,
					CustomerMediaDataPart2 ,
					CustomerMediaDataHash ,
					CustomerMediaDataEncrypted ,
					CustomerMediaExpiryDate ,
					AuthenticationNumber ,
					ReferenceNumber ,
					ApprovalCode ,
					BatchId ,
					PAN ,
					BINRange ,
					BINGroup ,
					SourceAccountType ,
					DestinationAccountType ,
					SourcePCode ,
					IssuerNetworkId ,
					ProcessingFee ,
					ServiceFee ,
					ReversalType ,
					Title31Posted ,
					ACHEntryClass ,
					ACHECheckAck ,
					SourceDeviceId ,
					NetAddr ,
					NetAPI ,
					PayoutCash ,
					PayoutDeposit ,
					PayoutChips ,
					PayoutMarker ,
					PayoutOther ,
					PayoutStatus ,
					CreatedUserId ,
					SmartAcquierId ,
					ProcessedDate ,
					HostMerchantID ,
					HostTerminalID
				  )
		   	SELECT  @OrigTransId,GETUTCDATE(),@CombineTime,SystemSettlementDate,9,TransactionFlags,TransactionReason,TransactionState,@DeviceId,@DeviceDate,
					@DeviceSequence,NetworkId,NetworkSequence,NetworkSettlementDate1,NetworkSettlementDate2 ,NetworkTransactionId ,NetworkMerchantStationId ,
					RoutingCode ,@AmountRequest ,AmountAuthenticate ,@AmountSettlement ,@AmountSettlementDestination , AmountSettlementReconciliation ,
					AmountSurchargeRequest ,@AmountSurchargeFixed ,AmountSurchargeWaived ,@AmountSurcharge ,@AmountCommission ,AmountCashBack ,AmountConvinience ,
					SurchargeWaiveAuthorityId ,CurrencyRequest ,CurrencySource ,CurrencyDestination ,CurrencyDeviceRate ,CurrencyNetworkRate ,ResponseTypeId ,
					ResponseCodeInternal ,ResponseCodeExternal ,ResponseSubCodeExternal ,@CustomerId ,@CustomerMediaType ,@CustomerMediaEntryMode ,
					CustomerMediaDataPart1 ,CustomerMediaDataPart2 ,@CustomerMediaDataHash, CustomerMediaDataEncrypted ,CustomerMediaExpiryDate ,AuthenticationNumber ,
					ReferenceNumber ,ApprovalCode ,BatchId ,PAN ,BINRange ,BINGroup ,SourceAccountType ,DestinationAccountType ,SourcePCode ,IssuerNetworkId ,
					ProcessingFee ,ServiceFee ,ReversalType ,Title31Posted ,ACHEntryClass ,ACHECheckAck ,SourceDeviceId ,NetAddr ,NetAPI ,PayoutCash , 
					PayoutDeposit ,PayoutChips ,PayoutMarker ,PayoutOther ,4 ,@CreatedUserId ,0 ,@CombineTime ,HostMerchantID ,HostTerminalID 
					FROM dbo.tbl_trn_Transaction WITH (NOLOCK) WHERE id=@OrigTransId

  SET @TransId  =(SELECT SCOPE_IDENTITY())
  IF @TransId IS NOT NULL
 -- BEGIN
    INSERT into tbl_trn_TransactionAmountInter ([TranId],[AmountInterchangePaid])Values (@TransId,ISNULL(@AmountInterchangePaid,0))
 --   INSERT into tbl_trn_TransactionreExtendedColumn ([TranId],[ExtendedColumn]) Values (@TransId,ISNULL(@ExtendedColumn,''))
 -- END
  
 -- END TRY
 IF @@ERROR = 0
    BEGIN 
       COMMIT TRANSACTION
       RETURN 0
    END
 ELSE
    BEGIN
       ROLLBACK TRANSACTION 
       RETURN -1   
    END
END
GO
GRANT EXECUTE ON  [dbo].[usp_trn_UpdateandInsertPreAuthCardTransaction] TO [SAV4Role]
GRANT EXECUTE ON  [dbo].[usp_trn_UpdateandInsertPreAuthCardTransaction] TO [WebV4Role]
GO
