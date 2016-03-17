SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[usp_TNS_MCITransactionFees_Load]
@paramStartDate datetime,
@paramEndDate datetime
AS
BEGIN
  SET NOCOUNT ON

  DELETE FROM dbo.tbl_MonthEndBilling_MCITransactionFees
  WHERE StartDate = @paramStartDate
    AND EndDate = @paramEndDate

  INSERT INTO dbo.tbl_MonthEndBilling_MCITransactionFees
  (StartDate,EndDate,DeviceId,MCITransCount,MCISettlementAmt,MCISurchargeAmt,MCITotalAmt,MCIPct,MCIFee)
  SELECT 
    @paramStartDate AS StartDate,
    @paramEndDate AS EndDate,
    t.DeviceId,
    COUNT(*) AS MCITransCount,
    CONVERT(money,SUM(t.AmountSettlement - t.AmountSurcharge))/100 AS MCISettlementAmt,
    CONVERT(money,SUM(t.AmountSurcharge))/100 AS MCISurchargeAmt,
    CONVERT(money,SUM(t.AmountSettlement))/100 AS MCITotalAmt,
    CASE WHEN MAX(d.IsoId) = 180              THEN CONVERT(money, 0.0050)
         WHEN @paramStartDate >= '2009-10-17' THEN CONVERT(money, 0.0040) 
         ELSE CONVERT(money, 0.0030) 
         END AS MCIPct,
    ROUND(CONVERT(money,SUM(t.AmountSettlement))/100 * 
         (CASE WHEN MAX(d.IsoId) = 180              THEN CONVERT(money, 0.0050)
               WHEN @paramStartDate >= '2009-10-17' THEN CONVERT(money, 0.0040)
               ELSE CONVERT(money, 0.0030)
               END), 2) AS MCIFee
  FROM dbo.tbl_trn_Transaction t
  JOIN dbo.tbl_Device d ON d.Id=t.DeviceId
  WHERE t.SystemSettlementDate >= @paramStartDate
    AND t.SystemSettlementDate <= @paramEndDate
    AND t.IssuerNetworkId IN ('CI1', 'MS1', 'MC1')
    AND t.TransactionType NOT IN (2,3,4)
    AND t.AmountSettlement - t.AmountSurcharge <> 0
    AND t.ResponseCodeInternal <> -99
  GROUP BY t.DeviceId
END
GO
