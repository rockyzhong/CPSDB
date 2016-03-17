SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[usp_TNS_MonthEndBilling_History_Load]
@pStartDate datetime,
@pEndDate datetime
AS
SET NOCOUNT ON

-- Load Total Count History table for Tiering purposes
DELETE FROM dbo.tbl_MonthEndBilling_TotalCount_History
WHERE StartDate = @pStartDate AND EndDate = @pEndDate

INSERT INTO dbo.tbl_MonthEndBilling_TotalCount_History(StartDate, EndDate, IsoId, TotalCount)
SELECT @pStartDate, @pEndDate, d.IsoId, SUM(CASE WHEN ts.TransactionType NOT IN (2,3,4) AND ts.AmountSettlement-ts.AmountSurcharge<>0 THEN 1 ELSE 0 END)
FROM dbo.tbl_trn_Transaction ts
JOIN dbo.tbl_Device d ON d.Id=ts.DeviceId
WHERE ts.SystemSettlementDate BETWEEN @pStartDate AND @pEndDate
GROUP BY d.IsoId

DELETE FROM dbo.tbl_MonthEndBilling_History
WHERE StartDate = @pStartDate AND EndDate = @pEndDate


-- Per Transaction Interchange for Dialup & IP ISOs
DECLARE @MaxEntryID int
SELECT @MaxEntryID = ISNULL(max(EntryID), 0) FROM dbo.tbl_MonthEndBilling_History

INSERT INTO dbo.tbl_MonthEndBilling_History
(
  EntryID, StartDate, EndDate, IsoId, EntryType, ExpenseType,
  APIType, StatementOrder, StatementLabel1, StatementLabel2, 
  ItemCount, Rate, Taxable
)
SELECT 
  @MaxEntryID + ROW_NUMBER() OVER (ORDER BY ict.ISOID ASC, ict.StatementOrder ASC) AS EntryID,
  @pStartDate, @pEndDate, ict.IsoId, 0, 1,
  (CASE WHEN charindex(':', ts.BatchID) <= 1 THEN 0 
        WHEN substring(ts.BatchID, 1, charindex(':', ts.BatchID) - 1) IN ('51', '53') THEN 51 
        ELSE 0
        END) AS APIType,
  ict.StatementOrder, ict.StatementLabel, '' AS StatementLabel2,
  SUM(CASE WHEN ts.TransactionType IN (1,101) AND ts.AmountSettlement-ts.AmountSurcharge<>0 THEN 1
           WHEN ts.TransactionType IN (2,3)   AND ts.ResponseCodeInternal = 0 THEN 1
           ELSE 0 
           END) AS ItemCount,
  ROUND(ict.InterchangeAmount * exr.ExchangeRate, 2) AS ItemAmount,
  0 AS Taxable
FROM dbo.tbl_trn_Transaction ts
JOIN dbo.tbl_Device d ON d.Id=ts.DeviceId
JOIN dbo.tbl_MonthEndBilling_Interchange_Tiers ict
  ON ict.IsoId = d.IsoId AND ict.NetworkCode = REPLACE(REPLACE(ts.IssuerNetworkId, 'VI1', 'SM1'), 'PL1', 'SM1')
 AND ict.TranType = REPLACE(dbo.udf_GetValueName(19,ts.TransactionType),'RWT','WTH')
JOIN dbo.tbl_MonthEndBilling_TotalCount_History tch
  ON tch.StartDate = @pStartDate AND tch.EndDate = @pEndDate
 AND tch.IsoId = d.IsoId AND ict.MinTransactions <= tch.TotalCount
 AND (ict.MaxTransactions < 0 OR ict.MaxTransactions >= tch.TotalCount)
JOIN dbo.tbl_MonthEndBilling_ExchangeRate exr
  ON exr.FromCurrencyCode = ict.CurrencyCode AND exr.ToCurrencyCode = 124
WHERE ts.SystemSettlementDate BETWEEN @pStartDate AND @pEndDate
  AND ict.IsoId IN (SELECT DISTINCT IsoId FROM dbo.tbl_MonthEndBilling_Expenses_Tiers WHERE StatementLabel1 LIKE '%(Dial-up & IP)%')
GROUP BY ict.IsoId, ict.StatementOrder, ict.StatementLabel, ict.InterchangeAmount,exr.ExchangeRate, 
         (CASE WHEN charindex(':', ts.BatchID) <= 1 THEN 0
               WHEN substring(ts.BatchID, 1, charindex(':', ts.BatchID) - 1) IN ('51', '53') THEN 51
               ELSE 0
               END)


-- Per Transaction Interchange for Dialup Only Comm-Charge ISOs
SELECT @MaxEntryID = ISNULL(max(EntryID), 0) FROM dbo.tbl_MonthEndBilling_History

INSERT INTO dbo.tbl_MonthEndBilling_History
(
  EntryID, StartDate, EndDate, IsoId, EntryType, ExpenseType,
  APIType, StatementOrder, StatementLabel1, StatementLabel2, 
  ItemCount, Rate, Taxable
)
SELECT
  @MaxEntryID + ROW_NUMBER() OVER (ORDER BY ict.ISOID ASC, ict.StatementOrder ASC) AS EntryID,
  @pStartDate, @pEndDate, ict.IsoId, 0, 1,
  (CASE WHEN charindex(':', ts.BatchID) <= 1 THEN 50
        WHEN substring(ts.BatchID, 1, charindex(':', ts.BatchID) - 1) <> '50' THEN 150
        ELSE 50
        END) AS APIType,
  ict.StatementOrder, ict.StatementLabel, '' AS StatementLabel2,
  SUM(CASE WHEN ts.TransactionType IN (1,101) AND ts.AmountSettlement-ts.AmountSurcharge<>0 THEN 1
           WHEN ts.TransactionType IN (2,3)   AND ts.ResponseCodeInternal = 0 THEN 1
           ELSE 0
           END) AS ItemCount,
  ROUND(ict.InterchangeAmount * exr.ExchangeRate, 2) AS ItemAmount,
  0 AS Taxable
FROM dbo.tbl_trn_Transaction ts
JOIN dbo.tbl_Device d ON d.Id=ts.DeviceId
JOIN dbo.tbl_MonthEndBilling_Interchange_Tiers ict
  ON ict.IsoId = d.IsoId AND ict.NetworkCode = REPLACE(REPLACE(ts.IssuerNetworkId, 'VI1', 'SM1'), 'PL1', 'SM1')
 AND ict.TranType = REPLACE(dbo.udf_GetValueName(19,ts.TransactionType),'RWT','WTH')
JOIN dbo.tbl_MonthEndBilling_TotalCount_History tch
  ON tch.StartDate = @pStartDate AND tch.EndDate = @pEndDate
 AND tch.IsoId = d.IsoId AND ict.MinTransactions <= tch.TotalCount
 AND (ict.MaxTransactions < 0 OR ict.MaxTransactions >= tch.TotalCount)
JOIN dbo.tbl_MonthEndBilling_ExchangeRate exr
  ON exr.FromCurrencyCode = ict.CurrencyCode AND exr.ToCurrencyCode = 124
WHERE ts.SystemSettlementDate BETWEEN @pStartDate AND @pEndDate
  AND ict.IsoId NOT IN (SELECT DISTINCT IsoId FROM dbo.tbl_MonthEndBilling_Expenses_Tiers WHERE StatementLabel1 LIKE '%(Dial-up & IP)%')
GROUP BY ict.IsoId, ict.StatementOrder, ict.StatementLabel, ict.InterchangeAmount, exr.ExchangeRate, 
         (CASE WHEN charindex(':', ts.BatchID) <= 1 THEN 50
               WHEN substring(ts.BatchID, 1, charindex(':', ts.BatchID) - 1) <> '50' THEN 150
               ELSE 50
               END)


-- Per Transaction Expenses
SELECT @MaxEntryID = ISNULL(max(EntryID), 0) FROM dbo.tbl_MonthEndBilling_History

INSERT INTO dbo.tbl_MonthEndBilling_History
(
  EntryID, StartDate, EndDate, IsoId, EntryType, ExpenseType,
  APIType, StatementOrder, StatementLabel1, StatementLabel2, 
  ItemCount, Rate, Taxable
)
SELECT 
  @MaxEntryID + ROW_NUMBER() OVER (ORDER BY ext.ISOID ASC, ext.StatementOrder ASC) AS EntryID,
  @pStartDate, @pEndDate, ext.IsoId, 1, ext.ExpenseType, 0, 
  ext.StatementOrder, ext.StatementLabel1, ext.StatementLabel2,
  (CASE WHEN ext.ApprDeclCode = 1 THEN SUM(CASE WHEN ts.TransactionType NOT IN (2,3,4) AND ts.AmountSettlement-ts.AmountSurcharge<>0 THEN 1 ELSE 0 END)
        WHEN ext.ApprDeclCode = 2 THEN SUM(1) - SUM(CASE WHEN ts.TransactionType NOT IN (2,3,4) AND ts.AmountSettlement-ts.AmountSurcharge<>0 THEN 1 ELSE 0 END)
        ELSE SUM(1)
        END) AS ItemCount,
  ROUND(ext.ExpenseAmount * exr.ExchangeRate, 2) AS ItemAmount,
  ext.Taxable
FROM dbo.tbl_trn_Transaction ts
JOIN dbo.tbl_Device d ON d.Id=ts.DeviceId
JOIN dbo.tbl_MonthEndBilling_Expenses_Tiers ext
  ON ext.IsoId = d.IsoId
 AND ext.ExpenseType = 1
 AND (ext.NetworkCode = REPLACE(REPLACE(ts.IssuerNetworkId, 'VI1', 'SM1'), 'PL1', 'SM1') OR ext.NetworkCode = 'ALL')
 AND (ext.TranType = REPLACE(dbo.udf_GetValueName(19,ts.TransactionType),'RWT','WTH') OR ext.TranType = 'ALL')
JOIN dbo.tbl_MonthEndBilling_TotalCount_History tch
  ON tch.StartDate = @pStartDate AND tch.EndDate = @pEndDate
 AND tch.IsoId = ext.IsoId AND ext.MinTransactions <= tch.TotalCount
 AND (ext.MaxTransactions < 0 OR ext.MaxTransactions >= tch.TotalCount)
JOIN dbo.tbl_MonthEndBilling_ExchangeRate exr
  ON exr.FromCurrencyCode = ext.CurrencyCode AND exr.ToCurrencyCode = 124
WHERE ts.SystemSettlementDate BETWEEN @pStartDate AND @pEndDate
  AND NOT (ts.IssuerNetworkId IN ('PUL', 'CUP', 'CUR') AND ext.NetworkCode = 'ALL')
GROUP BY ext.IsoId, ext.ExpenseType, ext.StatementOrder, ext.StatementLabel1,
         ext.StatementLabel2, ext.ExpenseAmount, ext.ApprDeclCode,
         exr.ExchangeRate, ext.Taxable


-- Per Dialup Transaction Expenses
SELECT @MaxEntryID = ISNULL(max(EntryID), 0) FROM dbo.tbl_MonthEndBilling_History

INSERT INTO dbo.tbl_MonthEndBilling_History
(
  EntryID, StartDate, EndDate, IsoId, EntryType, ExpenseType,
  APIType, StatementOrder, StatementLabel1, StatementLabel2,
  ItemCount, Rate, Taxable
)
SELECT @MaxEntryID + ROW_NUMBER() OVER (ORDER BY ext.IsoId ASC, ext.StatementOrder ASC) AS EntryID,
  @pStartDate, @pEndDate, ext.IsoId, 1, ext.ExpenseType, 0, ext.StatementOrder, ext.StatementLabel1, ext.StatementLabel2,
  (CASE WHEN ext.ApprDeclCode = 1 THEN SUM(CASE WHEN ts.TransactionType NOT IN (2,3,4) AND ts.AmountSettlement-ts.AmountSurcharge<>0 THEN 1 ELSE 0 END)
        WHEN ext.ApprDeclCode = 2 THEN SUM(1) - SUM(CASE WHEN ts.TransactionType NOT IN (2,3,4) AND ts.AmountSettlement-ts.AmountSurcharge<>0 THEN 1 ELSE 0 END)
        ELSE SUM(1)
        END) AS ItemCount,
  ROUND(ext.ExpenseAmount * exr.ExchangeRate, 2) AS ItemAmount,
  ext.Taxable
FROM dbo.tbl_trn_Transaction ts
JOIN dbo.tbl_Device d ON d.Id=ts.DeviceId
JOIN dbo.tbl_MonthEndBilling_Expenses_Tiers ext
  ON ext.IsoId = d.IsoId
 AND ext.ExpenseType = 2
 AND (ext.NetworkCode = REPLACE(REPLACE(ts.IssuerNetworkId, 'VI1', 'SM1'), 'PL1', 'SM1') OR ext.NetworkCode = 'ALL')
 AND ext.TranType = REPLACE(dbo.udf_GetValueName(19,ts.TransactionType),'RWT','WTH')
JOIN dbo.tbl_MonthEndBilling_TotalCount_History tch
  ON tch.StartDate = @pStartDate AND tch.EndDate = @pEndDate
 AND tch.IsoId = ext.IsoId AND ext.MinTransactions <= tch.TotalCount
 AND (ext.MaxTransactions < 0 OR ext.MaxTransactions >= tch.TotalCount)
JOIN dbo.tbl_MonthEndBilling_ExchangeRate exr
  ON exr.FromCurrencyCode = ext.CurrencyCode AND exr.ToCurrencyCode = 124
WHERE ts.SystemSettlementDate BETWEEN @pStartDate AND @pEndDate
  AND ts.BatchID NOT LIKE '9191:%'
  AND ts.BatchID NOT LIKE '51:%'
  AND ts.BatchID NOT LIKE '53:%'
  AND ts.BatchID NOT LIKE '1:%'
  AND ts.BatchID NOT LIKE '6666:%'
  AND ts.BatchID NOT LIKE '7708:%'
  AND ts.BatchID NOT LIKE '8787:%'
  AND ts.BatchID NOT LIKE '9796:%'
  AND ts.BatchID NOT LIKE '9797:%'
  AND ts.BatchID NOT LIKE '9898:%'
  AND ts.BatchID NOT LIKE '9999:%'
  AND ts.IssuerNetworkId NOT IN ('PUL', 'CUP', 'CUR')
  AND ext.StatementLabel1 NOT LIKE '%(Dial-up & IP)%'
GROUP BY ext.IsoId, ext.ExpenseType, ext.StatementOrder, ext.StatementLabel1,
         ext.StatementLabel2, ext.ExpenseAmount, ext.ApprDeclCode,
         exr.ExchangeRate, ext.Taxable


-- Per Dialup & IP Transaction Expenses
SELECT @MaxEntryID = ISNULL(max(EntryID), 0) FROM dbo.tbl_MonthEndBilling_History

INSERT INTO dbo.tbl_MonthEndBilling_History
(
  EntryID, StartDate, EndDate, IsoId, EntryType, ExpenseType,
  APIType, StatementOrder, StatementLabel1, StatementLabel2,
  ItemCount, Rate, Taxable
)
SELECT
  @MaxEntryID + ROW_NUMBER() OVER (ORDER BY ext.IsoId ASC, ext.StatementOrder ASC) AS EntryID,
  @pStartDate, @pEndDate, ext.IsoId, 1, ext.ExpenseType, 0, ext.StatementOrder, ext.StatementLabel1, ext.StatementLabel2,
  (CASE WHEN ext.ApprDeclCode = 1 THEN SUM(CASE WHEN ts.TransactionType NOT IN (2,3,4) AND ts.AmountSettlement-ts.AmountSurcharge<>0 THEN 1 ELSE 0 END)
        WHEN ext.ApprDeclCode = 2 THEN SUM(1) - SUM(CASE WHEN ts.TransactionType NOT IN (2,3,4) AND ts.AmountSettlement-ts.AmountSurcharge<>0 THEN 1 ELSE 0 END)
        ELSE SUM(1)
        END) AS ItemCount,
  ROUND(ext.ExpenseAmount * exr.ExchangeRate, 2) AS ItemAmount,
  ext.Taxable
FROM dbo.tbl_trn_Transaction ts
JOIN dbo.tbl_Device d ON d.Id=ts.DeviceId
JOIN dbo.tbl_MonthEndBilling_Expenses_Tiers ext
  ON ext.IsoId = d.IsoId
 AND ext.ExpenseType = 2
 AND (ext.NetworkCode = REPLACE(REPLACE(ts.IssuerNetworkId, 'VI1', 'SM1'), 'PL1', 'SM1') OR ext.NetworkCode = 'ALL')
 AND ext.TranType = REPLACE(dbo.udf_GetValueName(19,ts.TransactionType),'RWT','WTH')
JOIN dbo.tbl_MonthEndBilling_TotalCount_History tch
  ON tch.StartDate = @pStartDate AND tch.EndDate = @pEndDate
 AND tch.IsoId = ext.IsoId AND ext.MinTransactions <= tch.TotalCount
 AND (ext.MaxTransactions < 0 OR ext.MaxTransactions >= tch.TotalCount)
JOIN dbo.tbl_MonthEndBilling_ExchangeRate exr
  ON exr.FromCurrencyCode = ext.CurrencyCode AND exr.ToCurrencyCode = 124
WHERE ts.SystemSettlementDate BETWEEN @pStartDate AND @pEndDate
  AND ts.BatchID NOT LIKE '51:%'
  AND ts.BatchID NOT LIKE '53:%'
  AND ts.IssuerNetworkId NOT IN ('PUL', 'CUP', 'CUR')
  AND ext.StatementLabel1 LIKE '%(Dial-up & IP)%'
GROUP BY ext.IsoId, ext.ExpenseType, ext.StatementOrder, ext.StatementLabel1,
         ext.StatementLabel2, ext.ExpenseAmount, ext.ApprDeclCode,
         exr.ExchangeRate, ext.Taxable


-- Per DPL Wireless Transaction Expenses
SELECT @MaxEntryID = ISNULL(max(EntryID), 0) FROM dbo.tbl_MonthEndBilling_History

INSERT INTO dbo.tbl_MonthEndBilling_History
(
  EntryID, StartDate, EndDate, IsoId, EntryType, ExpenseType,
  APIType, StatementOrder, StatementLabel1, StatementLabel2,
  ItemCount, Rate, Taxable
)
SELECT
  @MaxEntryID + ROW_NUMBER() OVER (ORDER BY ext.IsoId ASC, ext.StatementOrder ASC) AS EntryID,
  @pStartDate, @pEndDate, ext.IsoId, 1, ext.ExpenseType, 0, ext.StatementOrder, ext.StatementLabel1, ext.StatementLabel2,
  (CASE WHEN ext.ApprDeclCode = 1 THEN SUM(CASE WHEN ts.TransactionType NOT IN (2,3,4) AND ts.AmountSettlement-ts.AmountSurcharge<>0 THEN 1 ELSE 0 END)
        WHEN ext.ApprDeclCode = 2 THEN SUM(1) - SUM(CASE WHEN ts.TransactionType NOT IN (2,3,4) AND ts.AmountSettlement-ts.AmountSurcharge<>0 THEN 1 ELSE 0 END)
        ELSE SUM(1)
        END) AS ItemCount,
  ROUND(ext.ExpenseAmount * exr.ExchangeRate, 2) AS ItemAmount,
  ext.Taxable
FROM dbo.tbl_trn_Transaction ts
JOIN dbo.tbl_Device d ON d.Id=ts.DeviceId
JOIN dbo.tbl_MonthEndBilling_Expenses_Tiers ext
  ON ext.IsoId = d.IsoId
 AND ext.ExpenseType = 3
 AND (ext.NetworkCode = REPLACE(REPLACE(ts.IssuerNetworkId, 'VI1', 'SM1'), 'PL1', 'SM1') OR ext.NetworkCode = 'ALL')
 AND ext.TranType = REPLACE(dbo.udf_GetValueName(19,ts.TransactionType),'RWT','WTH')
JOIN dbo.tbl_MonthEndBilling_TotalCount_History tch
  ON tch.StartDate = @pStartDate AND tch.EndDate = @pEndDate
 AND tch.IsoId = ext.IsoId AND ext.MinTransactions <= tch.TotalCount
 AND (ext.MaxTransactions < 0 OR ext.MaxTransactions >= tch.TotalCount)
JOIN dbo.tbl_MonthEndBilling_ExchangeRate exr
  ON exr.FromCurrencyCode = ext.CurrencyCode AND exr.ToCurrencyCode = 124
WHERE ts.SystemSettlementDate BETWEEN @pStartDate AND @pEndDate
  AND (ts.BatchID LIKE '51:%' OR ts.BatchID LIKE '53:%')
  AND ts.IssuerNetworkId NOT IN ('PUL', 'CUP', 'CUR')
GROUP BY ext.IsoId, ext.ExpenseType, ext.StatementOrder, ext.StatementLabel1,
         ext.StatementLabel2, ext.ExpenseAmount, ext.ApprDeclCode,
         exr.ExchangeRate, ext.Taxable


-- Per IP Transaction
SELECT @MaxEntryID = ISNULL(max(EntryID), 0) FROM dbo.tbl_MonthEndBilling_History

INSERT INTO dbo.tbl_MonthEndBilling_History
(
  EntryID, StartDate, EndDate, IsoId, EntryType, ExpenseType,
  APIType, StatementOrder, StatementLabel1, StatementLabel2,
  ItemCount, Rate, Taxable
)
SELECT
  @MaxEntryID + ROW_NUMBER() OVER (ORDER BY ext.IsoId ASC, ext.StatementOrder ASC) AS EntryID,
  @pStartDate, @pEndDate, ext.IsoId, 1, ext.ExpenseType, 0, ext.StatementOrder, ext.StatementLabel1, ext.StatementLabel2,
  (CASE WHEN ext.ApprDeclCode = 1 THEN SUM(CASE WHEN ts.TransactionType NOT IN (2,3,4) AND ts.AmountSettlement-ts.AmountSurcharge<>0 THEN 1 ELSE 0 END)
        WHEN ext.ApprDeclCode = 2 THEN SUM(1) - SUM(CASE WHEN ts.TransactionType NOT IN (2,3,4) AND ts.AmountSettlement-ts.AmountSurcharge<>0 THEN 1 ELSE 0 END)
        ELSE SUM(1)
        END) AS ItemCount,
  ROUND(ext.ExpenseAmount * exr.ExchangeRate, 2) AS ItemAmount,
  ext.Taxable
FROM dbo.tbl_trn_Transaction ts
JOIN dbo.tbl_Device d ON d.Id=ts.DeviceId
JOIN dbo.tbl_MonthEndBilling_Expenses_Tiers ext
  ON ext.IsoId = d.IsoId
 AND ext.ExpenseType = 4
 AND (ext.NetworkCode = REPLACE(REPLACE(ts.IssuerNetworkId, 'VI1', 'SM1'), 'PL1', 'SM1') OR ext.NetworkCode = 'ALL')
 AND ext.TranType = REPLACE(dbo.udf_GetValueName(19,ts.TransactionType),'RWT','WTH')
JOIN dbo.tbl_MonthEndBilling_TotalCount_History tch
  ON tch.StartDate = @pStartDate AND tch.EndDate = @pEndDate
 AND tch.IsoId = ext.IsoId AND ext.MinTransactions <= tch.TotalCount
 AND (ext.MaxTransactions < 0 OR ext.MaxTransactions >= tch.TotalCount)
JOIN dbo.tbl_MonthEndBilling_ExchangeRate exr
  ON exr.FromCurrencyCode = ext.CurrencyCode AND exr.ToCurrencyCode = 124
WHERE ts.SystemSettlementDate BETWEEN @pStartDate AND @pEndDate
  AND ts.IssuerNetworkId NOT IN ('PUL', 'CUP', 'CUR')
  AND ext.StatementLabel1 NOT LIKE '%(Dial-up & IP)%'
  AND (ts.BatchID LIKE '1:%' OR ts.BatchID LIKE '6666:%' OR ts.BatchID LIKE '7708:%' OR ts.BatchID LIKE '8787:%'
    OR ts.BatchID LIKE '9191:%' OR ts.BatchID LIKE '9796:%' OR ts.BatchID LIKE '9797:%' OR ts.BatchID LIKE '9898:%' OR ts.BatchID LIKE '9999:%')
GROUP BY ext.IsoId, ext.ExpenseType, ext.StatementOrder, ext.StatementLabel1,
         ext.StatementLabel2, ext.ExpenseAmount, ext.ApprDeclCode,
         exr.ExchangeRate, ext.Taxable


-- Partial Dispense Sanctions
DECLARE @ThresholdPct money
SET @ThresholdPct = convert(money, 0)

SELECT @MaxEntryID = ISNULL(max(EntryID), 0) FROM dbo.tbl_MonthEndBilling_History

INSERT INTO dbo.tbl_MonthEndBilling_History
(
  EntryID, StartDate, EndDate, IsoId, EntryType, ExpenseType,
  APIType, StatementOrder, StatementLabel1, StatementLabel2,
  ItemCount, Rate, TotalAmount, Taxable
)
SELECT
  @MaxEntryID + ROW_NUMBER() OVER (ORDER BY ext.IsoId ASC, ext.StatementOrder ASC) AS EntryID,
  @pStartDate, @pEndDate, ext.IsoId,
  1, ext.ExpenseType, 0, ext.StatementOrder,
  ext.StatementLabel1, ext.StatementLabel2,
  0 AS ItemCount,
  0 AS ItemAmount,
  ext.ExpenseAmount * (SUM(CASE WHEN ts.TransactionType = 101 AND ts.AmountSettlement-ts.AmountSurcharge <> -1 * ts.AmountRequest THEN 1 ELSE 0 END) - FLOOR(CONVERT(MONEY,SUM(1)) * @ThresholdPct)) AS TotalAmount,
  ext.Taxable
FROM dbo.tbl_trn_Transaction ts
JOIN dbo.tbl_Device d ON d.Id=ts.DeviceId
JOIN dbo.tbl_MonthEndBilling_Expenses_Tiers ext
  ON ext.IsoId = d.IsoId AND ext.ExpenseType = 5
JOIN dbo.tbl_MonthEndBilling_TotalCount_History tch
  ON tch.StartDate = @pStartDate AND tch.EndDate = @pEndDate
 AND tch.IsoId = ext.IsoId AND ext.MinTransactions <= tch.TotalCount
 AND (ext.MaxTransactions < 0 OR ext.MaxTransactions >= tch.TotalCount)
JOIN dbo.tbl_MonthEndBilling_ExchangeRate exr
  ON exr.FromCurrencyCode = ext.CurrencyCode AND exr.ToCurrencyCode = 124
WHERE ts.SystemSettlementDate BETWEEN @pStartDate AND @pEndDate
  AND ts.ResponseCodeInternal=0
  AND ts.AmountSettlement-ts.AmountSurcharge<>0
  AND ts.IssuerNetworkId IN ('INT','BMO')
GROUP BY ext.IsoId, ext.ExpenseType, ext.StatementOrder, ext.StatementLabel1,
         ext.StatementLabel2, ext.ExpenseAmount, ext.ApprDeclCode,
         exr.ExchangeRate, ext.Taxable
HAVING SUM(CASE WHEN ts.TransactionType = 101 AND ts.AmountSettlement-ts.AmountSurcharge <> -1 * ts.AmountRequest THEN 1 ELSE 0 END) - FLOOR(CONVERT(MONEY,SUM(1)) * @ThresholdPct) > 0


-- MCI Cross Border Fees
SELECT @MaxEntryID = ISNULL(max(EntryID), 0) FROM dbo.tbl_MonthEndBilling_History

INSERT INTO dbo.tbl_MonthEndBilling_History
(
  EntryID, StartDate, EndDate, IsoId, EntryType, ExpenseType,
  APIType, StatementOrder, StatementLabel1, StatementLabel2,
  ItemCount, Rate, TotalAmount, Taxable
)
SELECT
  @MaxEntryID + ROW_NUMBER() OVER (ORDER BY ext.IsoId ASC, ext.StatementOrder ASC) AS EntryID,
  @pStartDate, @pEndDate, ext.IsoId,
  1, ext.ExpenseType, 0, ext.StatementOrder,
  ext.StatementLabel1, ext.StatementLabel2,
  0 AS ItemCount,
  0 AS ItemAmount,
  sum(mtf.MCIFee) AS TotalAmount,
  ext.Taxable
FROM dbo.tbl_MonthEndBilling_MCITransactionFees mtf
JOIN dbo.tbl_Device d ON d.Id = mtf.DeviceId
JOIN dbo.tbl_MonthEndBilling_Expenses_Tiers ext
  ON ext.IsoId = d.IsoId AND ext.ExpenseType = 9
JOIN dbo.tbl_MonthEndBilling_ExchangeRate exr
  ON exr.FromCurrencyCode = ext.CurrencyCode AND exr.ToCurrencyCode = 124
WHERE mtf.StartDate = @pStartDate AND mtf.EndDate = @pEndDate
GROUP BY ext.IsoId, ext.ExpenseType, ext.StatementOrder, ext.StatementLabel1,
         ext.StatementLabel2, ext.ExpenseAmount, ext.ApprDeclCode,
         exr.ExchangeRate, ext.Taxable

-- VISA Cross Border Fees
SELECT @MaxEntryID = ISNULL(max(EntryID), 0) FROM dbo.tbl_MonthEndBilling_History

INSERT INTO dbo.tbl_MonthEndBilling_History
(
  EntryID, StartDate, EndDate, IsoId, EntryType, ExpenseType,
  APIType, StatementOrder, StatementLabel1, StatementLabel2,
  ItemCount, Rate, TotalAmount, Taxable
)
SELECT 
  @MaxEntryID + ROW_NUMBER() OVER (ORDER BY ext.IsoId ASC, ext.StatementOrder ASC) AS EntryID,
  @pStartDate, @pEndDate, ext.IsoId,
  1, ext.ExpenseType, 0, ext.StatementOrder,
  ext.StatementLabel1, ext.StatementLabel2,
  0 AS ItemCount,
  0 AS ItemAmount,
  sum(vtf.VISAFee) AS TotalAmount,
  ext.Taxable
FROM dbo.tbl_MonthEndBilling_VISATransactionFees vtf
JOIN dbo.tbl_Device d ON d.Id = vtf.DeviceId
JOIN dbo.tbl_MonthEndBilling_Expenses_Tiers ext
  ON ext.IsoId = d.IsoId AND ext.ExpenseType = 7
JOIN dbo.tbl_MonthEndBilling_ExchangeRate exr
  ON exr.FromCurrencyCode = ext.CurrencyCode AND exr.ToCurrencyCode = 124
WHERE vtf.StartDate = @pStartDate AND vtf.EndDate = @pEndDate
GROUP BY ext.IsoId, ext.ExpenseType, ext.StatementOrder, ext.StatementLabel1,
         ext.StatementLabel2, ext.ExpenseAmount, ext.ApprDeclCode,
         exr.ExchangeRate, ext.Taxable


-- Per ISO Flat Fees
SELECT @MaxEntryID = ISNULL(max(EntryID), 0) FROM dbo.tbl_MonthEndBilling_History

INSERT INTO dbo.tbl_MonthEndBilling_History
(
  EntryID, StartDate, EndDate, IsoId, EntryType, ExpenseType,
  APIType, StatementOrder, StatementLabel1, StatementLabel2,
  ItemCount, Rate, TotalAmount, Taxable
)
SELECT 
  @MaxEntryID + ROW_NUMBER() OVER (ORDER BY ext.IsoId ASC, ext.StatementOrder ASC) AS EntryID,
  @pStartDate, @pEndDate, ext.IsoId,
  1, ext.ExpenseType, 0, ext.StatementOrder,
  ext.StatementLabel1, ext.StatementLabel2,
  1 AS ItemCount,
  ext.ExpenseAmount AS ItemAmount,
  ext.ExpenseAmount AS TotalAmount,
  ext.Taxable
FROM dbo.tbl_MonthEndBilling_Expenses_Tiers ext
JOIN dbo.tbl_MonthEndBilling_ExchangeRate exr
  ON exr.FromCurrencyCode = ext.CurrencyCode AND exr.ToCurrencyCode = 124
WHERE ext.ExpenseType = 10
GROUP BY ext.IsoId, ext.ExpenseType, ext.StatementOrder, ext.StatementLabel1,
         ext.StatementLabel2, ext.ExpenseAmount, exr.ExchangeRate, ext.Taxable


-- Per ATM Flat Fees
SELECT @MaxEntryID = ISNULL(max(EntryID), 0) FROM dbo.tbl_MonthEndBilling_History

INSERT INTO dbo.tbl_MonthEndBilling_History
(
  EntryID, StartDate, EndDate, IsoId, EntryType, ExpenseType,
  APIType, StatementOrder, StatementLabel1, StatementLabel2,
  ItemCount, Rate, TotalAmount, Taxable
)
SELECT 
  @MaxEntryID + ROW_NUMBER() OVER (ORDER BY ext.IsoId ASC, ext.StatementOrder ASC) AS EntryID,
  @pStartDate, @pEndDate, ext.IsoId,
  1, ext.ExpenseType, 0, ext.StatementOrder,
  ext.StatementLabel1, ext.StatementLabel2,
  count(DISTINCT ts.DeviceId) AS ItemCount,
  ext.ExpenseAmount AS ItemAmount,
  count(DISTINCT ts.DeviceId) * ext.ExpenseAmount AS TotalAmount,
  ext.Taxable
FROM dbo.tbl_trn_Transaction ts
JOIN dbo.tbl_Device d ON d.Id=ts.DeviceId
JOIN dbo.tbl_MonthEndBilling_Expenses_Tiers ext
  ON ext.IsoId = d.IsoId AND ext.ExpenseType = 17
JOIN dbo.tbl_MonthEndBilling_TotalCount_History tch
  ON tch.StartDate = @pStartDate AND tch.EndDate = @pEndDate
 AND tch.IsoId = ext.IsoId AND ext.MinTransactions <= tch.TotalCount
 AND (ext.MaxTransactions < 0 OR ext.MaxTransactions >= tch.TotalCount)
JOIN dbo.tbl_MonthEndBilling_ExchangeRate exr
  ON exr.FromCurrencyCode = ext.CurrencyCode AND exr.ToCurrencyCode = 124
WHERE ts.SystemSettlementDate BETWEEN @pStartDate AND @pEndDate 
  AND ts.AmountSettlement-ts.AmountSurcharge>0
  AND d.TerminalName NOT IN ('TNS89C99')
GROUP BY ext.IsoId, ext.ExpenseType, ext.StatementOrder, ext.StatementLabel1,
         ext.StatementLabel2, ext.ExpenseAmount, exr.ExchangeRate, ext.Taxable


-- Per Sentex Wired Flat Fees
SELECT @MaxEntryID = ISNULL(max(EntryID), 0) FROM dbo.tbl_MonthEndBilling_History

INSERT INTO dbo.tbl_MonthEndBilling_History
(
  EntryID, StartDate, EndDate, IsoId, EntryType, ExpenseType,
  APIType, StatementOrder, StatementLabel1, StatementLabel2,
  ItemCount, Rate, TotalAmount, Taxable
)
SELECT 
  @MaxEntryID + ROW_NUMBER() OVER (ORDER BY ext.IsoId ASC, ext.StatementOrder ASC) AS EntryID,
  @pStartDate, @pEndDate, ext.IsoId,
  1, ext.ExpenseType, 0, ext.StatementOrder,
  ext.StatementLabel1, ext.StatementLabel2,
  stc.WiredCount AS ItemCount,
  ext.ExpenseAmount AS ItemAmount,
  stc.WiredCount * ext.ExpenseAmount AS TotalAmount,
  ext.Taxable
FROM dbo.tbl_MonthEndBilling_SentexTerminalCount stc
JOIN dbo.tbl_MonthEndBilling_Expenses_Tiers ext
  ON ext.IsoId = stc.IsoId AND ext.ExpenseType = 18
JOIN dbo.tbl_MonthEndBilling_TotalCount_History tch
  ON tch.StartDate = @pStartDate AND tch.EndDate = @pEndDate
  AND tch.IsoId = ext.IsoId AND ext.MinTransactions <= tch.TotalCount
  AND (ext.MaxTransactions < 0 OR ext.MaxTransactions >= tch.TotalCount)
JOIN dbo.tbl_MonthEndBilling_ExchangeRate exr
  ON exr.FromCurrencyCode = ext.CurrencyCode AND exr.ToCurrencyCode = 124
WHERE stc.WiredCount > 0


-- Per Sentex Wireless Flat Fees
SELECT @MaxEntryID = ISNULL(max(EntryID), 0) FROM dbo.tbl_MonthEndBilling_History

INSERT INTO dbo.tbl_MonthEndBilling_History
(
  EntryID, StartDate, EndDate, IsoId, EntryType, ExpenseType,
  APIType, StatementOrder, StatementLabel1, StatementLabel2,
  ItemCount, Rate, TotalAmount, Taxable
)
SELECT 
  @MaxEntryID + ROW_NUMBER() OVER (ORDER BY ext.IsoId ASC, ext.StatementOrder ASC) AS EntryID,
  @pStartDate, @pEndDate, ext.IsoId,
  1, ext.ExpenseType, 0, ext.StatementOrder,
  ext.StatementLabel1, ext.StatementLabel2,
  stc.WirelessCount AS ItemCount,
  ext.ExpenseAmount AS ItemAmount,
  stc.WirelessCount * ext.ExpenseAmount AS TotalAmount,
  ext.Taxable
FROM dbo.tbl_MonthEndBilling_SentexTerminalCount stc
JOIN dbo.tbl_MonthEndBilling_Expenses_Tiers ext
  ON ext.IsoId = stc.IsoId AND ext.ExpenseType = 28
JOIN dbo.tbl_MonthEndBilling_TotalCount_History tch
  ON tch.StartDate = @pStartDate AND tch.EndDate = @pEndDate
 AND tch.IsoId = ext.IsoId AND ext.MinTransactions <= tch.TotalCount
 AND (ext.MaxTransactions < 0 OR ext.MaxTransactions >= tch.TotalCount)
JOIN dbo.tbl_MonthEndBilling_ExchangeRate exr
  ON exr.FromCurrencyCode = ext.CurrencyCode AND exr.ToCurrencyCode = 124
WHERE stc.WirelessCount <> 0


-- Wireless Unit Rentals
SELECT @MaxEntryID = ISNULL(max(EntryID), 0) FROM dbo.tbl_MonthEndBilling_History

INSERT INTO dbo.tbl_MonthEndBilling_History
(
  EntryID, StartDate, EndDate, IsoId, EntryType, ExpenseType,
  APIType, StatementOrder, StatementLabel1, StatementLabel2,
  ItemCount, Rate, TotalAmount, Taxable
)
SELECT 
  @MaxEntryID + ROW_NUMBER() OVER (ORDER BY ext.IsoId ASC, ext.StatementOrder ASC) AS EntryID,
  @pStartDate, @pEndDate, ext.IsoId,
  1, ext.ExpenseType, 0, ext.StatementOrder,
  ext.StatementLabel1, ext.StatementLabel2,
  wun.WirelessUnitCount AS ItemCount,
  ext.ExpenseAmount AS ItemAmount,
  wun.WirelessUnitCount * ext.ExpenseAmount AS TotalAmount,
  ext.Taxable
FROM dbo.tbl_MonthEndBilling_WirelessUnits wun
JOIN dbo.tbl_MonthEndBilling_Expenses_Tiers ext
  ON ext.IsoId = wun.IsoId AND ext.ExpenseType = 29
JOIN dbo.tbl_MonthEndBilling_TotalCount_History tch
  ON tch.StartDate = @pStartDate AND tch.EndDate = @pEndDate
 AND tch.IsoId = ext.IsoId AND ext.MinTransactions <= tch.TotalCount
 AND (ext.MaxTransactions < 0 OR ext.MaxTransactions >= tch.TotalCount)
JOIN dbo.tbl_MonthEndBilling_ExchangeRate exr
  ON exr.FromCurrencyCode = ext.CurrencyCode AND exr.ToCurrencyCode = 124


-- Per Disconnection
SELECT @MaxEntryID = ISNULL(max(EntryID), 0) FROM dbo.tbl_MonthEndBilling_History

DECLARE @tblInstallCount TABLE (IsoId int PRIMARY KEY, InstallCount int)
DECLARE @tblDeleteCount TABLE (IsoId int PRIMARY KEY, InstallCount int, DeleteCount int)

INSERT INTO @tblInstallCount
SELECT d.IsoId, count(*)
FROM dbo.tbl_Device d
WHERE d.CreatedDate >= @pStartDate AND d.CreatedDate <= @pEndDate
GROUP BY d.IsoId

INSERT INTO @tblDeleteCount
SELECT d.IsoId, 
  sum(CASE WHEN a.NewValue IN ('1', '3') THEN 1 ELSE 0 END),
  sum(CASE WHEN a.NewValue NOT IN ('1', '3') THEN 1 ELSE 0 END)
  FROM dbo.tbl_AuditLog a
  JOIN dbo.tbl_Device d ON d.Id=a.PrimaryKeyValue
  JOIN dbo.tbl_Iso    i ON i.Id=d.IsoId
  WHERE a.TableName = 'tbl_Device'
    and a.FieldName = 'DeviceStatus'
    and a.UpdatedDate >= @pStartDate AND a.UpdatedDate <= @pEndDate + 1
    AND ((a.OldValue IN ('1', '3') AND a.NewValue NOT IN ('1', '3')) OR (a.OldValue NOT IN ('1', '3') AND a.NewValue IN ('1', '3')))
GROUP BY d.IsoId

INSERT INTO dbo.tbl_MonthEndBilling_History
(
  EntryID, StartDate, EndDate, IsoId, EntryType, ExpenseType,
  APIType, StatementOrder, StatementLabel1, StatementLabel2,
  ItemCount, Rate, TotalAmount, Taxable
)
SELECT
  @MaxEntryID + ROW_NUMBER() OVER (ORDER BY ext.IsoId ASC, ext.StatementOrder ASC) AS EntryID,
  @pStartDate, @pEndDate, ext.IsoId,
  1, ext.ExpenseType, 0, ext.StatementOrder,
  ext.StatementLabel1, ext.StatementLabel2,
  dc.DeleteCount - dc.InstallCount - ISNULL(ic.InstallCount, 0) AS ItemCount,
  ext.ExpenseAmount AS ItemAmount,
  (dc.DeleteCount - dc.InstallCount - ISNULL(ic.InstallCount, 0)) * ext.ExpenseAmount AS TotalAmount,
  ext.Taxable
FROM @tblDeleteCount dc
LEFT JOIN @tblInstallCount ic
  ON ic.IsoId = dc.IsoId
JOIN dbo.tbl_MonthEndBilling_Expenses_Tiers ext
  ON ext.IsoId = dc.IsoId AND ext.ExpenseType = 19
JOIN dbo.tbl_MonthEndBilling_TotalCount_History tch
  ON tch.StartDate = @pStartDate AND tch.EndDate = @pEndDate
 AND tch.IsoId = ext.IsoId AND ext.MinTransactions <= tch.TotalCount
 AND (ext.MaxTransactions < 0 OR ext.MaxTransactions >= tch.TotalCount)
JOIN dbo.tbl_MonthEndBilling_ExchangeRate exr
  ON exr.FromCurrencyCode = ext.CurrencyCode AND exr.ToCurrencyCode = 124
WHERE dc.DeleteCount > ISNULL(ic.InstallCount, 0) + dc.InstallCount


-- Adjustments
SELECT @MaxEntryID = ISNULL(max(EntryID), 0) FROM dbo.tbl_MonthEndBilling_History

INSERT INTO dbo.tbl_MonthEndBilling_History
(
  EntryID, StartDate, EndDate, IsoId, EntryType, ExpenseType,
  APIType, StatementOrder, StatementLabel1, StatementLabel2,
  ItemCount, Rate, TotalAmount, Taxable
)
SELECT 
  @MaxEntryID + ROW_NUMBER() OVER (ORDER BY adj.AdjustmentID ASC) AS EntryID,
  @pStartDate, @pEndDate, adj.IsoId,
  1, 99, 0, 99 + adj.AdjustmentID,
  LEFT(adj.AdjustmentDesc, 50), '' AS StatementLabel2,
  1 AS ItemCount,
  -adj.Amount AS ItemAmount,
  -adj.Amount AS TotalAmount,
  adj.Taxable
FROM dbo.tbl_MonthEndBilling_Adjustments adj
WHERE (adj.[Status] = 'AC' OR adj.ProcessedDate = @pEndDate)

UPDATE dbo.tbl_MonthEndBilling_Adjustments SET [Status] = 'PR', ProcessedDate = @pEndDate
WHERE [Status] = 'AC'
GO
