SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_TNS_VISATransactionFees_Load]
@paramStartDate datetime,
@paramEndDate datetime
AS
BEGIN
  SET NOCOUNT ON

  DELETE FROM dbo.tbl_MonthEndBilling_VISATransactionFees
  WHERE StartDate = @paramStartDate
    AND EndDate = @paramEndDate

  INSERT INTO dbo.tbl_MonthEndBilling_VISATransactionFees
  (StartDate,EndDate,DeviceId,VISATransCount,VISASettlementAmt,VISASurchargeAmt,VISATotalAmt,VISAPct,VISAFee)
  SELECT 
    @paramStartDate AS StartDate,
    @paramEndDate AS EndDate,
    t.DeviceId,
    COUNT(*) AS VISATransCount,
    CONVERT(money,SUM(t.AmountSettlement - t.AmountSurcharge))/100 AS VISASettlementAmt,
    CONVERT(money,SUM(t.AmountSurcharge))/100 AS VISASurchargeAmt,
    CONVERT(money,SUM(t.AmountSettlement))/100 AS VISATotalAmt,
    CONVERT(money, 0.0020) AS VISAPct,
    ROUND(CONVERT(money,SUM(t.AmountSettlement))/100 * CONVERT(money, 0.0020), 2) AS VISAFee
  FROM dbo.tbl_trn_Transaction t
  WHERE t.SystemSettlementDate >= @paramStartDate
    AND t.SystemSettlementDate <= @paramEndDate
    AND t.IssuerNetworkId IN ('SM1', 'PL1', 'VI1')
    AND t.TransactionType NOT IN (2,3,4)
    AND t.AmountSettlement - t.AmountSurcharge <> 0
    AND t.ResponseCodeInternal<>-99
  GROUP BY t.DeviceId
END
GO
