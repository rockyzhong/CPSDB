SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

 
CREATE PROCEDURE [dbo].[usp_TNS_MonthEndBilling_BalancingEntries_Load]
@pStartDate datetime,
@pEndDate datetime
AS
BEGIN
  SET NOCOUNT ON

  DELETE FROM dbo.tbl_MonthEndBilling_BalancingEntries
  WHERE StartDate = @pStartDate AND EndDate = @pEndDate

  DECLARE @tblInterchangePayableTotal TABLE (ISOID int PRIMARY KEY, InterchangePayableTotal money)
  
  INSERT INTO @tblInterchangePayableTotal
  SELECT ISOID, sum(TotalAmount)
  FROM dbo.tbl_MonthEndBilling_History
  WHERE StartDate = @pStartDate AND EndDate = @pEndDate AND EntryType = 0
  GROUP BY ISOID

  DECLARE @tblExpensesTotal TABLE (ISOID int PRIMARY KEY,
    ExpensesChargeable money, TaxRegionID int, TaxName varchar(20),
    TaxPct money, TaxAmount money)

  INSERT INTO @tblExpensesTotal
  SELECT mebh.ISOID, sum(mebh.TotalAmount), max(addr.RegionId), max(tax.TaxName), max(tax.TaxPercent),
    round(sum(CASE WHEN mebh.Taxable > 0 THEN mebh.TotalAmount ELSE 0 END) * ISNULL(max(tax.TaxPercent)/100, 0), 2) AS TaxAmount
  FROM dbo.tbl_MonthEndBilling_History mebh
  JOIN dbo.tbl_Iso isor ON isor.Id = mebh.IsoId
  LEFT JOIN dbo.tbl_IsoAddress isoa ON isoa.IsoId = mebh.IsoId AND isoa.IsoAddressType=1 AND mebh.Taxable > 0
  LEFT JOIN dbo.tbl_Address    addr ON addr.Id =isoa.AddressId
  LEFT JOIN tbl_RegionTax      tax  ON tax.RegionId = addr.RegionId
  WHERE StartDate = @pStartDate AND EndDate = @pEndDate
    AND EntryType = 1
  GROUP BY mebh.ISOID

  DECLARE @tblDailyPayouts TABLE (ISOID int PRIMARY KEY, AmountPaidDaily money)

  INSERT INTO @tblDailyPayouts
  SELECT d.IsoId, CONVERT(money,sum(tf.AmountInterchangePaid))/100
  FROM dbo.tbl_trn_Transaction ts
  LEFT JOIN dbo.tbl_trn_TransactionAmountInter tf ON ts.Id=tf.TranId
  JOIN dbo.tbl_Device d ON d.Id=ts.DeviceId
  WHERE ts.SystemSettlementDate BETWEEN @pStartDate AND @pEndDate
  GROUP BY d.IsoId

  INSERT INTO dbo.tbl_MonthEndBilling_BalancingEntries
  (
    StartDate,
    EndDate,
    ISOID,
    TotalInterchangePayable,
    TotalExpensesChargeable,
    NetRevenueToISO,
    TaxRegionID,
    TaxName,
    TaxPct,
    TaxAmount,
    NetRevenueAfterTax,
    AmountPaidDaily,
    BalanceToISO
  )
  SELECT @pStartDate, @pEndDate, intrp.ISOID,
    ISNULL(intrp.InterchangePayableTotal,0) AS TotalInterchangePayable,
    ISNULL(expt.ExpensesChargeable, 0) AS TotalExpensesChargeable,
    ISNULL(intrp.InterchangePayableTotal,0) - ISNULL(expt.ExpensesChargeable, 0) AS NetRevenueToISO,
    ISNULL(expt.TaxRegionID, 0) AS TaxRegionID,
    ISNULL(expt.TaxName, '') AS TaxName,
    ISNULL(expt.TaxPct, 0) AS TaxPct,
    ISNULL(expt.TaxAmount, 0) AS TaxAmount,
    ISNULL(intrp.InterchangePayableTotal,0) - ISNULL(expt.ExpensesChargeable, 0)
      - ISNULL(expt.TaxAmount, 0) AS NetRevenueAfterTax,
    ISNULL(dly.AmountPaidDaily, 0) AS AmountPaidDaily,
    ISNULL(intrp.InterchangePayableTotal,0) - ISNULL(expt.ExpensesChargeable, 0)
      - ISNULL(expt.TaxAmount, 0) - ISNULL(dly.AmountPaidDaily, 0) AS BalanceToISO
  FROM @tblInterchangePayableTotal intrp
  LEFT JOIN @tblExpensesTotal expt
  ON expt.ISOID = intrp.ISOID
  LEFT JOIN @tblDailyPayouts dly
  ON dly.ISOID = intrp.ISOID
END

GO
