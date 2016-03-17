SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_trn_UpdateCardTransactionPendingTable]

AS
BEGIN
  SET NOCOUNT ON
DECLARE
@Id                       bigint
,@DeviceId                bigint
,@DeviceSequence          bigint        
,@CustomerMediaDataHash   varbinary(512)
,@TransactionType         bigint
,@SurchageWaivedUserId    bigint
,@CustomerId              bigint
,@CustomerMediaType       bigint
,@AmountRequest           bigint
,@AuthenticationNumber    nvarchar(50)
,@HostTerminalID          varchar (20)
,@HostMerchantID          varchar (20)
,@PayoutStatus            bigint
,@transid                 bigint
,@CombineTime             datetime
,@CreatedUserId           BIGINT
,@ExtendedColumn          NVARCHAR(200)

SET @PayoutStatus=4
DECLARE TempCursor CURSOR LOCAL FOR SELECT id,DeviceId,DeviceSequence,CustomerMediaDataHash,CombineTime,TransactionType,SurchageWaivedUserId,CustomerId,CustomerMediaType,AmountRequest,AuthenticationNumber,HostTerminalID,HostMerchantID,CreatedUserId,ExtendedColumn FROM dbo.tbl_trn_CardTransactionPending
  OPEN TempCursor
  FETCH NEXT FROM TempCursor INTO @Id,@DeviceId,@DeviceSequence,@CustomerMediaDataHash,@CombineTime,@TransactionType,@SurchageWaivedUserId,@CustomerId,@CustomerMediaType,@AmountRequest,@AuthenticationNumber,@HostTerminalID,@HostMerchantID,@CreatedUserId,@ExtendedColumn
  WHILE @@Fetch_Status=0
BEGIN
SELECT top 1 @transid=id
FROM dbo.tbl_trn_Transaction WITH (NOLOCK) 
WHERE DeviceId=@DeviceId and DeviceSequence=@DeviceSequence and CustomerMediaDataHash=@CustomerMediaDataHash and TransactionType=@TransactionType and AmountRequest=@AmountRequest And AuthenticationNumber=@AuthenticationNumber And systemtime between @CombineTime and DATEADD(MS,999,@CombineTime)
ORDER by systemtime desc

IF @transid IS NOT NULL
BEGIN

UPDATE dbo.tbl_trn_Transaction SET
SurchargeWaiveAuthorityId =@SurchageWaivedUserId,CustomerId=@CustomerId,CustomerMediaType=@CustomerMediaType,PayoutStatus=@PayoutStatus,HostTerminalID=@HostTerminalID, HostMerchantID=@HostMerchantID, CreatedUserId=@CreatedUserId                        
WHERE Id=@transid
UPDATE dbo.tbl_trn_TransactionReExtendedColumn SET ExtendedColumn=@ExtendedColumn 
WHERE TranId=@transid  
DELETE FROM dbo.tbl_trn_CardTransactionPending where id=@Id
END

  FETCH NEXT FROM TempCursor INTO @Id,@DeviceId,@DeviceSequence,@CustomerMediaDataHash,@CombineTime,@TransactionType,@SurchageWaivedUserId,@CustomerId,@CustomerMediaType,@AmountRequest,@AuthenticationNumber,@HostTerminalID,@HostMerchantID,@CreatedUserId,@ExtendedColumn
END
  CLOSE TempCursor
  DEALLOCATE TempCursor

RETURN 0

END
GO
