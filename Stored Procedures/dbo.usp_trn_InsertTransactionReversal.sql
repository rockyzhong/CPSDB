SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_trn_InsertTransactionReversal]
  @DeviceId                    bigint
 ,@DeviceDate                  datetime
 ,@DeviceSequence              bigint

 ,@TransactionType             bigint
 ,@TransactionFlags            bigint
 ,@TransactionReason           bigint

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
 ,@NetworkData                 nvarchar(500)

 ,@AuthenticationNumber        nvarchar(50)
 ,@ReferenceNumber             nvarchar(15)
 ,@ApprovalCode                nvarchar(15)
 ,@BatchId                     nvarchar(25)
 ,@BINGroup                    bigint
 ,@SourceAccountType           bigint
 ,@DestinationAccountType      bigint
 ,@IssuerNetworkId             nvarchar(50)
 
 ,@CustomerMediaData           nvarchar(50)   
 ,@CustomerMediaExpiryDate     nvarchar(50)

 ,@SourceDeviceName            nvarchar(50)

 ,@CreatedUserId               bigint
 ,@SmartAcquierId              bigint
AS
BEGIN
  SET NOCOUNT ON
  
  -- Protect customer information
  DECLARE @CustomerMediaDataHash varbinary(512),@CustomerMediaDataEncrypted varbinary(512)
  EXEC dbo.usp_sys_Hash @CustomerMediaData,@CustomerMediaDataHash OUT
  EXEC dbo.usp_sys_Encrypt @CustomerMediaData,@CustomerMediaDataEncrypted OUT

  INSERT INTO dbo.tbl_trn_TransactionReversal(
       [SystemDate]
      ,[TransactionType]
      ,[TransactionFlags]
      ,[TransactionReason]
      ,[DeviceId]
      ,[DeviceDate]
      ,[DeviceSequence]
      ,[NetworkId]
      ,[NetworkSequence]
      ,[NetworkSettlementDate1]
      ,[NetworkSettlementDate2]
      ,[NetworkData]
      ,[AmountRequest]
      ,[AmountAuthenticate]
      ,[AmountDispense]
      ,[AmountSurcharge]
      ,[AmountDispenseDestination]
      ,[AmountSurchargeDestination]
      ,[AmountSurchargeWaived]
      ,[AmountCashBack]
      ,[AmountConvinience]
      ,[SurchargeWaiveAuthorityId]
      ,[CurrencyRequest]
      ,[CurrencySource]
      ,[CurrencyDestination]
      ,[CurrencyDeviceRate]
      ,[CurrencyNetworkRate]
      ,[CustomerMediaDataHash] 
      ,[CustomerMediaDataEncrypted]
      ,[CustomerMediaExpiryDate]
      ,[AuthenticationNumber]
      ,[ReferenceNumber]
      ,[ApprovalCode]
      ,[BatchId]
      ,[BINGroup]
      ,[SourceAccountType]
      ,[DestinationAccountType]
      ,[IssuerNetworkId]
      ,[SourceDeviceName]
      ,[CreatedUserId]
      ,[SmartAcquierId]
  )
  VALUES (
       GETUTCDATE()
      ,@TransactionType
      ,@TransactionFlags
      ,@TransactionReason
      ,@DeviceId
      ,@DeviceDate
      ,@DeviceSequence
      ,@NetworkId
      ,@NetworkSequence
      ,@NetworkSettlementDate1
      ,@NetworkSettlementDate2
      ,@NetworkData
      ,@AmountRequest
      ,@AmountAuthenticate
      ,@AmountDispense
      ,@AmountSurcharge
      ,@AmountDispenseDestination
      ,@AmountSurchargeDestination
      ,@AmountSurchargeWaived
      ,@AmountCashBack
      ,@AmountConvinience
      ,@SurchargeWaiveAuthorityId
      ,@CurrencyRequest
      ,@CurrencySource
      ,@CurrencyDestination
      ,@CurrencyDeviceRate
      ,@CurrencyNetworkRate
      ,@CustomerMediaDataHash
      ,@CustomerMediaDataEncrypted
      ,@CustomerMediaExpiryDate
      ,@AuthenticationNumber
      ,@ReferenceNumber
      ,@ApprovalCode
      ,@BatchId
      ,@BINGroup
      ,@SourceAccountType
      ,@DestinationAccountType
      ,@IssuerNetworkId
      ,@SourceDeviceName
      ,@CreatedUserId
      ,@SmartAcquierId
  )

  RETURN 0
END
GO
