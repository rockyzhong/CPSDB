SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_TNS_MonthEndBilling_GetDisconnectFees]
@pStartDate datetime,
@pEndDate datetime
AS
SELECT iso.Id AS ISOID, iso.RegisteredName,ISNULL(ext.ExpenseAmount, 0) AS DisconnectFee
FROM dbo.tbl_Iso iso
LEFT  JOIN dbo.tbl_MonthEndBilling_Expenses_Tiers ext ON ext.IsoId = iso.Id AND ext.ExpenseType = 19
INNER JOIN dbo.tbl_MonthEndBilling_History mebh ON mebh.isoid = iso.Id AND mebh.StartDate = @pStartDate AND mebh.EndDate = @pEndDate
GROUP BY iso.Id, iso.Registeredname, ext.ExpenseAmount
ORDER BY iso.RegisteredName
GO
