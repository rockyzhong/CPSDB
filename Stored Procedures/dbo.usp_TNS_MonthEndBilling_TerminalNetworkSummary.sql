SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[usp_TNS_MonthEndBilling_TerminalNetworkSummary]
@paramStartDate datetime,
@paramEndDate datetime,
@paramISOID int,
@paramAPIType int = 0
AS
BEGIN
  SELECT d.TerminalName AS TerminalID,
  CONVERT(money,SUM(CASE WHEN t.TransactionType NOT IN (2,3,4) AND t.AmountSettlement-t.AmountSurcharge<>0 THEN t.AmountSettlement-t.AmountSurcharge ELSE 0 END))/100 AS Settlement,
  CONVERT(money,SUM(CASE WHEN t.TransactionType NOT IN (2,3,4) AND t.AmountSettlement-t.AmountSurcharge<>0 THEN t.AmountSurcharge ELSE 0 END))/100 AS Surcharge,
  CONVERT(money,SUM(CASE WHEN t.TransactionType NOT IN (2,3,4) AND t.AmountSettlement-t.AmountSurcharge<>0 THEN t.AmountSettlement ELSE 0 END))/100 AS CompAmt,
  SUM(CASE WHEN t.TransactionType NOT IN (2,3,4) AND t.AmountSettlement-t.AmountSurcharge<>0 THEN 1 ELSE 0 END) AS Approved,
  SUM(CASE WHEN t.TransactionType NOT IN (2,3,4) AND t.AmountSettlement-t.AmountSurcharge<>0 AND t.IssuerNetworkId IN ('INT', 'RBC', 'KEB') THEN 1 ELSE 0 END) AS Interac,
  SUM(CASE WHEN t.TransactionType NOT IN (2,3,4) AND t.AmountSettlement-t.AmountSurcharge<>0 AND t.IssuerNetworkId IN ('BMO') THEN 1 ELSE 0 END) AS BOM,
  SUM(CASE WHEN t.TransactionType NOT IN (2,3,4) AND t.AmountSettlement-t.AmountSurcharge<>0 AND t.IssuerNetworkId IN ('MON') THEN 1 ELSE 0 END) AS Circuit,
  SUM(CASE WHEN t.TransactionType NOT IN (2,3,4) AND t.AmountSettlement-t.AmountSurcharge<>0 AND t.IssuerNetworkId IN ('CI0', 'MC0', 'MS0') THEN 1 ELSE 0 END) AS CirrusDom,
  SUM(CASE WHEN t.TransactionType NOT IN (2,3,4) AND t.AmountSettlement-t.AmountSurcharge<>0 AND t.IssuerNetworkId IN ('CI1', 'MC1', 'MS1') THEN 1 ELSE 0 END) AS CirrusIntl,
  SUM(CASE WHEN t.TransactionType NOT IN (2,3,4) AND t.AmountSettlement-t.AmountSurcharge<>0 AND t.IssuerNetworkId IN ('SM0', 'PL0') THEN 1 ELSE 0 END) AS PLUSDom,
  SUM(CASE WHEN t.TransactionType NOT IN (2,3,4) AND t.AmountSettlement-t.AmountSurcharge<>0 AND t.IssuerNetworkId IN ('SM1', 'PL1') THEN 1 ELSE 0 END) AS PLUSIntl,
  SUM(CASE WHEN t.TransactionType NOT IN (2,3,4) AND t.AmountSettlement-t.AmountSurcharge<>0 AND t.IssuerNetworkId IN ('STR') THEN 1 ELSE 0 END) AS STAR,
  SUM(CASE WHEN t.TransactionType NOT IN (2,3,4) AND t.AmountSettlement-t.AmountSurcharge<>0 AND t.IssuerNetworkId IN ('CUP', 'CUR', 'PUL') THEN 1 ELSE 0 END) AS ChinaUnionPay,
  SUM(CASE WHEN t.TransactionType NOT IN (2,3,4) AND t.AmountSettlement-t.AmountSurcharge<>0 AND t.IssuerNetworkId NOT IN ('INT', 'RBC', 'KEB', 'BMO', 'MON','CI0', 'SM0', 'PL0', 'MC0', 'MS0', 'CI1', 'SM1', 'PL1', 'MC1', 'MS1', 'STR', 'CUP', 'CUR', 'PUL') 
 
THEN 1 ELSE 0 END) AS Other,
  CONVERT(money,SUM(ISNULL(tf.AmountInterchange,0)))/100 AS ICColl,
  CONVERT(money,SUM(ISNULL(tf.AmountInterchangePaid,0)))/100 AS ICPaid,
  CONVERT(money,SUM(ISNULL(tf.AmountInterchange,0)-ISNULL(tf.AmountInterchangePaid,0)))/100 AS ICMargin,
  i.RegisteredName AS ISOName
  FROM dbo.tbl_trn_Transaction t
  JOIN dbo.tbl_Device d ON d.Id=t.DeviceId
  JOIN dbo.tbl_Iso    i ON i.Id=d.IsoId
  LEFT JOIN dbo.tbl_trn_TransactionAmountInter tf ON t.Id=tf.TranId 
  WHERE t.SystemSettlementDate between @paramStartDate AND @paramEndDate
    AND d.TerminalName NOT LIKE 'TNSA%'
    AND d.IsoId = @paramISOID
    AND (@paramAPIType = 0
     OR (@paramAPIType = 50 AND t.BatchID LIKE '50:%')
     OR (@paramAPIType = 1  AND t.BatchID LIKE '1:%')
     OR (@paramAPIType = 51 AND (t.BatchID LIKE '51:%' OR t.BatchID LIKE '53:%'
         OR t.BatchID LIKE '99:%' OR t.BatchID LIKE '100:%'
         OR t.BatchID LIKE '101:%' OR t.BatchID LIKE '9191:%'))
     OR (@paramAPIType = 6707 AND (t.BatchID LIKE '6707:%' OR t.BatchID LIKE '7708:%'
         OR t.BatchID LIKE '8787:%' OR t.BatchID LIKE '9796:%' OR t.BatchID LIKE '9797:%'
         OR t.BatchID LIKE '9898:%'))
        )
  GROUP BY i.RegisteredName,d.TerminalName
  ORDER BY i.RegisteredName,d.TerminalName
END

GO
