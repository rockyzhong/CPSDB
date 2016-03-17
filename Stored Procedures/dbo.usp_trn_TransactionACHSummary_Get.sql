SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
/*
EXEC dbo.usp_trn_TransactionACHSummary_Get '2015-04-19', 124
EXEC dbo.usp_trn_TransactionACHSummary_Get '2015-04-19', 840
*/
CREATE PROC [dbo].[usp_trn_TransactionACHSummary_Get]
	@pSettDate datetime
	,@pCurrency smallint
AS 
BEGIN
SET NOCOUNT ON


DECLARE @SettlementHistoryDays int
SELECT TOP 1 @SettlementHistoryDays = CAST(Value AS int) FROM dbo.tbl_Parameter (NOLOCK) WHERE Name = 'SettlementHistoryDays'
SET @SettlementHistoryDays = ISNULL(@SettlementHistoryDays, 10)


SELECT ACHInfoText =
	'Gateway: '+ ISNULL(d.Name, '') + char(13) + char(10)
	+ 'Approved Transactions: ' + CONVERT(varchar(20), COUNT(1)) + char(13) + char(10)
	+ 'Dispensed Total: $' + CONVERT(varchar(30), SUM(
		CASE 
			WHEN t.SettlementAllocationDate = @pSettDate THEN t.AmountSettlement - t.AmountSurcharge  
			ELSE 0 
		END)) + char(13) + char(10)
	+ 'Surcharge Total: $' + CONVERT(varchar(30), SUM(
		CASE 
			WHEN t.SurchargeAllocationDate = @pSettDate THEN t.AmountSurcharge  
			ELSE 0 
		END)) + char(13) + char(10)
	+ 'Net Total: $' + CONVERT(varchar(30), SUM(
		CASE 
			WHEN t.SettlementAllocationDate = @pSettDate THEN t.AmountSettlement - t.AmountSurcharge  
			ELSE 0 
		END + 
		CASE 
			WHEN t.SurchargeAllocationDate = @pSettDate THEN t.AmountSurcharge  
			ELSE 0 
		END)) + char(13) + char(10) + char(13) + char(10)
FROM dbo.tbl_trn_TransactionConsolidated t(NOLOCK)
	LEFT JOIN dbo.tbl_TypeValue d(NOLOCK)	
		ON t.DestCode = d.Value
		AND d.TypeId = 200 -- DestCode
WHERE t.SettlementDate BETWEEN @pSettDate - @SettlementHistoryDays AND @pSettDate
	AND (t.SettlementAllocationDate = @pSettDate OR t.SurchargeAllocationDate = @pSettDate)
	AND t.AmountSettlement <> 0
	AND t.TransactionType <> 8 -- PRE
	AND t.ResponseCodeInternal <> -99
	AND t.CurrencyRequest = @pCurrency
GROUP BY ISNULL(d.Name, '')

UNION ALL
SELECT ACHInfoText =
	'ACH File: ' + ISNULL(f.InstitutionName, '') + char(13) + char(10)
	+ 'Vault Cash Funds Allocated: $' + CONVERT(varchar(30), ISNULL(SUM(
		CASE 
			WHEN t.FundsType IN ('SETL', 'SETD', 'SETC') THEN t.Amount
			ELSE 0 
		END), 0)) + char(13) + char(10)
	+ 'Surcharge Funds Allocated: $' + CONVERT(varchar(30),ISNULL(SUM(
		CASE 
			WHEN t.FundsType IN ('SRCH', 'SRCD', 'SRCC') THEN t.Amount
			 ELSE 0 
		END), 0)) + char(13) + char(10) 
	+ 'Adjustments Processed: $' + CONVERT(varchar(30), ISNULL(SUM(
		CASE 
			WHEN t.FundsType LIKE 'AD%' THEN t.Amount
			ELSE 0 
		END), 0)) + char(13) + char(10) 
	+ 'Other ACH Deposits: $' + CONVERT(varchar(30), ISNULL(SUM(
		CASE 
			WHEN t.FundsType NOT LIKE 'AD%' AND t.FundsType NOT IN ('SETL', 'SETD', 'SETC', 'SRCH', 'SRCD', 'SRCC') THEN t.Amount
			ELSE 0 
		END), 0)) + char(13) + char(10) 
	+ 'Total Net ACH Deposits: $' + CONVERT(varchar(30), ISNULL(SUM(t.Amount), 0)) + char(13) + char(10) + char(13) + char(10)
FROM dbo.tbl_trn_TransactionACH t(NOLOCK)
	LEFT JOIN tbl_BankAccount b(NOLOCK)
		ON t.AccountID = b.Id
	LEFT JOIN dbo.tbl_BankAccountSchedule s(NOLOCK)
		ON b.Id = s.BankAccountId
		AND (t.FundsType IN ('SETL', 'SETD', 'SETC') AND s.FundsType = 1 -- settlement
			OR t.FundsType IN ('SRCH', 'SRCD', 'SRCC') AND s.FundsType = 2 -- surcharge
			OR t.FundsType IN ('INTR') AND s.FundsType = 3) -- Interchange
	LEFT JOIN tbl_AchFile f(NOLOCK)
		ON s.AchFileId = f.Id
WHERE t.Currency = @pCurrency
GROUP BY ISNULL(f.InstitutionName, '')
	

UNION ALL
SELECT ACHInfoText =' Rounding Error: $0.00' + char(13) + char(10) + char(13) + char(10) 
ORDER BY ACHInfoText DESC

END
GO
GRANT EXECUTE ON  [dbo].[usp_trn_TransactionACHSummary_Get] TO [WebV4Role]
GO
