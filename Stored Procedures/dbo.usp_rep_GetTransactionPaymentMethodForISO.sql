SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[usp_rep_GetTransactionPaymentMethodForISO]
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
            t.Id TransId,
            t.TransactionType TransactionTypeValue,
            dbo.udf_GetTransactionTypeDesc(t.TransactionType,t.TransactionFlags) TransactionTypeName,
            CASE WHEN t.TransactionType=8 THEN '''' ELSE tv.Name END MediaTypeName,
			ISNULL(c.LastName, '''') + SPACE(1) + ISNULL(c.FirstName, '''') Consumer,      
            ISNULL(CASE WHEN t.TransactionType in (7,8,9,10,11,12,108) THEN RTRIM(t.BinRange)+''XXXXXX''+LTRIM(t.PAN) ELSE RTRIM(t.CustomerMediaDataPart1)+LTRIM(t.CustomerMediaDataPart2) END, '''') AccountNumber,
            t.DeviceDate DeviceDate,       
            CONVERT(MONEY, CASE WHEN t.TransactionType=8 THEN t.AmountRequest WHEN t.TransactionType=108 THEN -1*t.AmountRequest ELSE t.AmountSettlement-t.AmountSurcharge END)/100 DispensedAmount,      
            ISNULL(CONVERT(MONEY,p.Amount)/100,CONVERT(MONEY, CASE WHEN t.TransactionType=8 THEN t.AmountRequest WHEN t.TransactionType=108 THEN -1*t.AmountRequest ELSE t.AmountSettlement-t.AmountSurcharge END)/100) Amount,
            ISNULL(i.DisplayName,ISNULL(tv2.Name,''Cash'')) PaymentName
        FROM dbo.tbl_trn_Transaction t
            JOIN dbo.tbl_Device d ON d.IsoId = @IsoId AND t.DeviceId = d.Id
			LEFT JOIN dbo.tbl_Customer c ON t.CustomerId = c.Id
            LEFT JOIN dbo.tbl_trn_TransactionPaymentMethod p  ON p.TransId = t.Id
            LEFT JOIN dbo.tbl_typeValue tv ON t.CustomerMediaType = tv.Value AND tv.TypeId = 45  -- /* CardType(45) */
            LEFT JOIN dbo.tbl_IsoPaymentMethod i ON p.PaymentId=i.PaymentId AND i.IsoId=@IsoId
            LEFT JOIN dbo.tbl_typeValue tv2 ON p.PaymentID=tv2.value AND tv2.TypeId=195    -- /* Payment Option(195) */
        WHERE t.SystemDate between @StartDate AND @EndDate
              AND t.TransactionType IN (SELECT Value FROM @TransactionTypeValue)
              AND t.PayoutStatus =5 AND t.ResponseCodeInternal = 0' 
    IF EXISTS (SELECT * FROM @Permission WHERE Id = 9998)  -- Permission=9998 means only viewing transaction created by himself is allowed
      SET @SQL = @SQL + N' AND t.CreatedUserId = @UserId'
    SET @SQL = @SQL + ' ORDER BY TransactionTypeName, MediaTypeName, t.SystemTime'

    EXEC sp_executesql @SQL, N'@UserId bigint, @IsoId bigint, @TransactionType nvarchar(200), @StartDate datetime, @EndDate datetime', @UserId, @IsoId, @TransactionType, @StartDate, @EndDate
END
GO
