SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[usp_trn_FinishCardTransaction]
  @DeviceId                nvarchar(50)
 ,@DeviceSequence          bigint
 ,@CustomerMediaDataHash   varbinary(512)
 ,@PayoutCash              bigint
 ,@PayoutDeposit           bigint
 ,@PayoutChips             bigint
 ,@PayoutMarker            bigint
 ,@PayoutOther             bigint
 ,@PayoutStatus            bigint
 ,@Imagedata               varbinary(MAX)
 ,@Title31Posted           bit
 ,@CreatedUserId           bigint
 ,@ISystemTime             varchar (10)     -- Java time import 
 ,@ISystemDate             varchar (10)     -- Java date import
 ,@TransactionType         bigint
 ,@AmountRequest           bigint
 ,@AuthenticationNumber    nvarchar(50)
 ,@PaymentIdString         nvarchar(50)
 ,@PaymentAmountString     nvarchar(50)       
AS
BEGIN
DECLARE @transid bigint,@CombineTime datetime ,@SystemTime datetime,@cutover bigint,@PaymentIdTab ValueTypeTable,@PaymentAmountTab ValueTypeTable
  SET NOCOUNT ON
  SET @CombineTime= CONVERT(Datetime, @ISystemDate+' '+@ISystemTime, 120)
  SET @PayoutStatus= 5
  --SET @cutover= datediff(hh,GETDATE(),GETUTCDATE())
  --SET @SystemTime=dateadd(hh,@cutover,@CombineTime)
  SET @SystemTime=@CombineTime
  IF EXISTS(select top 1 id,SystemTime from dbo.tbl_trn_Transaction t 
  WHERE DeviceId=@DeviceId and DeviceSequence=@DeviceSequence and CustomerMediaDataHash=@CustomerMediaDataHash and TransactionType=@TransactionType and AmountRequest=@AmountRequest And   AuthenticationNumber=@AuthenticationNumber And systemtime between @SystemTime and DATEADD(MS,999,@SystemTime)
  ORDER by SystemTime desc) 
  BEGIN
  SELECT top 1 @transid=id
  FROM dbo.tbl_trn_Transaction  
  WHERE DeviceId=@DeviceId and DeviceSequence=@DeviceSequence and CustomerMediaDataHash=@CustomerMediaDataHash and TransactionType=@TransactionType and AmountRequest=@AmountRequest And   AuthenticationNumber=@AuthenticationNumber And systemtime between @SystemTime and DATEADD(MS,999,@SystemTime)
  ORDER by systemtime desc
  UPDATE dbo.tbl_trn_Transaction SET 
  PayoutCash=@PayoutCash,PayoutDeposit=@PayoutDeposit,PayoutChips=@PayoutChips,
  PayoutMarker=@PayoutMarker,PayoutOther=@PayoutOther,PayoutStatus=@PayoutStatus
  ,Title31Posted=@Title31Posted,CreatedUserId=@CreatedUserId
  WHERE Id=@transid
  IF not exists (select tranid from tbl_trn_TransactionreExtendedColumn where TranId=@transid)
  Insert into  dbo.tbl_trn_TransactionreExtendedColumn ([TranId],[ImageData]) values (@transid,@Imagedata)
  ELSE
  UPDATE dbo.tbl_trn_TransactionreExtendedColumn SET Imagedata=@Imagedata WHERE TranId=@transid
  
  ----------------------- insert paymentmethod table parameters--------------
  IF @PaymentIdString <>'' AND @PaymentAmountString <>''
  BEGIN
     INSERT INTO @PaymentIdTab exec usp_sys_Split @PaymentIdString
     INSERT INTO @PaymentAmountTab exec usp_sys_Split @PaymentAmountString
     INSERT INTO tbl_trn_TransactionPaymentMethod SELECT @transid,convert(bigint,PI.Value),convert(bigint,PV.Value) FROM @PaymentAmountTab PV JOIN @PaymentIdTab PI ON PV.Id=PI.Id
  END
  END
  RETURN 0
END

GO
GRANT EXECUTE ON  [dbo].[usp_trn_FinishCardTransaction] TO [SAV4Role]
GRANT EXECUTE ON  [dbo].[usp_trn_FinishCardTransaction] TO [WebV4Role]
GO
