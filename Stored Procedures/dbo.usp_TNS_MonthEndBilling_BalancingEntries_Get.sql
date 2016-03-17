SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_TNS_MonthEndBilling_BalancingEntries_Get]
@pStartDate datetime,
@pEndDate datetime,
@pISOID int = -1
AS
BEGIN
  SELECT be.ISOID, iso.RegisteredName, be.TotalInterchangePayable,
    be.TotalExpensesChargeable, be.NetRevenueToISO, be.TaxRegionID,
    rg.RegionShortName, be.TaxName, be.TaxPct, be.TaxAmount,
    be.NetRevenueAfterTax, be.AmountPaidDaily, be.BalanceToISO
  FROM dbo.tbl_MonthEndBilling_BalancingEntries be
  JOIN dbo.tbl_Iso iso ON iso.Id = be.ISOID
  LEFT JOIN dbo.tbl_Region rg ON rg.Id = be.TaxRegionID
  WHERE be.StartDate = @pStartDate
    AND be.EndDate = @pEndDate
    AND be.ISOID = @pISOID
  ORDER BY iso.RegisteredName
END
GO
