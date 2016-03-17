SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_rep_GetTransactionCashierDetailForMSCT]
    @UserId bigint,
    @IsoId bigint,
    @CashierId bigint, /*allows null*/
    @TransactionType nvarchar(200),
    @StartDate datetime,
    @EndDate datetime,
    @TimeZone varchar(50)
WITH EXECUTE AS 'dbo'
AS
BEGIN
    SET NOCOUNT ON
	DECLARE @CurYear bigint,@CurDate BIGINT,@TotalRows BIGINT 
    SET @CurYear= DATEPART(yy,GETUTCDATE())

	IF GETUTCDATE()<DATEADD(HOUR,2,dbo.udf_GetSunday(@Curyear,3,2))
	   BEGIN 
         SET @StartDate=Convert(datetime, SWITCHOFFSET(CONVERT(VARCHAR, @StartDate, 20) + ' ' + @TimeZone,'+00:00'))
         SET @EndDate=Convert(datetime, SWITCHOFFSET(CONVERT(VARCHAR, @EndDate, 20) + ' ' + @TimeZone,'+00:00'))
       END
    ELSE IF GETUTCDATE() >= DATEADD(HOUR,2,dbo.udf_GetSunday(@Curyear,3,2)) AND GETUTCDATE() < DATEADD(HOUR,2,dbo.udf_GetSunday(@Curyear,11,1))
	   BEGIN
	     IF @StartDate<DATEADD(HOUR,2,dbo.udf_GetSunday(@Curyear,3,2)) AND @EndDate<DATEADD(HOUR,2,dbo.udf_GetSunday(@Curyear,3,2))
	      BEGIN 
		     SET @StartDate=DATEADD(HOUR,1,Convert(datetime, SWITCHOFFSET(CONVERT(VARCHAR, @StartDate, 20) + ' ' + @TimeZone,'+00:00')))
			 SET @EndDate=DATEADD(HOUR,1,Convert(datetime, SWITCHOFFSET(CONVERT(VARCHAR, @EndDate, 20) + ' ' + @TimeZone,'+00:00')))
           END
		 IF @StartDate<DATEADD(HOUR,2,dbo.udf_GetSunday(@Curyear,3,2)) AND @EndDate>=DATEADD(HOUR,2,dbo.udf_GetSunday(@Curyear,3,2))
		   BEGIN 
		     SET @StartDate=DATEADD(HOUR,1,Convert(datetime, SWITCHOFFSET(CONVERT(VARCHAR, @StartDate, 20) + ' ' + @TimeZone,'+00:00')))
			 SET @EndDate=Convert(datetime, SWITCHOFFSET(CONVERT(VARCHAR, @EndDate, 20) + ' ' + @TimeZone,'+00:00'))
           END
		 IF @StartDate>=DATEADD(HOUR,2,dbo.udf_GetSunday(@Curyear,3,2)) AND @EndDate>=DATEADD(HOUR,2,dbo.udf_GetSunday(@Curyear,3,2))
		   BEGIN 
		     SET @StartDate=Convert(datetime, SWITCHOFFSET(CONVERT(VARCHAR, @StartDate, 20) + ' ' + @TimeZone,'+00:00'))
			 SET @EndDate=Convert(datetime, SWITCHOFFSET(CONVERT(VARCHAR, @EndDate, 20) + ' ' + @TimeZone,'+00:00'))
           END
        END
    ELSE IF GETUTCDATE() >= DATEADD(HOUR,2,dbo.udf_GetSunday(@Curyear,11,1))
	    BEGIN
	     IF @StartDate<DATEADD(HOUR,2,dbo.udf_GetSunday(@Curyear,3,2)) AND @EndDate<DATEADD(HOUR,2,dbo.udf_GetSunday(@Curyear,3,2))
	       BEGIN 
		     SET @StartDate=Convert(datetime, SWITCHOFFSET(CONVERT(VARCHAR, @StartDate, 20) + ' ' + @TimeZone,'+00:00'))
			 SET @EndDate=Convert(datetime, SWITCHOFFSET(CONVERT(VARCHAR, @EndDate, 20) + ' ' + @TimeZone,'+00:00'))
           END
		 IF @StartDate<DATEADD(HOUR,2,dbo.udf_GetSunday(@Curyear,3,2)) AND @EndDate>=DATEADD(HOUR,2,dbo.udf_GetSunday(@Curyear,3,2)) AND @EndDate<DATEADD(HOUR,2,dbo.udf_GetSunday(@Curyear,11,1))
		   BEGIN 
		     SET @StartDate=Convert(datetime, SWITCHOFFSET(CONVERT(VARCHAR, @StartDate, 20) + ' ' + @TimeZone,'+00:00'))
			 SET @EndDate=DATEADD(HOUR,-1,Convert(datetime, SWITCHOFFSET(CONVERT(VARCHAR, @EndDate, 20) + ' ' + @TimeZone,'+00:00')))
           END
         IF @StartDate<DATEADD(HOUR,2,dbo.udf_GetSunday(@Curyear,3,2)) AND @EndDate>=DATEADD(HOUR,2,dbo.udf_GetSunday(@Curyear,11,1))
		   BEGIN 
		     SET @StartDate=Convert(datetime, SWITCHOFFSET(CONVERT(VARCHAR, @StartDate, 20) + ' ' + @TimeZone,'+00:00'))
			 SET @EndDate=Convert(datetime, SWITCHOFFSET(CONVERT(VARCHAR, @EndDate, 20) + ' ' + @TimeZone,'+00:00'))
           END

		 IF @StartDate>=DATEADD(HOUR,2,dbo.udf_GetSunday(@Curyear,3,2)) AND @StartDate<DATEADD(HOUR,2,dbo.udf_GetSunday(@Curyear,11,1)) AND @EndDate>=DATEADD(HOUR,2,dbo.udf_GetSunday(@Curyear,3,2)) AND @EndDate<DATEADD(HOUR,2,dbo.udf_GetSunday(@Curyear,11,1))
		   BEGIN 
		     SET @StartDate=DATEADD(HOUR,-1,Convert(datetime, SWITCHOFFSET(CONVERT(VARCHAR, @StartDate, 20) + ' ' + @TimeZone,'+00:00')))
			 SET @EndDate=DATEADD(HOUR,-1,Convert(datetime, SWITCHOFFSET(CONVERT(VARCHAR, @EndDate, 20) + ' ' + @TimeZone,'+00:00')))
           END
		 IF @StartDate>=DATEADD(HOUR,2,dbo.udf_GetSunday(@Curyear,3,2)) AND @StartDate<DATEADD(HOUR,2,dbo.udf_GetSunday(@Curyear,11,1)) AND @EndDate>=DATEADD(HOUR,2,dbo.udf_GetSunday(@Curyear,11,1)) 
		   BEGIN 
		     SET @StartDate=DATEADD(HOUR,-1,Convert(datetime, SWITCHOFFSET(CONVERT(VARCHAR, @StartDate, 20) + ' ' + @TimeZone,'+00:00')))
			 SET @EndDate=Convert(datetime, SWITCHOFFSET(CONVERT(VARCHAR, @EndDate, 20) + ' ' + @TimeZone,'+00:00'))
           END
		 
		 IF @StartDate>=DATEADD(HOUR,2,dbo.udf_GetSunday(@Curyear,11,1)) AND @EndDate>=DATEADD(HOUR,2,dbo.udf_GetSunday(@Curyear,11,1)) 
		   BEGIN 
		     SET @StartDate=Convert(datetime, SWITCHOFFSET(CONVERT(VARCHAR, @StartDate, 20) + ' ' + @TimeZone,'+00:00'))
			 SET @EndDate=Convert(datetime, SWITCHOFFSET(CONVERT(VARCHAR, @EndDate, 20) + ' ' + @TimeZone,'+00:00'))
           END
        END
	   
    DECLARE @Permission TABLE(Id bigint)
    INSERT INTO @Permission EXEC dbo.usp_upm_GetPermissionIds @UserId, 1

    DECLARE @SQL nvarchar(max)
    SET @SQL = N'
        DECLARE @TransactionTypeName TABLE (Name nvarchar(200))
        DECLARE @TransactionTypeValue TABLE (Value bigint)

        INSERT INTO @TransactionTypeName(Name) EXEC dbo.usp_sys_Split @TransactionType
        INSERT INTO @TransactionTypeValue(Value) SELECT Value FROM dbo.tbl_TypeValue WHERE TypeId=19 AND Name IN (SELECT Name FROM @TransactionTypeName)
        
        SELECT
            u.Id CashierId,
            CASE WHEN ISNULL(u.LastName, '''') + '','' + ISNULL(u.FirstName, '''')='','' THEN ''KIOSK'' ELSE ISNULL(u.LastName, '''') + '','' + ISNULL(u.FirstName, '''') END Cashier,
            d.IsoId,
            t.Id TransId,
			d.TerminalName,
            t.TransactionType TransactionTypeValue,
            CASE WHEN t.TransactionType=156 THEN ''ACH'' ELSE dbo.udf_GetTransactionTypeDesc(t.TransactionType,t.TransactionFlags) END TransactionTypeName,
            tv.Name MediaTypeName,
            ISNULL(c.LastName, '''') + '','' + ISNULL(c.FirstName, '''') Consumer,
            ISNULL(CASE WHEN t.TransactionType in (7,8,9,10,11,12,108) THEN RTRIM(t.BinRange)+''XXXXXX''+LTRIM(t.PAN) ELSE RTRIM(t.CustomerMediaDataPart1)+LTRIM(t.CustomerMediaDataPart2) END, '''') AccountNumber,
            t.DeviceDate DeviceDate,t.DeviceSequence,
            CONVERT(MONEY, CASE WHEN t.TransactionType<100 THEN t.AmountRequest ELSE -1*t.AmountRequest END)/100 RequestAmount,
            CONVERT(MONEY, CASE WHEN t.TransactionType=156 THEN -1*t.AmountRequest ELSE t.AmountSettlement-t.AmountSurcharge END)/100 DispensedAmount,
            CONVERT(MONEY, CASE WHEN t.TransactionType=156 THEN (SELECT -1*AmountSurcharge FROM dbo.tbl_trn_Transaction WITH (nolock) WHERE Id=t.OriginalTransactionId) ELSE t.AmountSurcharge END)/100 SurchargeAmount,
            CONVERT(MONEY, t.AmountSurcharge+t.AmountSurchargeWaived)/100 OriginalSurchargeAmount,
            CONVERT(MONEY, t.AmountSurchargeWaived)/100 WaivedSurchargeAmount,
			ISNULL(u1.LastName, '''') + SPACE(1) + ISNULL(u1.FirstName, '''') Supervisor
        FROM dbo.tbl_trn_Transaction t
            JOIN dbo.tbl_Device d ON d.IsoId = @IsoId AND t.DeviceId = d.Id
            LEFT JOIN dbo.tbl_upm_User u  ON t.CreatedUserId = u.Id
			LEFT JOIN dbo.tbl_upm_User u1 ON t.SurchargeWaiveAuthorityId= u1.Id
            LEFT JOIN dbo.tbl_Customer c ON t.CustomerId = c.Id
            LEFT JOIN dbo.tbl_typeValue tv ON t.CustomerMediaType = tv.Value AND tv.TypeId in (45,59)  -- /* CardType(45) & CheckType(59)*/
      	WHERE t.SystemTime >= @StartDate AND t.SystemTime <= @EndDate
              AND (t.TransactionType IN (SELECT Value FROM @TransactionTypeValue) 
              AND t.TransactionType in (7,9)   
              AND t.PayoutStatus >3   --debit sale and credit sale
			  OR t.TransactionType IN (SELECT Value FROM @TransactionTypeValue) 
              AND t.TransactionType =8 AND TransactionFlags & 0x00080000=0
              AND t.PayoutStatus =2   --POS debit pre-auth
			  OR t.TransactionType IN (SELECT Value FROM @TransactionTypeValue) 
              AND t.TransactionType =156
              AND t.PayoutStatus IS NULL   --ACH Reversal
              OR t.TransactionType IN (SELECT Value FROM @TransactionTypeValue)
              AND t.TransactionType NOT IN (7,9,8,108,109)
              AND  t.PayoutStatus >1            --the rest and check                     
             )
          AND t.ResponseCodeInternal = 0'
    IF @CashierId IS NOT NULL 
      SET @SQL = @SQL + N' AND t.CreatedUserId = @CashierId'  
    IF EXISTS (SELECT * FROM @Permission WHERE Id = 9998)  -- Permission=9998 means only viewing transaction created by himself is allowed
      SET @SQL = @SQL + N' AND t.CreatedUserId = @UserId'
    SET @SQL = @SQL + ' ORDER BY u.Id, TransactionTypeName, MediaTypeName, t.SystemTime '

    EXEC sp_executesql @SQL, N'@UserId bigint, @IsoId bigint, @CashierId bigint, @TransactionType nvarchar(200), @StartDate datetime, @EndDate datetime', @UserId, @IsoId, @CashierId, @TransactionType, @StartDate, @EndDate

END
GO
