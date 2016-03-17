SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[usp_dev_InsertDeviceDayClose]
@TerminalName         nvarchar(50),
@ClosedDate           datetime,
@SmartAcquireId       bigint
AS
BEGIN
  SET NOCOUNT ON

  DECLARE @DeviceId bigint
  SELECT @DeviceId=Id FROM dbo.tbl_Device WHERE TerminalName=@TerminalName

  DECLARE @OpenedDate datetime,@SettlementOpenedDate datetime
  SELECT @OpenedDate=MAX(ClosedDate),@SettlementOpenedDate=MAX(SettlementClosedDate) FROM dbo.tbl_DeviceDayClose WHERE ClosedDate>DATEADD(yy,-1,GETUTCDATE()) AND DeviceId=@DeviceId
  IF @OpenedDate           IS NULL  SET @OpenedDate          =CONVERT(datetime,'20130101',112)
  IF @SettlementOpenedDate IS NULL  SET @SettlementOpenedDate=CONVERT(datetime,'20130101',112)

  INSERT INTO dbo.tbl_DeviceDayClose(DeviceId,OpenedDate,ClosedDate,SettlementOpenedDate,SettlementClosedDate,BatchId,
  WithdrawalCount,InquiryCount,TransferCount,DepositCount,StatementCount,DebitPurchaseCount,CreditPurchaseCount,PreAuthorizationCount,
  PreAuthorizationCompletionCount,DebitMerchandiseReturnCount,CreditMerchandiseReturnCount,VoidSaleCount,VoidMerchandiseReturnCount,
  ReversalWithdrawalCount,ReversalTransferCount,ReversalDepositCount,ReversalDebitPurchaseCount,ReversalCreditPurchaseCount,
  ReversalPreAuthorizationCount,ReversalPreAuthorizationCompletionCount,ReversalDebitMerchandiseReturnCount,ReversalCreditMerchandiseReturnCount,
  ReversalVoidSaleCount,ReversalVoidMerchandiseReturnCount,WithdrawalSum,DepositSum,DebitPurchaseSum,CreditPurchaseSum,PreAuthorizationCompletionSum,
  DebitMerchandiseReturnSum,CreditMerchandiseReturnSum,VoidSaleSum,VoidMerchandiseReturnSum,ReversalWithdrawalSum,ReversalDepositSum,
  ReversalDebitPurchaseSum,ReversalCreditPurchaseSum,ReversalPreAuthorizationCompletionSum,ReversalDebitMerchandiseReturnSum,
  ReversalCreditMerchandiseReturnSum,ReversalVoidSaleSum,ReversalVoidMerchandiseReturnSum,SurchargeSum,ConvinienceSum)
  SELECT @DeviceId,@OpenedDate,@ClosedDate,@SettlementOpenedDate,MAX(SystemSettlementDate),BatchId,
  SUM(CASE WHEN TransactionType=1     THEN 1 ELSE 0 END) AS WithdrawalCount,
  SUM(CASE WHEN TransactionType=2     THEN 1 ELSE 0 END) AS InquiryCount,
  SUM(CASE WHEN TransactionType=3     THEN 1 ELSE 0 END) AS TransferCount,
  SUM(CASE WHEN TransactionType=4     THEN 1 ELSE 0 END) AS DepositCount,
  SUM(CASE WHEN TransactionType=5     THEN 1 ELSE 0 END) AS StatementCount,
  SUM(CASE WHEN TransactionType=7     AND TransactionFlags & 0x00080000  = 0 THEN 1 ELSE 0 END) AS DebitPurchaseCount,
  SUM(CASE WHEN TransactionType=7     AND TransactionFlags & 0x00080000 <> 0 THEN 1 ELSE 0 END) AS CreditPurchaseCount,
  SUM(CASE WHEN TransactionType=8     THEN 1 ELSE 0 END) AS PreAuthorizationCount,
  SUM(CASE WHEN TransactionType=9     THEN 1 ELSE 0 END) AS PreAuthorizationCompletionCount,
  SUM(CASE WHEN TransactionType=10    AND TransactionFlags & 0x00080000  = 0 THEN 1 ELSE 0 END) AS DebitMerchandiseReturnCount,
  SUM(CASE WHEN TransactionType=10    AND TransactionFlags & 0x00080000 <> 0 THEN 1 ELSE 0 END) AS CreditMerchandiseReturnCount,
  SUM(CASE WHEN TransactionType=11    THEN 1 ELSE 0 END) AS VoidSaleCount,
  SUM(CASE WHEN TransactionType=12    THEN 1 ELSE 0 END) AS VoidMerchandiseReturnCount,
  SUM(CASE WHEN TransactionType=101   THEN 1 ELSE 0 END) AS ReversalWithdrawalCount,
  SUM(CASE WHEN TransactionType=103   THEN 1 ELSE 0 END) AS ReversalTransferCount,
  SUM(CASE WHEN TransactionType=104   THEN 1 ELSE 0 END) AS ReversalDepositCount,
  SUM(CASE WHEN TransactionType=107   AND TransactionFlags & 0x00080000  = 0 THEN 1 ELSE 0 END) AS ReversalDebitPurchaseCount,
  SUM(CASE WHEN TransactionType=107   AND TransactionFlags & 0x00080000 <> 0 THEN 1 ELSE 0 END) AS ReversalCreditPurchaseCount,
  SUM(CASE WHEN TransactionType=108   THEN 1 ELSE 0 END) AS ReversalPreAuthorizationCount,
  SUM(CASE WHEN TransactionType=109   THEN 1 ELSE 0 END) AS ReversalPreAuthorizationCompletionCount,
  SUM(CASE WHEN TransactionType=110   AND TransactionFlags & 0x00080000  = 0 THEN 1 ELSE 0 END) AS ReversalDebitMerchandiseReturnCount,
  SUM(CASE WHEN TransactionType=110   AND TransactionFlags & 0x00080000 <> 0 THEN 1 ELSE 0 END) AS ReversalCreditMerchandiseReturnCount,
  SUM(CASE WHEN TransactionType=111   THEN 1 ELSE 0 END) AS ReversalVoidSaleCount,
  SUM(CASE WHEN TransactionType=112   THEN 1 ELSE 0 END) AS ReversalVoidMerchandiseReturnCount,
  SUM(CASE WHEN TransactionType=1     THEN AmountSettlement-AmountSurcharge ELSE 0 END) AS WithdrawalSum,
  SUM(CASE WHEN TransactionType=4     THEN AmountSettlement-AmountSurcharge ELSE 0 END) AS DepositSum,
  SUM(CASE WHEN TransactionType=7     AND TransactionFlags & 0x00080000  = 0 THEN AmountSettlement-AmountSurcharge ELSE 0 END) AS DebitPurchaseSum,
  SUM(CASE WHEN TransactionType=7     AND TransactionFlags & 0x00080000 <> 0 THEN AmountSettlement-AmountSurcharge ELSE 0 END) AS CreditPurchaseSum,
  SUM(CASE WHEN TransactionType=9     THEN AmountSettlement-AmountSurcharge ELSE 0 END) AS PreAuthorizationCompletionSum,
  SUM(CASE WHEN TransactionType=10    AND TransactionFlags & 0x00080000  = 0 THEN AmountSettlement-AmountSurcharge ELSE 0 END) AS DebitMerchandiseReturnSum, 
  SUM(CASE WHEN TransactionType=10    AND TransactionFlags & 0x00080000 <> 0 THEN AmountSettlement-AmountSurcharge ELSE 0 END) AS CreditMerchandiseReturnSum,
  SUM(CASE WHEN TransactionType=11    THEN AmountSettlement-AmountSurcharge ELSE 0 END) AS VoidSaleSum,
  SUM(CASE WHEN TransactionType=12    THEN AmountSettlement-AmountSurcharge ELSE 0 END) AS VoidMerchandiseReturnSum,
  SUM(CASE WHEN TransactionType=101   THEN AmountSettlement-AmountSurcharge ELSE 0 END) AS ReversalWithdrawalSum,
  SUM(CASE WHEN TransactionType=104   THEN AmountSettlement-AmountSurcharge ELSE 0 END) AS ReversalDepositSum,
  SUM(CASE WHEN TransactionType=107   AND TransactionFlags & 0x00080000  = 0 THEN AmountSettlement-AmountSurcharge ELSE 0 END) AS ReversalDebitPurchaseSum,
  SUM(CASE WHEN TransactionType=107   AND TransactionFlags & 0x00080000 <> 0 THEN AmountSettlement-AmountSurcharge ELSE 0 END) AS ReversalCreditPurchaseSum,
  SUM(CASE WHEN TransactionType=109   THEN AmountSettlement-AmountSurcharge ELSE 0 END) AS ReversalPreAuthorizationCompletionSum,
  SUM(CASE WHEN TransactionType=110   AND TransactionFlags & 0x00080000  = 0 THEN AmountSettlement-AmountSurcharge ELSE 0 END) AS ReversalDebitMerchandiseReturnSum,
  SUM(CASE WHEN TransactionType=110   AND TransactionFlags & 0x00080000 <> 0 THEN AmountSettlement-AmountSurcharge ELSE 0 END) AS ReversalCreditMerchandiseReturnSum,  
  SUM(CASE WHEN TransactionType=111   THEN AmountSettlement-AmountSurcharge ELSE 0 END) AS ReversalVoidSaleSum,
  SUM(CASE WHEN TransactionType=112   THEN AmountSettlement-AmountSurcharge ELSE 0 END) AS ReversalVoidMerchandiseReturnSum,
  SUM(AmountSurcharge) AS SurchargeSum,
  SUM(AmountConvinience) AS ConvinienceSum
  FROM dbo.tbl_trn_Transaction WHERE SystemDate>=@OpenedDate AND SystemDate<@ClosedDate AND DeviceId=@DeviceId
  GROUP BY BatchId
  
  --SELECT * FROM dbo.tbl_DeviceDayClose WHERE ClosedDate=@ClosedDate AND DeviceId=@DeviceId
  -- Add update command for Smart Acquirer ID 

   --INSERT INTO tbl_DeviceUpdateCommands
   --SELECT @UpdatedUserId, GETUTCDATE(), 'Sptermapp\loadterm ' + convert(varchar(20), TerminalName)
   --FROM tbl_Device WHERE Id = @DeviceId 
END
GO
GRANT EXECUTE ON  [dbo].[usp_dev_InsertDeviceDayClose] TO [WebV4Role]
GO
