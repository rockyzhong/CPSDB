SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_rep_MonthlyATMRevenueForISO]  
-- This SP for j&j
    @IsoId BIGINT,
    @UserId BIGINT,
	@StartDate DATETIME,
    @EndDate DATETIME
AS
BEGIN
    SET NOCOUNT ON

    DECLARE @Permission TABLE(Id bigint)
    DECLARE @IsoInterchange TABLE (Year BIGINT,Month bigint,InterchangePaid MONEY)
    DECLARE @IsoSurcharge TABLE (Year BIGINT,Month bigint,SurchargePaid MONEY)
    
	INSERT INTO @Permission EXEC dbo.usp_upm_GetPermissionIds @UserId, 1
    
    INSERT INTO @IsoInterchange (Year,Month, InterchangePaid)
	 (SELECT Year(DateTimeSettlement),MONTH(DateTimeSettlement),SUM(Amount)	 
		FROM SPS_SPN.dbo.tblPendingACH WHERE FundsType='INTR' 
		AND AccountID IN (SELECT AccountID FROM SPS_SPN.dbo.tblAccount WHERE HolderName =(SELECT RegisteredName FROM dbo.tbl_iso WHERE id=@IsoId))
		AND ProcessedStatus='DP'
		AND DateTimeSettlement BETWEEN @StartDate AND @EndDate
		GROUP BY YEAR(DateTimeSettlement),MONTH(DateTimeSettlement) )
 
    INSERT INTO @IsoSurcharge (Year, Month, SurchargePaid)
     (SELECT YEAR(DateTimeSettlement),MONTH(DateTimeSettlement),SUM(Amount)	 
		FROM SPS_SPN.dbo.tblPendingACH WHERE FundsType='SRCH' 
		AND SourceCode IN (SELECT TerminalName FROM dbo.tbl_Device WHERE IsoId = @IsoId)
		AND AccountID NOT IN (SELECT AccountID FROM SPS_SPN.dbo.tblAccount WHERE HolderName =(SELECT RegisteredName FROM dbo.tbl_iso WHERE id=@IsoId))
		AND ProcessedStatus='DP'
		AND DateTimeSettlement BETWEEN  @StartDate AND  @EndDate
		GROUP BY YEAR(DateTimeSettlement),MONTH(DateTimeSettlement));


IF EXISTS (SELECT * FROM @Permission WHERE Id = 9998) -- Permission=9998 means only viewing transaction created by himself is allowed
   BEGIN 

	WITH pp (Year,Month,Terminals,Trans,Aprroved,AmountDispensed,SurchargeCollected) AS (
	SELECT YEAR(st.SystemTime),MONTH(st.SystemTime),
	COUNT (DISTINCT(st.DeviceId)),
	COUNT(st.Id) AS Transactions,
	SUM(CASE WHEN st.TransactionType=1 AND st.ResponseCodeInternal=0 THEN 1 ELSE 0 END),
	CONVERT(MONEY,SUM(CASE WHEN st.TransactionType=1 AND st.ResponseCodeInternal=0 THEN st.AmountSettlement-st.AmountSurcharge ELSE 0 END))/100 AS 'Amount Dispensed',
	CONVERT(MONEY,SUM(CASE WHEN st.TransactionType=1 AND st.ResponseCodeInternal=0 THEN st.AmountSurcharge ELSE 0 END))/100 AS 'Surcharge Collected'
	FROM dbo.tbl_trn_Transaction st
	WHERE st.DeviceId IN (SELECT id FROM dbo.tbl_Device WHERE IsoId = @IsoId)
	AND st.SystemTime BETWEEN  @StartDate AND  @EndDate
	AND st.CreatedUserId = @UserId
	GROUP BY YEAR(st.SystemTime),Month(st.SystemTime) 
   )

	SELECT 
	p.Year,
	CASE WHEN p.Month=1 THEN 'January'
	WHEN p.Month=2 THEN 'February'
	WHEN p.Month=3 THEN 'March'
	WHEN p.Month=4 THEN 'April'
	WHEN p.Month=5 THEN 'May'
	WHEN p.Month=6 THEN 'June'
	WHEN p.Month=7 THEN 'July'
	WHEN p.Month=8 THEN 'August'
	WHEN p.Month=9 THEN 'September'
	WHEN p.Month=10 THEN 'October'
	WHEN p.Month=11 THEN 'November'
	ELSE 'December' END AS Month,p.Terminals  AS 'Active Terminals',p.Trans 'Transactions',p.Aprroved  AS 'Approved Withdrawals',p.AmountDispensed AS 'Amount Dispensed',
	p.SurchargeCollected AS 'Surcharge Collected',ISNULL(i.InterchangePaid,0.00) AS Interchange,ISNULL(s.SurchargePaid,0.00) AS 'Client Surcharge'
	FROM pp p LEFT JOIN @IsoInterchange i ON i.Month = p.Month AND i.Year=p.Year
			  LEFT JOIN @IsoSurcharge s ON s.Month = p.Month AND s.Year=p.Year
	ORDER BY p.Year,p.Month 

  END
ELSE
  BEGIN
  WITH pp (Year,Month,Terminals,Trans,Aprroved,AmountDispensed,SurchargeCollected) AS (
	SELECT YEAR(st.SystemTime),MONTH(st.SystemTime),
	COUNT (DISTINCT(st.DeviceId)),
	COUNT(st.Id) AS Transactions,
	SUM(CASE WHEN st.TransactionType=1 AND st.ResponseCodeInternal=0 THEN 1 ELSE 0 END),
	CONVERT(MONEY,SUM(CASE WHEN st.TransactionType=1 AND st.ResponseCodeInternal=0 THEN st.AmountSettlement-st.AmountSurcharge ELSE 0 END))/100 AS 'Amount Dispensed',
	CONVERT(MONEY,SUM(CASE WHEN st.TransactionType=1 AND st.ResponseCodeInternal=0 THEN st.AmountSurcharge ELSE 0 END))/100 AS 'Surcharge Collected'
	FROM dbo.tbl_trn_Transaction st
	WHERE st.DeviceId IN (SELECT id FROM dbo.tbl_Device WHERE IsoId = @IsoId)
	AND st.SystemTime BETWEEN  @StartDate AND  @EndDate
	GROUP BY YEAR(st.SystemTime),month(st.SystemTime) 
   )

	SELECT 
	p.Year,
	CASE WHEN p.Month=1 THEN 'January'
	WHEN p.Month=2 THEN 'February'
	WHEN p.Month=3 THEN 'March'
	WHEN p.Month=4 THEN 'April'
	WHEN p.Month=5 THEN 'May'
	WHEN p.Month=6 THEN 'June'
	WHEN p.Month=7 THEN 'July'
	WHEN p.Month=8 THEN 'August'
	WHEN p.Month=9 THEN 'September'
	WHEN p.Month=10 THEN 'October'
	WHEN p.Month=11 THEN 'November'
	ELSE 'December' END AS Month,p.Terminals  AS 'Active Terminals',p.Trans 'Transactions',p.Aprroved  AS 'Approved Withdrawals',p.AmountDispensed AS 'Amount Dispensed',
	p.SurchargeCollected AS 'Surcharge Collected',ISNULL(i.InterchangePaid,0.00) AS Interchange,ISNULL(s.SurchargePaid,0.00) AS 'Client Surcharge'
	FROM pp p LEFT JOIN @IsoInterchange i ON i.Month = p.Month AND i.Year=p.Year
			  LEFT JOIN @IsoSurcharge s ON s.Month = p.Month AND s.Year=p.Year
	ORDER BY p.Year,p.Month 

  END
END
GO
