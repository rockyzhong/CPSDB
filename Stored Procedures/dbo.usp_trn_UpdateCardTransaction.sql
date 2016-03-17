SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_trn_UpdateCardTransaction]
@DeviceId                bigint
,@DeviceSequence          bigint        
,@CustomerMediaDataHash   varbinary(512)
,@ISystemTime             varchar (10)     -- Java time import 
,@ISystemDate             varchar (10)     -- Java date import
,@TransactionType         bigint
,@SurchageWaivedUserId    bigint
,@CustomerId              bigint
,@CustomerMediaType       bigint
,@CustomerMediaEntryMode  nvarchar (1)
,@AmountRequest           bigint
,@AuthenticationNumber    nvarchar(50)
,@HostTerminalID          varchar (20)
,@HostMerchantID          varchar (20)
,@CreatedUserId           BIGINT
,@ExtendedColumn          NVARCHAR(200)=NULL


AS
BEGIN
  SET NOCOUNT ON

  -- Set payout status to pay when transaction is card transaction and is approved
DECLARE @PayoutStatus bigint
,@transid    bigint
,@CombineTime datetime 
--,@SystemTime datetime
--,@cutover bigint 
--,@i       datetime 
SET @CombineTime= CONVERT(Datetime, @ISystemDate+' '+@ISystemTime, 120)
--SET @cutover= datediff(hh,GETDATE(),GETUTCDATE())
--SET @SystemTime=dateadd(hh,@cutover,@CombineTime)
--SET @SystemTime=@CombineTime
SET @PayoutStatus=4
--SET @i='00:00:00' 
--WHILE @i<='00:00:05'
--BEGIN
SELECT top 1 @transid=id from dbo.tbl_trn_Transaction t WITH (NOLOCK) 
WHERE DeviceId=@DeviceId and DeviceSequence=@DeviceSequence and CustomerMediaDataHash=@CustomerMediaDataHash and TransactionType=@TransactionType and AmountRequest=@AmountRequest And 
AuthenticationNumber=@AuthenticationNumber And systemtime between @CombineTime and DATEADD(MS,999,@CombineTime)
ORDER by SystemTime desc
 
IF @transid is not NULL 
  BEGIN 
	UPDATE dbo.tbl_trn_Transaction SET
	SurchargeWaiveAuthorityId =@SurchageWaivedUserId,CustomerId=@CustomerId,CustomerMediaType=@CustomerMediaType,CustomerMediaEntryMode=@CustomerMediaEntryMode,PayoutStatus=@PayoutStatus,HostTerminalID=@HostTerminalID, HostMerchantID=@HostMerchantID, CreatedUserId=@CreatedUserId                              
	WHERE Id=@transid
	UPDATE dbo.tbl_trn_TransactionReExtendedColumn SET 
	ExtendedColumn=@ExtendedColumn WHERE TranId=@transid
	--GOTO FINISH
  END
--waitfor delay @i
--SET @i=@i+'00:00:01'
--END
   ELSE
--IF @transid is NULL
insert into [tbl_trn_CardTransactionPending] values ( @DeviceId
,@DeviceSequence       
,@CustomerMediaDataHash   
,@CombineTime                 
,@TransactionType        
,@SurchageWaivedUserId    
,@CustomerId             
,@CustomerMediaType     
,@AmountRequest          
,@AuthenticationNumber    
,@HostTerminalID         
,@HostMerchantID
,@CreatedUserId
,@CustomerMediaEntryMode
,@ExtendedColumn)

--FINISH: 
--SELECT top 1 @transid=id
--FROM dbo.tbl_trn_Transaction  
--WHERE DeviceId=@DeviceId and DeviceSequence=@DeviceSequence and CustomerMediaDataHash=@CustomerMediaDataHash and TransactionType=@TransactionType and AmountRequest=@AmountRequest And --AuthenticationNumber=@AuthenticationNumber And systemtime between @SystemTime and DATEADD(MS,999,@SystemTime)
--ORDER by systemtime desc
RETURN 0

END
GO
GRANT EXECUTE ON  [dbo].[usp_trn_UpdateCardTransaction] TO [SAV4Role]
GRANT EXECUTE ON  [dbo].[usp_trn_UpdateCardTransaction] TO [WebV4Role]
GO
