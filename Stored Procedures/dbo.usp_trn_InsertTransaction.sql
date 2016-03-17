SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_trn_InsertTransaction]
  @SystemTime                  datetime
 ,@DeviceId                    bigint
 ,@DeviceDate                  datetime
 ,@DeviceSequence              bigint
 ,@OriginalTransactionId       bigint
 ,@TransactionType             bigint
 ,@TransactionFlags            bigint
 ,@TransactionReason           bigint
 ,@TransactionState            bigint
 ,@AmountRequest               bigint
 ,@AmountAuthenticate          bigint
 ,@AmountDispense              bigint
 ,@AmountSurcharge             bigint
 ,@AmountDispenseDestination   bigint
 ,@AmountSurchargeDestination  bigint
 ,@AmountSurchargeWaived       bigint
 ,@AmountCashBack              bigint
 ,@AmountConvinience           bigint
 ,@SurchargeWaiveAuthorityId   bigint
 ,@CurrencyRequest             int
 ,@CurrencySource              int
 ,@CurrencyDestination         int
 ,@CurrencyDeviceRate          numeric(9,6)
 ,@CurrencyNetworkRate         numeric(9,6)
 ,@NetworkId                   bigint
 ,@NetworkSequence             bigint
 ,@NetworkSettlementDate1      datetime
 ,@NetworkSettlementDate2      datetime
 ,@RoutingCode                 bigint
 ,@AuthenticationNumber        nvarchar(50)
 ,@ReferenceNumber             nvarchar(15)
 ,@ApprovalCode                nvarchar(15)
 ,@BatchId                     nvarchar(25)
 ,@BINGroup                    bigint
 ,@SourceAccountType           bigint
 ,@DestinationAccountType      bigint
 ,@IssuerNetworkId             nvarchar(50)
 ,@NetAddr                     nvarchar(10)
 ,@NetAPI                      bigint
 ,@ResponseCodeInternal        bigint
 ,@ResponseCodeExternal        nvarchar(50)    
 ,@CustomerMediaData           nvarchar(50)   
 ,@CustomerMediaExpiryDate     nvarchar(50)
 ,@SourceDeviceName            nvarchar(50)
 ,@CreatedUserId               bigint
 ,@SmartAcquierId              bigint
 ,@HostMerchantID              varchar(20)
 ,@HostTerminalID              varchar(20)
 ,@ExtendedColumn              nvarchar(200)
 ,@TransactionId               bigint         OUTPUT
 ,@TransactionDate             datetime       OUTPUT
 ,@SystemSettlementDate        datetime       OUTPUT
 ,@OneStepFlag                 nvarchar(50) = NULL
-- Revision 2.2.0 2014.04.08 by Adam Glover
--   Add insert to tbl_DeviceUpdateCommands for other SmartAcquirer
-- Revision 2.2.1 2014.09.15 by Julian Wu
--   Record the last transaction activity for alert plus
-- Revision 2.3.0 2015.12.03 by Adam Glover
--   Append OneStepFlag parameter
AS
BEGIN
---SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
---BEGIN TRANSACTION
---BEGIN TRY
  SET NOCOUNT ON
  -- Calculate SystemSettlementDate
  -- DECLARE @Cutover numeric(4,2)
  --IF @NetworkId IN (104,195)  SET @Cutover=10.5  -- UTC 10.5 is EST 15.5
  --ELSE                        SET @Cutover=16    -- UTC 16   is EST 21
  
  DECLARE @SystemDate datetime
  --,@Year bigint,@DaylightSavingTimeBeginDate datetime,@DaylightSavingTimeEndDate datetime
  SET @SystemDate=GETUTCDATE() 
  --SET @Year=DATEPART(yy,@SystemDate)
  --SET @DaylightSavingTimeBeginDate=DATEADD(hh,2,dbo.udf_GetSunday(@Year,3,2))
  --SET @DaylightSavingTimeEndDate  =DATEADD(hh,2,dbo.udf_GetSunday(@Year,11,1))
  --IF @SystemDate>=@DaylightSavingTimeBeginDate AND @SystemDate<=@DaylightSavingTimeEndDate
  --  SET @Cutover=@Cutover+1
  
  --IF DATEPART(hh,@SystemDate)<@Cutover
  --  SET @SystemSettlementDate=DATEADD(dd,0,DATEDIFF(dd,0,@SystemDate))
  --ELSE
  --SET @SystemSettlementDate=DATEADD(dd,1,DATEDIFF(dd,0,@SystemDate))
  SET @SystemSettlementDate=convert(datetime, floor(convert(numeric(19, 8),@SystemDate)))

  -- Calculate PAN and BinRange
  DECLARE @PAN nvarchar(4),@BinRange nvarchar(6)
  SET @PAN=RIGHT(@CustomerMediaData,4)
  SET @BinRange=LEFT(@CustomerMediaData,6)
  
  -- Calculate SourcePCode
  DECLARE @SourcePCode nvarchar(8)
  SET @SourcePCode=(CASE WHEN @TransactionType IN (1,101) THEN 10000 WHEN @TransactionType=2 THEN 310000 WHEN @TransactionType=3 THEN 400000 ELSE 0 END)  --ATM withdraw or reversal withdraw, inquery or transfer
                  +(CASE WHEN @SourceAccountType=1 THEN 1000 WHEN @SourceAccountType=2 THEN 2000 WHEN @SourceAccountType=3 THEN 3000 WHEN @SourceAccountType=0 THEN 4000 ELSE 0 END)  -- Default Saving Check Credit
                  +(CASE WHEN @DestinationAccountType=1 THEN 10 WHEN @DestinationAccountType=2 THEN 20 WHEN @DestinationAccountType=3 THEN 30 WHEN @DestinationAccountType=0 THEN 40 ELSE 0 END)-- Default Saving Check Credit
  
  -- Protect customer information
  DECLARE @CustomerMediaDataHash varbinary(512),@CustomerMediaDataEncrypted varbinary(512)
  EXEC dbo.usp_sys_Hash @CustomerMediaData,@CustomerMediaDataHash OUT
  EXEC dbo.usp_sys_Encrypt @CustomerMediaData,@CustomerMediaDataEncrypted OUT
    
  -- Set source device id
  DECLARE @SourceDeviceId bigint
  IF @SourceDeviceName IS NOT NULL
    SELECT @SourceDeviceId=Id FROM dbo.tbl_Device WHERE TerminalName=@SourceDeviceName
  ELSE
    SET @SourceDeviceId=@DeviceId
  -- Set reversal type
  DECLARE @ReversalType bigint
  SET @ReversalType=0
  
  -- Set AmountSurchargeRequest
  DECLARE @AmountSurchargeRequest bigint
  SET @AmountSurchargeRequest = @AmountSurcharge
  
  --Calculate commission amount
    DECLARE @CommissionType bigint,@AmountSurchargeFixed bigint=0,@AmountSurchargePercentage bigint=0,@DispenseAmountPercent money = 0,@SurchargeFixedAmountPercent money = 0,@SurchargeVariableAmountPercent money = 0,@AmountCommission bigint = 0
  IF      @TransactionType IN (7,9,10,11,12) AND @TransactionFlags & 0x00080000 = 0  SET @CommissionType=1   -- POS Debit
  ELSE IF @TransactionType IN (7,9,10,11,12) AND @TransactionFlags & 0x00080000 > 0  SET @CommissionType=2   -- POS Credit
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
        EXEC dbo.usp_dev_GetDeviceFeeFixed @DeviceId,@AmountRequest,@TransactionType,@TransactionFlags,@BinRange,@BinGroup,@SourceAccountType,@AmountSurchargeFixed OUTPUT,@AmountSurchargePercentage OUTPUT
    END
    
    SET @AmountCommission=@AmountDispense*@DispenseAmountPercent+@AmountSurchargeFixed*@SurchargeFixedAmountPercent+(@AmountSurcharge-@AmountSurchargeFixed)*@SurchargeVariableAmountPercent
  END
  
  -- Calculate interchange amount
  DECLARE @AmountInterchangePaid bigint = 0
  IF @TransactionType IN (1,2,3,4,5,6,7,8,9,10,11,12,101,103,104,107,108,109,110,111,112)
    SELECT @AmountInterchangePaid=ISNULL(SUM(CASE WHEN @ResponseCodeInternal=0 --approved
    THEN a.AmountApproval ELSE a.AmountDeclined END),0)
    FROM dbo.tbl_DeviceToInterchangeScheme        i  
    LEFT JOIN dbo.tbl_InterchangeSchemeSignature  g1 ON g1.InterchangeSchemeId=i.InterchangeSchemeId AND g1.IssuerNetworkId=@IssuerNetworkId AND g1.TransactionType=@TransactionType
    LEFT JOIN dbo.tbl_InterchangeSchemeSignature  g2 ON g2.InterchangeSchemeId=i.InterchangeSchemeId AND g2.IssuerNetworkId=N'ALL'           AND g2.TransactionType=@TransactionType
    LEFT JOIN dbo.tbl_InterchangeSchemeSignature  g3 ON g3.InterchangeSchemeId=i.InterchangeSchemeId AND g3.IssuerNetworkId=@IssuerNetworkId AND g3.TransactionType=0
    LEFT JOIN dbo.tbl_InterchangeSchemeSignature  g4 ON g4.InterchangeSchemeId=i.InterchangeSchemeId AND g4.IssuerNetworkId=N'ALL'           AND g4.TransactionType=0
    JOIN dbo.tbl_InterchangeSchemeSignatureAmount a  ON a.InterchangeSchemeSignatureId=ISNULL(ISNULL(ISNULL(g1.id,g2.id),g3.Id),g4.Id)
    WHERE i.DeviceId=@DeviceId
  
  -- Reset dispense and surcharge amount
  DECLARE @AmountSettlement bigint,@AmountSettlementDestination bigint
  IF @TransactionType IN (8,108) -- pre-author , reversal of pre-author
  OR (@ResponseCodeInternal<>0 AND @TransactionType<100)-- not reversal and inquiry
  BEGIN
    SET @AmountDispense=0
    SET @AmountDispenseDestination=0
    SET @AmountSurcharge=0
    SET @AmountSurchargeDestination=0
    SET @AmountSurchargeFixed=0
    SET @AmountSurchargeWaived=0
  END  
  ELSE IF @TransactionType IN (2,3,5,6,103)  --ATM Balance Inquiry,ATM Account Transfer,ATM Statement Request,Pre-transaction request for Accounts associated with the inserted card,Reversal of ATM Account Transfer
  BEGIN
    SET @AmountDispense=0
    SET @AmountDispenseDestination=0
  END  
  ----------------------------------------------------------------------------------------------------------
  -- Calculate settlement and surcharge amount
  IF @TransactionType IN (4,10,11) -- ATM Deposit,Merchandise Return,Void Sale
  BEGIN      --@1
    SET @AmountSettlement=-1*@AmountDispense+@AmountSurcharge
    SET @AmountSettlementDestination=-1*@AmountDispenseDestination+@AmountSurchargeDestination
  END
  ELSE            --- not 4,10,11
  BEGIN
    SET @AmountSettlement=@AmountDispense+@AmountSurcharge
    SET @AmountSettlementDestination=@AmountDispenseDestination+@AmountSurchargeDestination
  
    --IF @TransactionType =9  -- when trying to insert 9,device id is equal to current source device id
    --   SELECT   TOP  1 @OriginalTransactionId=Id  FROM dbo.tbl_trn_Transaction --currently we just need to find the originalTransactionId not sure about the rest columns 
    --   WHERE CustomerMediaDataHash=@CustomerMediaDataHash AND (DeviceId=@DeviceId OR DeviceId=@SourceDeviceId) AND DeviceSequence=@DeviceSequence AND TransactionType<100
    --   ORDER BY SystemDate DESC  

  
    IF @TransactionType>100   --- all reversals and Transaction Status Inquiry 
    BEGIN  --@2
      -- Set internal response code
      SET @ResponseCodeInternal=0  --approved
      -- Set reverse type
      IF @TransactionReason=3   --- Some bills dispensed
       SET @ReversalType=2  --Partial Reversal
      ELSE                     
       SET @ReversalType=1  --Full Reversal
    
      -- Get original transaction
      DECLARE @ReversalType0 bigint,@AmountSettlement0 bigint,@AmountSettlementDestination0 bigint,@AmountSurcharge0 bigint,@AmountSurchargeFixed0 bigint,@AmountSurchargeWaived0 bigint,@AmountCommission0 bigint
      IF @OriginalTransactionId IS NOT NULL
        SELECT  @ReversalType0=ReversalType,@AmountSettlement0=AmountSettlement,@AmountSettlementDestination0=AmountSettlementDestination,@AmountSurcharge0=AmountSurcharge,@AmountSurchargeFixed0=AmountSurchargeFixed,@AmountSurchargeWaived0=AmountSurchargeWaived,@AmountCommission0=AmountCommission,@TransactionState=TransactionState 
        FROM dbo.tbl_trn_Transaction WHERE Id=@OriginalTransactionId 

      ELSE
        SELECT TOP 1 
        @OriginalTransactionId=Id,@ReversalType0=ReversalType,@AmountSettlement0=AmountSettlement,@AmountSettlementDestination0=AmountSettlementDestination,@AmountSurcharge0=AmountSurcharge,@AmountSurchargeFixed0=AmountSurchargeFixed, @AmountSurchargeWaived0=AmountSurchargeWaived,@AmountCommission0=AmountCommission,@TransactionState=TransactionState 
        FROM dbo.tbl_trn_Transaction 
        WHERE CustomerMediaDataHash=@CustomerMediaDataHash AND DeviceId=@DeviceId AND DeviceSequence=@DeviceSequence AND TransactionType<100
        -- not reversal and Transaction Status Inquiry
         --AND ReversalType>0    --- full reverse or Partial reverse
        ORDER BY SystemDate DESC        
      -- Ignore current reversal transaction if original transaction does not exist or has been reversed
      IF @OriginalTransactionId IS NULL OR @ReversalType0>0
        RETURN 0
      ELSE    ---- OriginalTransactionId is not null and @reversalType0=0
      BEGIN  -- @3   
        SET @AmountSettlement           =@AmountSettlement           -@AmountSettlement0
        SET @AmountSurcharge            =@AmountSurcharge            -@AmountSurcharge0
        SET @AmountSurchargeFixed       =@AmountSurchargeFixed       -@AmountSurchargeFixed0
        SET @AmountSurchargeWaived      =@AmountSurchargeWaived      -@AmountSurchargeWaived0
        SET @AmountSettlementDestination=@AmountSettlementDestination-@AmountSettlementDestination0
        SET @AmountCommission           =@AmountCommission           -@AmountCommission0
        -- Update reverse type and payout status on original transaction
        UPDATE dbo.tbl_trn_Transaction SET ReversalType=@ReversalType,PayoutStatus=CASE WHEN @TransactionType IN (107,108,109,156)  ---Reversal of Purchase,Reversal of Pre-Authorization,Reversal of Pre-Authorization Completion ,ACH Reversal
        THEN 2 ELSE NULL END WHERE Id=@OriginalTransactionId
      END  ---@3
   END---@2
  END  ----@1

  DECLARE @PayoutStatus bigint
  -- Set payout status to pending when transaction type are Pre-Authorization and tranaction is approved or referral
  IF @TransactionType =8   --Pre-Authorization
   AND @ResponseCodeInternal IN (0,37)  -- Approved,Call voice operator
    SET @PayoutStatus=1
  -- Set payout status to void when transaction type are Void Sale
  ELSE IF @TransactionType =11  AND @ResponseCodeInternal=0
    SET @PayoutStatus=2
  -- Set payout status to void when transaction type is Reverse of Purchase,Revsrse of Pre-Authorization,Revsrse of Pre-Authorization Completion, Ach Reverse
  ELSE IF @TransactionType IN (107,108,109,156)
    SET @PayoutStatus=3       -- Rocky modified from 2 to 3
  -- Set payout status to process when transaction type are POS Purchase,POS Completion of Pre-Authorization,Credit Sale,Credit Completion of Pre-Authorization,Credit Force,Personal Check Auth,Payroll Check Auth,Company Check Auth,Exception Check Auth,E-Check(Personal) Auth and tranaction is approved or referal
  ELSE IF @TransactionType IN (7,9,52,53,54,55,56,63,68) AND @ResponseCodeInternal IN (0,37) -- Approved,Call voice operator
    SET @PayoutStatus=3
  --Update original transaction payout status 
  --IF @TransactionType=9 AND @ReferenceNumber IS NOT NULL OR  @ResponseCodeInternal=0  -- (Pre-Authorization Completion),Force Capture
  --   UPDATE dbo.tbl_trn_Transaction SET PayoutStatus=5 --finish
  --   WHERE CustomerMediaDataHash=@CustomerMediaDataHash AND DeviceId=@SourceDeviceId AND AuthenticationNumber=@ReferenceNumber

   --ELSE IF @TransactionType =11 -- Pre-Authorization Completion,  Void Sale
   --  AND @ResponseCodeInternal=0  -- Approved
   --  UPDATE dbo.tbl_trn_Transaction SET PayoutStatus= 2 
   --  WHERE CustomerMediaDataHash=@CustomerMediaDataHash AND DeviceId=@SourceDeviceId AND AuthenticationNumber=@AuthenticationNumber
  -- Insert transaction
  IF @AmountSurcharge=0 
  SET @AmountCommission=0 
  INSERT dbo.[tbl_trn_Transaction] (
      [SystemDate]
     ,[SystemTime]
     ,[SystemSettlementDate]
     ,[OriginalTransactionId]
     ,[TransactionType]
     ,[TransactionFlags]
     ,[TransactionReason] 
     ,[TransactionState]
     ,[DeviceId]
     ,[DeviceDate]
     ,[DeviceSequence]
     ,[NetworkId]
     ,[NetworkSequence]
     ,[NetworkSettlementDate1]
     ,[NetworkSettlementDate2]
     ,[RoutingCode] 
     ,[AmountRequest]
     ,[AmountAuthenticate] 
     ,[AmountSettlement] 
     ,[AmountSettlementDestination] 
     ,[AmountSurchargeRequest]
     ,[AmountSurchargeFixed]
     ,[AmountSurchargeWaived] 
     ,[AmountSurcharge]
     ,[AmountCommission]
     ,[AmountCashBack]
     ,[AmountConvinience]
     
     ,[SurchargeWaiveAuthorityId] 
     ,[CurrencyRequest] 
     ,[CurrencySource] 
     ,[CurrencyDestination] 
     ,[CurrencyDeviceRate]
     ,[CurrencyNetworkRate]
     ,[AuthenticationNumber]
     ,[ReferenceNumber]
     ,[ApprovalCode]
     ,[BatchId]
     ,[PAN]
     ,[BINRange]
     ,[BINGroup]
     ,[SourceAccountType]
     ,[DestinationAccountType]
     ,[SourcePCode]
     ,[IssuerNetworkId]
     ,[NetAddr]
     ,[NetAPI]
     ,[ResponseCodeInternal] 
     ,[ResponseCodeExternal] 
     ,[CustomerMediaDataHash] 
     ,[CustomerMediaDataEncrypted]
     ,[CustomerMediaExpiryDate]
     ,[ReversalType]
     ,[SourceDeviceId]
     ,[PayoutStatus]
     
     ,[CreatedUserId]
     ,[SmartAcquierId]
     ,[HostMerchantID]
     ,[HostTerminalID]
     ,[CustomerMediaDataPart1]
    -- ,[ExtendedColumn]
  )
  VALUES (
      @SystemDate
     ,@SystemTime
     ,@SystemSettlementDate     
     ,@OriginalTransactionId
     ,@TransactionType
     ,@TransactionFlags
     ,@TransactionReason 
     ,@TransactionState
     ,@DeviceId 
     ,@DeviceDate 
     ,@DeviceSequence 
     ,@NetworkId
     ,@NetworkSequence
     ,@NetworkSettlementDate1
     ,@NetworkSettlementDate2     
     ,@RoutingCode
     ,@AmountRequest 
     ,@AmountAuthenticate 
     ,@AmountSettlement 
     ,@AmountSettlementDestination 
     
     ,@AmountSurchargeRequest
     ,@AmountSurchargeFixed
     ,@AmountSurchargeWaived
     ,@AmountSurcharge
     ,@AmountCommission 
     ,@AmountCashBack
     ,@AmountConvinience
     ,@SurchargeWaiveAuthorityId 
        
     ,@CurrencyRequest
     ,@CurrencySource
     ,@CurrencyDestination
     ,@CurrencyDeviceRate
     ,@CurrencyNetworkRate
     ,@AuthenticationNumber
     ,@ReferenceNumber
     ,@ApprovalCode
     ,@BatchId
     ,@PAN
     ,@BinRange
     ,@BINGroup
     ,@SourceAccountType
     ,@DestinationAccountType
     ,@SourcePCode
     ,@IssuerNetworkId
     ,@NetAddr
     ,@NetAPI
     ,@ResponseCodeInternal 
     ,@ResponseCodeExternal
     ,@CustomerMediaDataHash
     ,@CustomerMediaDataEncrypted
     ,NULL -- ExpiryDate
     ,@ReversalType
     ,@SourceDeviceId
     ,@PayoutStatus
   
     ,@CreatedUserId
     ,@SmartAcquierId
     ,@HostMerchantID
     ,@HostTerminalID
     ,@OneStepFlag -- Save to CustomerMediaDataPart1
  --   ,@ExtendedColumn
  )


  
  SET @TransactionId  =(SELECT SCOPE_IDENTITY())
  SET @TransactionDate=@SystemDate
  Insert into tbl_trn_TransactionAmountInter ([TranId],[AmountInterchangePaid])Values (@TransactionId,@AmountInterchangePaid)
  Insert into tbl_trn_TransactionreExtendedColumn ([Tranid],[ExtendedColumn]) Values (@TransactionId,@ExtendedColumn)

  

-- Record the last transaction activity

  IF EXISTS (select * from tbl_DeviceActivity where DeviceId=@DeviceId)
	   UPDATE  tbl_DeviceActivity set LastTransTime=@SystemTime where DeviceId=@DeviceId
  ELSE INSERT INTO tbl_DeviceActivity VALUES(@DeviceId, @SystemTime,'1900-01-01')
 -- MERGE dbo.tbl_DeviceActivity as t
 -- USING (SELECT @DeviceId, @SystemTime) as s(DeviceId, SystemTime)
	--ON t.DeviceId = s.DeviceId
 -- WHEN MATCHED THEN UPDATE SET LastTransTime = s.SystemTime
 -- WHEN NOT MATCHED THEN INSERT (DeviceId, LastTransTime, LastMgmtTime) VALUES(s.DeviceId, s.SystemTime, '1900-01-01');


  -- Update device cassette count
  DECLARE @CassetteCount bigint,@MediaValue bigint,@MediaCount bigint
  IF @TransactionType IN (1,101)    --withdrawal or reversal withdrawal
  BEGIN
    SELECT @CassetteCount=COUNT(*) FROM dbo.tbl_DeviceCassette WHERE DeviceId=@DeviceId
    IF @CassetteCount=1
    BEGIN
      SELECT @MediaValue=MediaValue FROM dbo.tbl_DeviceCassette WHERE DeviceId=@DeviceId
      SET @MediaCount=(@AmountSettlement-@AmountSurcharge)/@MediaValue
      UPDATE dbo.tbl_DeviceCassette SET MediaCurrentCount=MediaCurrentCount-@MediaCount,MediaCurrentUse=MediaCurrentUse+@MediaCount,UpdatedUserId=0 WHERE DeviceId=@DeviceId

    END
  END  
  -- Clear up device error
  UPDATE dbo.tbl_DeviceError SET ResolvedDate=GETUTCDATE(),ResolvedText='Cleared from SmartAcquier',UpdatedUserId=0 WHERE DeviceId=@DeviceId AND DeviceEmulation=0 AND ErrorCode=0 AND ResolvedDate IS NULL
  
  
---COMMIT TRANSACTION

---END TRY

---BEGIN CATCH
	--If during insert transaction process an error occurred then the following code will be executed
--	if @@error <> 0 AND @@trancount > 0
--	BEGIN
--		DECLARE @EX_ERROR_MESSAGE nvarchar(MAX), @STATE int, @SEVERITY int
--		SELECT @EX_ERROR_MESSAGE =
--		'An error occured:' + char(13) + char(10)
--		+ 'Msg ' + cast( ERROR_NUMBER() as nvarchar(20) )
--		+ ', Level ' + cast( ERROR_SEVERITY() as nvarchar(20) )
--		+ ', State ' + cast( ERROR_STATE() as nvarchar(20) )
--		+ ', Line ' + cast( ERROR_LINE() as nvarchar(20) ) + char(13) + char(10)
--		+ ERROR_MESSAGE() + char(13) + char(10),
--		@SEVERITY = ERROR_SEVERITY(),
--			@STATE = ERROR_STATE()
--		RAISERROR(@EX_ERROR_MESSAGE, @SEVERITY, @STATE)
--	END
--	ROLLBACK TRAN
--	PRINT 'INSERT TRANSACTION is completed with errors, INSERT is cancelled'
--END CATCH
END
GO
GRANT EXECUTE ON  [dbo].[usp_trn_InsertTransaction] TO [SAV4Role]
GRANT EXECUTE ON  [dbo].[usp_trn_InsertTransaction] TO [WebV4Role]
GO
