SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_rep_GetTransactionBalanceSummaryForISO]
-- This SP for Turning Stone 
    @UserId bigint,
    @IsoId bigint,
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
		    Count(*),
			ISNULL(CONVERT(MONEY,SUM(CASE WHEN t.TransactionType < 100 THEN t.AmountRequest ELSE -1*t.AmountRequest END))/100,0) TotalAmount,
			ISNULL(CONVERT(MONEY,SUM(t.AmountSurcharge))/100,0) TotalFees,
            ISNULL(CONVERT(MONEY,SUM(CASE WHEN t.TransactionType < 100 THEN t.AmountRequest ELSE -1*t.AmountRequest END))/100+CONVERT(MONEY,SUM(t.AmountSurcharge))/100,0) GrandTotal
        FROM dbo.tbl_trn_Transaction t
            JOIN dbo.tbl_Device d ON d.IsoId = @IsoId AND t.DeviceId = d.Id
            LEFT JOIN dbo.tbl_upm_User u  ON t.CreatedUserId = u.Id
            LEFT JOIN dbo.tbl_Customer c ON t.CustomerId = c.Id
			LEFT JOIN dbo.tbl_address a ON c.AddressId=a.id
			LEFT JOIN dbo.tbl_CustomerMembership cm ON cm.isoid= @IsoId AND t.CustomerId=cm.CustomerId
            LEFT JOIN dbo.tbl_typeValue tv ON t.CustomerMediaType = tv.Value AND tv.TypeId in (45,59)  -- /* CardType(45) & CheckType(59)*/
      	WHERE t.SystemTime >= @StartDate AND t.SystemTime <= @EndDate
              AND (t.TransactionType IN (SELECT Value FROM @TransactionTypeValue) 
              AND t.TransactionType in (7,9)   
              AND t.PayoutStatus >3   --debit sale and credit sale
              OR t.TransactionType IN (SELECT Value FROM @TransactionTypeValue) 
              AND t.TransactionType NOT IN (7,9,8,108,109)
              AND  t.PayoutStatus >2            --the rest and check                       
             )
          AND t.ResponseCodeInternal = 0'

     
    IF EXISTS (SELECT * FROM @Permission WHERE Id = 9998)  -- Permission=9998 means only viewing transaction created by himself is allowed
      SET @SQL = @SQL + N' AND t.CreatedUserId = @UserId'

    EXEC sp_executesql @SQL, N'@UserId bigint, @IsoId bigint, @TransactionType nvarchar(200), @StartDate datetime, @EndDate datetime', @UserId, @IsoId, @TransactionType, @StartDate, @EndDate
END
GO
