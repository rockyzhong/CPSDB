SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_rep_GetTransactionPatronSummaryForISO]
    @UserId bigint,
    @IsoId bigint,
	@CustomerId bigint,
    @TransactionType nvarchar(200),
    @StartDate datetime,
    @EndDate datetime,
    @TimeZone varchar(50)
WITH EXECUTE AS 'dbo'
AS
BEGIN
    SET NOCOUNT ON

    SELECT @StartDate=Convert(datetime, SWITCHOFFSET(CONVERT(VARCHAR, @StartDate, 20) + ' ' + @TimeZone,'+00:00'))
    SELECT @EndDate=Convert(datetime, SWITCHOFFSET(CONVERT(VARCHAR, @EndDate, 20) + ' ' + @TimeZone,'+00:00'))

    DECLARE @Permission TABLE(Id bigint)
    INSERT INTO @Permission EXEC dbo.usp_upm_GetPermissionIds @UserId, 1

    DECLARE @SQL nvarchar(max)
    SET @SQL = N'
    DECLARE @TransactionTypeName TABLE (Name nvarchar(200))
    DECLARE @TransactionTypeValue TABLE (Value bigint)

    INSERT INTO @TransactionTypeName(Name) EXEC dbo.usp_sys_Split @TransactionType
    INSERT INTO @TransactionTypeValue(Value) SELECT Value FROM dbo.tbl_TypeValue WHERE TypeId=19 AND Name IN (SELECT Name FROM @TransactionTypeName)

    SELECT
        t.CustomerId,
        ISNULL(c.LastName, '''') + '','' + ISNULL(c.FirstName, '''') CustomerName,
        ISNULL(c.IdNumber,'''')  IdNumber,
        ISNULL(c.IdState, '''')  IdState,
        CONVERT(MONEY, SUM(CASE WHEN t.TransactionType<100 THEN t.AmountRequest ELSE -1*t.AmountRequest END))/100 RequestAmount,
        CONVERT(MONEY, SUM(CASE WHEN t.TransactionType=8 THEN t.AmountRequest WHEN t.TransactionType=108 THEN -1*t.AmountRequest ELSE t.AmountSettlement-t.AmountSurcharge END))/100 DispensedAmount,
        CONVERT(MONEY, AVG(t.AmountSettlement-t.AmountSurcharge))/100 AvgDispensedAmount,
        CONVERT(MONEY, SUM(t.AmountSurcharge))/100 SurchargeAmount,
        CONVERT(MONEY, SUM(t.AmountSurcharge+t.AmountSurchargeWaived))/100 OriginalSurchargeAmount,
        CONVERT(MONEY, SUM(t.AmountSurchargeWaived))/100 WaivedSurchargeAmount,
        COUNT(*) TransactionCount
    FROM dbo.tbl_trn_Transaction t
    JOIN dbo.tbl_Device d ON t.DeviceId = d.Id AND d.IsoId = @IsoId
    LEFT JOIN dbo.tbl_Customer c ON t.CustomerId = c.Id
    WHERE t.SystemTime >= @StartDate AND t.SystemTime <= @EndDate
      AND
      (t.TransactionType IN (SELECT Value FROM @TransactionTypeValue) 
              AND t.TransactionType in (7,9)   
              AND t.PayoutStatus >3   --debit sale and credit sale
              OR t.TransactionType IN (SELECT Value FROM @TransactionTypeValue)
              AND t.TransactionType NOT IN (7,9,8,108,109)
              AND  t.PayoutStatus >2            --the rest and check     
      ) 
      AND t.ResponseCodeInternal = 0'
    IF @CustomerId IS NOT NULL 
      SET @SQL = @SQL + N' AND t.CustomerId = @CustomerId'
    IF EXISTS (SELECT * FROM @Permission WHERE Id = 9998) -- Permission=9998 means only viewing transaction created by himself is allowed
      SET @SQL = @SQL + N' AND t.CreatedUserId = @UserId' 
    SET @SQL = @SQL + N' GROUP BY t.CustomerId,ISNULL(c.LastName, '''') + '','' + ISNULL(c.FirstName, ''''),c.IdNumber,c.IdState ORDER BY 2'

    EXEC sp_executesql @SQL, N'@UserId bigint, @IsoId bigint, @CustomerId bigint, @TransactionType nvarchar(200), @StartDate datetime, @EndDate datetime', @UserId, @IsoId, @CustomerId, @TransactionType, @StartDate, @EndDate
END
GO
GRANT EXECUTE ON  [dbo].[usp_rep_GetTransactionPatronSummaryForISO] TO [WebV4Role]
GO
