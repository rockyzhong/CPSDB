SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
/*
DECLARE @Date datetime
SET @Date = '2015-04-17'
EXEC dbo.usp_sys_GetNextBusinessDay @Date OUTPUT, 0, 124
SELECT @Date

*/

CREATE PROCEDURE [dbo].[usp_sys_GetNextBusinessDay]
	@pDate datetime OUTPUT,
	@pNumDays int = 0,
	@pCurrency int = 124
AS
BEGIN
-- Get next business day
-- Revision 1.00 2004.08.19 by Adam Glover
-- Initial Revsion
-- Revision 1.01 2005.03.02 by Adam Glover
-- Added optional @pNumDays parameter to
-- count one or more business days ahead.
-- Revision 1.02 2005.04.11 by Adam Glover
-- Corrected handling of situations where counting
-- business days from a weekend or holiday date.
-- Revision 06.04.2015 by Julian Wu
-- Migrate to V4 and replace the name from dbo.usp_sps_Miscellaneous_Holiday_GetNextBusinessDay
DECLARE @RetDate datetime
SET @RetDate = @pDate

DECLARE @BusinessDayCount int

IF OBJECT_ID('tempdb..#Temp_tbl_BankHoliday') IS NOT NULL
	DROP TABLE #Temp_tbl_BankHoliday

SELECT * INTO #Temp_tbl_BankHoliday
FROM dbo.tbl_BankHoliday(NOLOCK)
WHERE Currency = @pCurrency

IF @pNumDays < 0
BEGIN
  SET @BusinessDayCount = 0
END
ELSE
BEGIN
  SET @BusinessDayCount = @pNumDays
END

DECLARE @DayOfWeek int
DECLARE @DayOfMonth int
DECLARE @MonthOfYear int

DECLARE @IsBusinessDay int
SET @IsBusinessDay = 0

DECLARE @LoopCount int
SET @LoopCount = 0

WHILE (@IsBusinessDay = 0 OR @BusinessDayCount > 0) AND @LoopCount <= 2000
BEGIN
  IF @IsBusinessDay > 0 AND @BusinessDayCount > 0
  BEGIN
    SET @BusinessDayCount = @BusinessDayCount - 1
  END

  SET @IsBusinessDay = 0

  SET @DayOfWeek = datepart(dw, @RetDate)
  -- Check if day is Monday to Friday
  IF @DayOfWeek BETWEEN 2 AND 6
  BEGIN
    SET @MonthOfYear = month(@RetDate)
    SET @DayOfMonth = day(@RetDate)

    -- Check for matching entry in Holiday table
    IF (SELECT count(*) TCount
    FROM #Temp_tbl_BankHoliday (NOLOCK)
    WHERE MonthOfYear = month(@RetDate)
    AND (YearAppliesTo IS NULL OR YearAppliesTo = year(@RetDate))
    AND (DayOfMonth = day(@RetDate)
    OR (DayOfWeek = @DayOfWeek AND day(@RetDate)
    BETWEEN DayOfMonthLBound AND DayOfMonthUBound))) = 0
    BEGIN
      IF @DayOfWeek = 2
      BEGIN
        -- Check if Saturday or Sunday preceding Monday was a holiday
        IF (SELECT count(*) TCount
        FROM #Temp_tbl_BankHoliday (NOLOCK)
        WHERE MonthOfYear = month(@RetDate - 1)
        AND (YearAppliesTo IS NULL OR YearAppliesTo = year(@RetDate - 1))
        AND (DayOfMonth = day(@RetDate - 1))) = 0
        AND (SELECT count(*) TCount
        FROM #Temp_tbl_BankHoliday (NOLOCK)
        WHERE MonthOfYear = month(@RetDate - 2)
        AND (YearAppliesTo IS NULL OR YearAppliesTo = year(@RetDate - 2))
        AND (DayOfMonth = day(@RetDate - 2))) = 0
        BEGIN
          SET @IsBusinessDay = 1
        END -- Saturday or Sunday preceding Monday was holiday
      END -- DayOfWeek = 2
      ELSE IF @DayOfWeek = 3
      BEGIN
        -- Check if Saturday and Sunday preceding Tuesday were both holidays.
        IF (SELECT count(*) TCount
        FROM #Temp_tbl_BankHoliday (NOLOCK)
        WHERE MonthOfYear = month(@RetDate - 2)
        AND (YearAppliesTo IS NULL OR YearAppliesTo = year(@RetDate - 2))
        AND (DayOfMonth = day(@RetDate - 2))) > 0
        AND (SELECT count(*) TCount
        FROM #Temp_tbl_BankHoliday (NOLOCK)
        WHERE MonthOfYear = month(@RetDate - 3)
        AND (YearAppliesTo IS NULL OR YearAppliesTo = year(@RetDate - 3))
        AND (DayOfMonth = day(@RetDate - 3))) > 0
        BEGIN
          SET @IsBusinessDay = 0
        END -- Both Saturday and Sunday were Holidays

        ELSE IF (SELECT count(*) TCount
        FROM #Temp_tbl_BankHoliday (NOLOCK)
        WHERE MonthOfYear = month(@RetDate - 1)
        AND (YearAppliesTo IS NULL OR YearAppliesTo = year(@RetDate - 1))
        AND (DayOfMonth = day(@RetDate - 1))) > 0
        AND (SELECT count(*) TCount
        FROM #Temp_tbl_BankHoliday (NOLOCK)
        WHERE MonthOfYear = month(@RetDate - 2)
        AND (YearAppliesTo IS NULL OR YearAppliesTo = year(@RetDate - 2))
        AND (DayOfMonth = day(@RetDate - 2))) > 0
        BEGIN
          SET @IsBusinessDay = 0
        END -- Sunday and Monday were holidays

        ELSE IF (SELECT count(*) TCount
        FROM #Temp_tbl_BankHoliday (NOLOCK)
        WHERE MonthOfYear = month(@RetDate - 1)
        AND (YearAppliesTo IS NULL OR YearAppliesTo = year(@RetDate - 1))
        AND (DayOfMonth = day(@RetDate - 1))) > 0
        AND (SELECT count(*) TCount
        FROM #Temp_tbl_BankHoliday (NOLOCK)
        WHERE MonthOfYear = month(@RetDate - 3)
        AND (YearAppliesTo IS NULL OR YearAppliesTo = year(@RetDate - 3))
        AND (DayOfMonth = day(@RetDate - 3))) > 0
        BEGIN
          SET @IsBusinessDay = 0
        END -- Saturday and Monday were holidays

        ELSE
        BEGIN
          SET @IsBusinessDay = 1
        END -- At least 2 of previous days were not holidays
      END -- DayOfWeek = 3
      ELSE
      BEGIN
        SET @IsBusinessDay = 1
      END -- Not Monday or Tuesday
    END -- No Holiday matching current date
  END -- Day of Week is Monday to Friday

  IF @IsBusinessDay = 0
  BEGIN
    SET @RetDate = @RetDate + 1
    IF @LoopCount = 0 AND @BusinessDayCount > 0
    BEGIN
      SET @BusinessDayCount = @BusinessDayCount - 1
    END
  END
  ELSE IF @BusinessDayCount > 0
  BEGIN
    SET @RetDate = @RetDate + 1
  END

  SET @LoopCount = @LoopCount + 1
END

SET @pDate = @RetDate

IF OBJECT_ID('tempdb..#Temp_tbl_BankHoliday') IS NOT NULL
	DROP TABLE #Temp_tbl_BankHoliday
END
GO
GRANT EXECUTE ON  [dbo].[usp_sys_GetNextBusinessDay] TO [WebV4Role]
GO
