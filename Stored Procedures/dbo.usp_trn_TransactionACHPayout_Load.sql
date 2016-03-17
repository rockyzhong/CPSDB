SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE  PROC [dbo].[usp_trn_TransactionACHPayout_Load]
	@pSettDate datetime
	,@pCurrency smallint
AS
BEGIN
SET NOCOUNT ON
--DECLARE @pSettDate datetime
--SET @pSettDate = '2015-04-19'

DECLARE @DueDate DATETIME

IF OBJECT_ID('tempdb..#temp_trn_TransactionACHPayout') IS NOT NULL
	DROP TABLE #temp_trn_TransactionACHPayout


SELECT @DueDate = @pSettDate
EXEC dbo.usp_sys_GetNextBusinessDay @DueDate OUTPUT, 0, @pCurrency
--SELECT @DueDate

UPDATE dbo.tbl_trn_TransactionACH
SET ACHPayoutDate = NULL
	,FileNo = NULL
WHERE ACHPayoutDate = @pSettDate
	AND Currency = @pCurrency

SELECT
	t.SettlementDate
	,t.DateTimeClose
	,t.SourceType
	,t.SourceCode
	,t.AccountID
	,t.FundsType

	,ACHFileID = s.AchFileId
	,FileNo = 1
	,BatchHeader = CASE	
						WHEN t.FundsType IN ('SETL', 'SETD', 'SETC') THEN f.SettlementLabel
						WHEN  t.FundsType IN ('SRCH', 'SRCD', 'SRCC') THEN f.SurchargeLabel
						WHEN t.FundsType IN ('INTR') THEN f.InterchangeLabel
						ELSE t.BatchHeader
					END
	,RTA = b.Rta
	,AccountType = CASE WHEN b.BankAccountType = 1 THEN 'SAV' ELSE 'CHK' END
	,RefName = CASE 
					WHEN b.ConsolidationType = 1 THEN t.SourceCode + t.FundsType
					WHEN b.ConsolidationType = 2 THEN t.SourceCode
					WHEN b.ConsolidationType = 3 AND t.FundsType = 'INTC' THEN f.CompanyShortName + 'SRCC'
					WHEN b.ConsolidationType = 3 AND t.FundsType = 'INTD' THEN f.CompanyShortName + 'SRCD'
					WHEN b.ConsolidationType = 3 THEN f.CompanyShortName + t.FundsType
					WHEN b.ConsolidationType = 4 THEN f.CompanyShortName
					ELSE ''
				END
	,HolderName = b.HolderName
	,Amount = t.Amount
	,DueDate = @DueDate 
	,StandardEntryCode = ISNULL(t.StandardEntryCode, f.StandardEntryClassCode)
	,ScheduleType = ISNULL(so.ScheduleType, s.ScheduleType)
	,ThresholdAmount = CASE 
							WHEN ISNULL(so.ScheduleType, s.ScheduleType) = 4 THEN ISNULL(so.ThresholdAmount, s.ThresholdAmount)
							ELSE 0
						END
--,*
INTO #temp_trn_TransactionACHPayout
FROM dbo.tbl_trn_TransactionACH t(NOLOCK)
	JOIN dbo.tbl_BankAccount b(NOLOCK)
		ON t.AccountID = b.Id
	JOIN dbo.tbl_BankAccountSchedule s(NOLOCK)
		ON b.Id = s.BankAccountId
		AND (t.FundsType IN ('SETL', 'SETD', 'SETC') AND s.FundsType = 1 -- settlement
			OR t.FundsType IN ('SRCH', 'SRCD', 'SRCC') AND s.FundsType = 2 -- surcharge
			OR t.FundsType IN ('INTR') AND s.FundsType = 3) -- Interchange
	LEFT JOIN dbo.tbl_BankAccountScheduleOverride so(NOLOCK)
		ON t.SourceType = 2
		AND t.SourceCode = so.DeviceId
		AND (t.FundsType IN ('SETL', 'SETD', 'SETC') AND so.FundsType = 1 -- settlement
			OR t.FundsType IN ('SRCH', 'SRCD', 'SRCC') AND so.FundsType = 2 -- surcharge
			OR t.FundsType IN ('INTR') AND so.FundsType = 3) -- Interchange
	JOIN dbo.tbl_AchFile f(NOLOCK)
		ON s.AchFileId = f.Id
	JOIN dbo.tbl_Device d(NOLOCK)
		ON t.SourceCode = d.Id
WHERE t.ACHPayoutDate IS NULL
	AND t.Currency = @pCurrency
	AND (-- scheduled ACH ------------------------------------------------------
		t.FundsType IN ('ADJC', 'ADJD', 'ADTC', 'ADTD') 
		-- daily ---------------------------------------------------------------
		OR ISNULL(so.ScheduleType, s.ScheduleType) = 1 
		-- weekly --------------------------------------------------------------
		OR ISNULL(so.ScheduleType, s.ScheduleType) = 2 AND ISNULL(so.SchedulePayoutDay, s.SchedulePayoutDay) = DATEPART(weekday, @pSettDate) 
			AND t.SettlementDate <= (CASE
										WHEN ISNULL(so.ScheduleDay, s.ScheduleDay) <= ISNULL(so.SchedulePayoutDay, s.SchedulePayoutDay) -- same week
											THEN @psettdate - (ISNULL(so.SchedulePayoutDay, s.SchedulePayoutDay) - ISNULL(so.ScheduleDay, s.ScheduleDay))
										ELSE @psettdate - 7 + (ISNULL(so.ScheduleDay, s.ScheduleDay) - ISNULL(so.SchedulePayoutDay, s.SchedulePayoutDay)) -- last week
									END)
		-- monthly -------------------------------------------------------------
		OR ISNULL(so.ScheduleType, s.ScheduleType) = 3 
			AND  DATEPART(day, @pSettDate) = CASE -- if the payout day is greater than last day of the month, then use last day of the month as payout day
												WHEN ISNULL(so.SchedulePayoutDay,  s.SchedulePayoutDay) > DATEPART(day, DATEADD(day, -1, CONVERT(VARCHAR(8), DATEADD(month, 1, @psettdate), 120) + '01')) 
													THEN DATEPART(day, DATEADD(day, -1, CONVERT(VARCHAR(8), DATEADD(month, 1, @psettdate), 120) + '01'))
												ELSE ISNULL(so.SchedulePayoutDay,  s.SchedulePayoutDay)
											END
			AND CONVERT(VARCHAR(10), t.SettlementDate, 120) <= CASE
																	WHEN ISNULL(so.ScheduleDay, s.ScheduleDay) <= ISNULL(so.SchedulePayoutDay, s.SchedulePayoutDay) -- same month
																		THEN CONVERT(VARCHAR(8), @psettdate, 120) + RIGHT('00' + CAST(ISNULL(so.ScheduleDay, s.ScheduleDay) AS VARCHAR), 2)
																	ELSE CONVERT(VARCHAR(8), DATEADD(month, -1, @psettdate), 120) + RIGHT('00' + CAST(ISNULL(so.ScheduleDay, s.ScheduleDay) AS VARCHAR), 2) -- last month
																END
		-- threshold -----------------------------------------------------------
		OR ISNULL(so.ScheduleType, s.ScheduleType) = 4) 


DELETE FROM dbo.tbl_trn_TransactionACHPayout 
WHERE SettlementDate = @pSettDate
	AND Currency = @pCurrency

INSERT INTO dbo.tbl_trn_TransactionACHPayout
(
	SettlementDate
	,ACHFileID 
	,FileNo
	,BatchHeader
	,RTA
	,AccountType
	,RefName
	,HolderName
	,DueDate
	,StandardEntryCode
	,Amount	
	,Currency
)
SELECT
	SettlementDate  = @pSettDate
	,a.ACHFileID
	,a.FileNo
	,a.BatchHeader
	,a.RTA
	,a.AccountType
	,a.RefName
	,HolderName = MAX(a.HolderName)
	,DueDate = MAX(a.DueDate)
	,StandardEntryCode = MAX(a.StandardEntryCode)
	,Amount = SUM(a.Amount)
	,Currency = @pCurrency
FROM #temp_trn_TransactionACHPayout a
GROUP BY SettlementDate
	,ACHFileID 
	,FileNo 
	,BatchHeader
	,RTA 
	,AccountType 
	,RefName
HAVING ABS(SUM(a.Amount)) >= MAX(a.ThresholdAmount)

UPDATE ACH
SET ACH.ACHPayoutDate = @pSettDate
	,ACH.ACHFileID = PAYOUT.ACHFileID
	,ACH.FileNo = PAYOUT.FileNo
FROM dbo.tbl_trn_TransactionACH ACH
	JOIN #temp_trn_TransactionACHPayout PAYOUT (NOLOCK)
		ON ACH.SettlementDate = PAYOUT.SettlementDate
		AND ACH.DateTimeClose = PAYOUT.DateTimeClose
		AND ACH.SourceType = PAYOUT.SourceType
		AND ACH.SourceCode = PAYOUT.SourceCode
		AND ACH.AccountID = PAYOUT.AccountID
		AND ACH.FundsType = PAYOUT.FundsType
		AND PAYOUT.ScheduleType <> 4

UPDATE ACH
SET ACH.ACHPayoutDate = @pSettDate
	,ACH.ACHFileID = PAYOUT.ACHFileID
	,ACH.FileNo = PAYOUT.FileNo
FROM dbo.tbl_trn_TransactionACH ACH
	JOIN (
		SELECT 
			t.SettlementDate
			,t.DateTimeClose
			,t.SourceType
			,t.SourceCode
			,t.AccountID
			,t.FundsType
			,t.ACHFileID 
			,t.FileNo 
			--,t.BatchHeader
			--,t.RTA 
			--,t.AccountType
			--,t.RefName 
			,t.ThresholdAmount
			,Amount = ABS(SUM(Amount) OVER (PARTITION BY ACHFileID, FileNo, BatchHeader, RTA, AccountType, RefName))
		FROM #temp_trn_TransactionACHPayout t
		WHERE ScheduleType = 4
	) PAYOUT
	ON ACH.SettlementDate = PAYOUT.SettlementDate
	AND ACH.DateTimeClose = PAYOUT.DateTimeClose
	AND ACH.SourceType = PAYOUT.SourceType
	AND ACH.SourceCode = PAYOUT.SourceCode
	AND ACH.AccountID = PAYOUT.AccountID
	AND ACH.FundsType = PAYOUT.FundsType
	AND PAYOUT.Amount >= PAYOUT.ThresholdAmount


IF OBJECT_ID('tempdb..#temp_trn_TransactionACHPayout') IS NOT NULL
	DROP TABLE #temp_trn_TransactionACHPayout

END
GO
GRANT EXECUTE ON  [dbo].[usp_trn_TransactionACHPayout_Load] TO [WebV4Role]
GO
