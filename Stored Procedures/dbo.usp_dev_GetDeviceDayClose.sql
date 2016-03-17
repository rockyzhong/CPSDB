SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_dev_GetDeviceDayClose]
@DeviceId   bigint,
@ClosedDate DateTime
AS
BEGIN
  SELECT DeviceId,ClosedDate,SettlementClosedDate,BatchID,WithdrawalCount,InquiryCount,TransferCount,DepositCount,StatementCount,
         DebitPurchaseCount,CreditPurchaseCount,PreAuthorizationCount,PreAuthorizationCompletionCount,DebitMerchandiseReturnCount,
         CreditMerchandiseReturnCount,VoidSaleCount,VoidMerchandiseReturnCount,ReversalWithdrawalCount+ReversalTransferCount+
         ReversalDepositCount+ReversalDebitPurchaseCount+ReversalCreditPurchaseCount+ReversalPreAuthorizationCount+
         ReversalPreAuthorizationCompletionCount+ReversalDebitMerchandiseReturnCount+ReversalCreditMerchandiseReturnCount+
         ReversalVoidSaleCount+ReversalVoidMerchandiseReturnCount AS ReversalCount,WithdrawalSum,DepositSum,DebitPurchaseSum,
         CreditPurchaseSum,PreAuthorizationCompletionSum,DebitMerchandiseReturnSum,CreditMerchandiseReturnSum,VoidSaleSum,
         VoidMerchandiseReturnSum,SurchargeSum,ConvinienceSum
  FROM dbo.tbl_DeviceDayClose
  WHERE DeviceId = @DeviceId
    AND ClosedDate=@ClosedDate
END
GO
