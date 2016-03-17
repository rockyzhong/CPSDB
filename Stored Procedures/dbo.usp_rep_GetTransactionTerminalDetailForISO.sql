SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_rep_GetTransactionTerminalDetailForISO]
    @UserId bigint,
    @IsoId bigint,
    @TransactionType nvarchar(200),
    @StartDate datetime,
    @EndDate datetime,
    @TimeZone varchar(50),
    @TerminalName varchar(13)=0  -- '0' - Select all [dbo].[tbl_Device].TerminalName
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
        DECLARE @AchTransaction TABLE(DeviceId bigint,SettlementTime datetime)
        INSERT INTO @AchTransaction(DeviceId,SettlementTime) SELECT SourceId,MAX(SettlementTime) FROM dbo.tbl_AchTransaction WHERE FundsType=1 AND SettlementType=1 GROUP BY SourceId
    
        DECLARE @TransactionTypeName TABLE (Name nvarchar(200))
        DECLARE @TransactionTypeValue TABLE (Value bigint)

        INSERT INTO @TransactionTypeName(Name) EXEC dbo.usp_sys_Split @TransactionType
        INSERT INTO @TransactionTypeValue(Value) SELECT Value FROM dbo.tbl_TypeValue WHERE TypeId=19 AND Name IN (SELECT Name FROM @TransactionTypeName)

        SELECT
            t.Id,
            t.DeviceId,
            CASE WHEN d.ReportName IS NOT NULL THEN d.TerminalName+'' - ''+d.ReportName ELSE d.TerminalName END TerminalName,
            dm.Model DeviceModel,
            t.CustomerId,
            ISNULL(u.LastName, '''') + '','' + ISNULL(u.FirstName, '''') Cashiername,
            ISNULL(c.LastName, '''') + '','' + ISNULL(c.FirstName, '''') CustomerName,
            dbo.udf_GetTransactionTypeDesc(t.TransactionType,t.TransactionFlags) TransactionTypeName,
            CASE WHEN t.TransactionType=8 THEN '''' ELSE tv.Name END MediaTypeName,
            CASE WHEN t.TransactionType<50 OR (t.TransactionType>100 AND t.TransactionType<150) THEN t.PAN ELSE RIGHT(CustomerMediaDataPart2,5) END MediaNumber,
            t.DeviceDate DeviceDate,t.DeviceSequence,
            CONVERT(MONEY, CASE WHEN t.TransactionType < 100 THEN t.AmountRequest ELSE -1*t.AmountRequest END)/100 RequestAmount,
            CONVERT(MONEY, CASE WHEN t.TransactionType=8 THEN t.AmountRequest WHEN t.TransactionType=108 THEN -1*t.AmountRequest ELSE t.AmountSettlement-t.AmountSurcharge END)/100 DispensedAmount,
            CONVERT(MONEY, t.AmountSurcharge)/100 SurchargeAmount
        FROM dbo.tbl_trn_Transaction t
        JOIN dbo.tbl_Device d ON t.DeviceId = d.Id AND d.IsoId = @IsoId
        LEFT JOIN dbo.tbl_Device e ON t.SourceDeviceId = e.Id
        LEFT JOIN dbo.tbl_upm_User u ON t.CreatedUserId = u.Id
        LEFT JOIN dbo.tbl_Customer c ON t.CustomerId = c.Id 
        LEFT JOIN dbo.tbl_Address a on c.AddressId = a.Id 
        LEFT JOIN dbo.tbl_DeviceModel dm on e.ModelId = dm.Id
        LEFT JOIN dbo.tbl_typeValue tv ON t.CustomerMediaType = tv.Value AND tv.TypeId in (45,59)        -- CardType(45) & CheckType(59)
        LEFT JOIN @AchTransaction h ON h.DeviceId=t.DeviceId
        WHERE t.SystemTime >= @StartDate AND t.SystemTime <= @EndDate
        AND
          (t.TransactionType IN (SELECT Value FROM @TransactionTypeValue) 
              AND t.TransactionType in (7,9)   
              AND t.PayoutStatus >3   --debit sale and credit sale
              OR t.TransactionType IN (SELECT Value FROM @TransactionTypeValue) 
              AND t.TransactionType in (108,109) 
              AND t.PayoutStatus >3    
              AND t.TransactionFlags & 0x0080000=0   --debit return positive
              OR t.TransactionType IN (SELECT Value FROM @TransactionTypeValue) 
              AND t.TransactionType =8 
              AND t.PayoutStatus =2   
              AND t.TransactionFlags & 0x0080000=0   --debit return negative
              OR t.TransactionType IN (SELECT Value FROM @TransactionTypeValue)
              AND t.TransactionType NOT IN (7,9,8,108,109)
              AND  t.PayoutStatus >2            --the rest and check  
          ) 
          AND t.ResponseCodeInternal = 0'
    IF @TerminalName <>  '0' 
      SET @SQL = @SQL + N' AND d.TerminalName = @TerminalName'
    IF EXISTS (SELECT * FROM @Permission WHERE Id = 9998) -- Permission=9998 means only viewing transaction created by himself is allowed
      SET @SQL = @SQL + N' AND t.CreatedUserId = @UserId' 
  

    EXEC sp_executesql @SQL, N'@UserId bigint, @IsoId bigint, @TerminalName varchar(13), @TransactionType nvarchar(200), @StartDate datetime, @EndDate datetime',@UserId, @IsoId, @TerminalName, @TransactionType, @StartDate, @EndDate
END
GO
