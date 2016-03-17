SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/***/
/***/
/***/
CREATE PROCEDURE [dbo].[usp_dev_GetDeviceDayCloses]
@DeviceId   bigint,
@StartDate  datetime = NULL,
@EndDate    datetime = NULL,
@PageSize   bigint,
@PageNumber bigint,
@Count      bigint OUTPUT
AS
BEGIN
  IF @StartDate IS NULL SET @StartDate = CONVERT(datetime, '1900-01-01')
  IF @EndDate   IS NULL SET @EndDate   = CONVERT(datetime, '3999-12-31')

  DECLARE @StartRow bigint,@EndRow bigint
  SET @StartRow=(@PageNumber-1)*@PageSize+1
  SET @EndRow  =@PageNumber*@PageSize+1

  SELECT @Count=COUNT(*)
  FROM dbo.tbl_DeviceDayClose
  WHERE DeviceId = @DeviceId
    AND ClosedDate >= @StartDate
    AND ClosedDate < @EndDate + 1;
    
  WITH DeviceDayClose AS (
  SELECT DeviceId,ClosedDate,SettlementClosedDate,BatchID,WithdrawalCount,InquiryCount,TransferCount,DepositCount,StatementCount,
         DebitPurchaseCount,CreditPurchaseCount,PreAuthorizationCount,PreAuthorizationCompletionCount,DebitMerchandiseReturnCount,
         CreditMerchandiseReturnCount,VoidSaleCount,VoidMerchandiseReturnCount,ReversalWithdrawalCount+ReversalTransferCount+
         ReversalDepositCount+ReversalDebitPurchaseCount+ReversalCreditPurchaseCount+ReversalPreAuthorizationCount+
         ReversalPreAuthorizationCompletionCount+ReversalDebitMerchandiseReturnCount+ReversalCreditMerchandiseReturnCount+
         ReversalVoidSaleCount+ReversalVoidMerchandiseReturnCount AS ReversalCount,WithdrawalSum,DepositSum,DebitPurchaseSum,
         CreditPurchaseSum,PreAuthorizationCompletionSum,DebitMerchandiseReturnSum,CreditMerchandiseReturnSum,VoidSaleSum,
         VoidMerchandiseReturnSum,SurchargeSum,ConvinienceSum,
         ROW_NUMBER() OVER(ORDER BY ClosedDate DESC) AS RowNumber
  FROM dbo.tbl_DeviceDayClose
  WHERE DeviceId = @DeviceId
    AND ClosedDate >= @StartDate
    AND ClosedDate < @EndDate + 1
  )

  SELECT DeviceId,ClosedDate,SettlementClosedDate,BatchID,WithdrawalCount,InquiryCount,TransferCount,DepositCount,StatementCount,
         DebitPurchaseCount,CreditPurchaseCount,PreAuthorizationCount,PreAuthorizationCompletionCount,DebitMerchandiseReturnCount,
         CreditMerchandiseReturnCount,VoidSaleCount,VoidMerchandiseReturnCount,ReversalCount,WithdrawalSum,DepositSum,DebitPurchaseSum,
         CreditPurchaseSum,PreAuthorizationCompletionSum,DebitMerchandiseReturnSum,CreditMerchandiseReturnSum,VoidSaleSum,
         VoidMerchandiseReturnSum,SurchargeSum,ConvinienceSum
  FROM DeviceDayClose WHERE RowNumber>=@StartRow AND RowNumber<@EndRow ORDER BY ClosedDate DESC
END
GO
