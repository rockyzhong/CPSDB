SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_trn_UpdateCheckTransaction]
  @TransactionId               bigint
 ,@TransactionDate             datetime
 ,@TransactionType             bigint

 ,@NetworkSettlementDate2      datetime
 ,@NetworkTransactionId        nvarchar(50)
 ,@NetworkMerchantStationId    bigint

 ,@AmountAuthenticate          bigint
 ,@AmountDispense              bigint
 ,@AmountSurcharge             bigint
 ,@AmountDispenseDestination   bigint
 ,@AmountSurchargeDestination  bigint

 ,@AuthenticationNumber        nvarchar(50)
 ,@ReferenceNumber             nvarchar(15)

 ,@ResponseTypeId              bigint
 ,@ResponseCodeInternal        bigint
 ,@ResponseCodeExternal        nvarchar(50)
 ,@ResponseSubCodeExternal     nvarchar(50)
      
 ,@CustomerId                  bigint
 ,@CustomerMediaType           bigint
 ,@CustomerMediaEntryMode      nvarchar(1)
 ,@CustomerMediaDataPart1      nvarchar(50)
 ,@CustomerMediaDataPart2      nvarchar(50)

 ,@ServiceFee                  bigint
 ,@ACHEntryClass               nvarchar(3)
 ,@CreatedUserId               bigint        
AS
BEGIN
  SET NOCOUNT ON
  
  -- Calculate settlement and surcharge amount
  DECLARE @AmountSettlement bigint,@AmountSettlementDestination bigint
  SET @AmountSettlement=@AmountDispense+@AmountSurcharge
  SET @AmountSettlementDestination=@AmountDispenseDestination+@AmountSurchargeDestination

  -- Set payout status to process when transaction is check transaction and is approved
  DECLARE @PayoutStatus bigint
  IF @TransactionType IN (52,53,54,55,56,63,68) AND @ResponseCodeInternal IN (0,37)
    SET @PayoutStatus=3

  -- UPDATE transaction
  UPDATE dbo.tbl_trn_Transaction SET
  NetworkSettlementDate2=@NetworkSettlementDate2,NetworkTransactionId=@NetworkTransactionId,NetworkMerchantStationId=@NetworkMerchantStationId,
  AmountAuthenticate=@AmountAuthenticate,AmountSettlement=@AmountSettlement,AmountSurcharge=@AmountSurcharge,
  AmountSettlementDestination=@AmountSettlementDestination,AuthenticationNumber=@AuthenticationNumber,ReferenceNumber=@ReferenceNumber,
  ResponseTypeId=@ResponseTypeId,ResponseCodeInternal=@ResponseCodeInternal,
  ResponseCodeExternal=@ResponseCodeExternal,ResponseSubCodeExternal=@ResponseSubCodeExternal,
  CustomerId=@CustomerId,CustomerMediaType=@CustomerMediaType,CustomerMediaEntryMode=@CustomerMediaEntryMode,
  CustomerMediaDataPart1=@CustomerMediaDataPart1,CustomerMediaDataPart2=@CustomerMediaDataPart2,
  ServiceFee=@ServiceFee,ACHEntryClass=@ACHEntryClass,PayoutStatus=@PayoutStatus
  WHERE Id=@TransactionId

  RETURN 0
END
GO
GRANT EXECUTE ON  [dbo].[usp_trn_UpdateCheckTransaction] TO [SAV4Role]
GRANT EXECUTE ON  [dbo].[usp_trn_UpdateCheckTransaction] TO [WebV4Role]
GO
