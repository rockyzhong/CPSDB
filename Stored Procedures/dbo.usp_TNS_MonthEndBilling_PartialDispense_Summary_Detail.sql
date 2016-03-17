SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_TNS_MonthEndBilling_PartialDispense_Summary_Detail]
@pStartDate datetime,
@pEndDate datetime,
@pISOID int
AS
BEGIN
  SELECT
    d.TerminalName AS TerminalID,
    ISNULL(MAX(d.Location), '') AS LocationName,
    ISNULL(MAX(m.Make), '') AS Make,
    ISNULL(MAX(m.Model), '') AS Model,
    SUM(1) AS Approved,
    SUM(CASE WHEN t.TransactionType = 101 AND t.AmountSettlement-t.AmountSurcharge <> -1 * t.AmountRequest THEN 1 ELSE 0 END) AS Partials,
    CASE WHEN SUM(1) = 0 THEN '0.00%'
         ELSE CONVERT(nvarchar(20),CONVERT(money,SUM(CASE WHEN t.TransactionType = 101 AND t.AmountSettlement-t.AmountSurcharge <> -1 * t.AmountRequest THEN 1 ELSE 0 END)) * 100 / CONVERT(money,SUM(1))) + '%'
         END AS Percentage
  FROM dbo.tbl_trn_Transaction t
  JOIN dbo.tbl_Device      d ON d.Id=t.DeviceId
  JOIN dbo.tbl_DeviceModel m ON d.ModelId=m.Id
  WHERE t.SystemSettlementDate BETWEEN @pStartDate AND @pEndDate 
    AND d.IsoId = @pISOID 
    AND t.ResponseCodeInternal=0
    AND t.AmountSettlement-t.AmountSurcharge<>0
    AND t.IssuerNetworkId IN ('INT','BMO')
  GROUP BY d.TerminalName
  ORDER BY d.TerminalName
END
GO
