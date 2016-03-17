SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_TNS_MonthEndBilling_History_Get]
@pStartDate datetime,
@pEndDate datetime,
@pISOID int = -1
AS
BEGIN
  SELECT mebh.EntryID, mebh.ISOID, iso.RegisteredName,
    mebh.EntryType, mebh.ExpenseType, mebh.APIType,
    mebh.StatementOrder, mebh.StatementLabel1, mebh.StatementLabel2,
    mebh.ItemCount, mebh.Rate, mebh.TotalAmount, mebh.Taxable
  FROM dbo.tbl_MonthEndBilling_History mebh
  JOIN dbo.tbl_Iso iso ON iso.id = mebh.ISOID
  WHERE mebh.StartDate = @pStartDate
    AND mebh.EndDate = @pEndDate
    AND mebh.ISOID = @pISOID
  ORDER BY iso.RegisteredName, mebh.EntryType, mebh.APIType, mebh.StatementOrder
END
GO
