SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_rep_GetTransTerminalNoSetDateSumForISO]
    @UserId bigint,
    @IsoId bigint,
    @TransactionType nvarchar(200),
    @StartDate datetime,
    @EndDate datetime,
    @TimeZone varchar(50),
    @TerminalName varchar(13)=0 -- '0' - Select all [dbo].[tbl_Device].TerminalName
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
        
        DECLARE @TransactiontypeDesc TABLE (Id bigint,typedesc nvarchar(200))
        INSERT INTO @TransactionTypeDesc(Id,typedesc) SELECT tr.Id,dbo.udf_GetTransactionTypeDesc(tr.TransactionType,tr.TransactionFlags) From dbo.tbl_trn_Transaction tr JOIN dbo.tbl_Device d ON tr.DeviceId = d.Id AND d.IsoId = @IsoId where tr.SystemDate >= @StartDate AND tr.SystemDate <= @EndDate

        SELECT
            t.DeviceId,
            ISNULL(u.LastName, '''') + '','' + ISNULL(u.FirstName, '''') Cashiername,
            CASE WHEN MAX(d.ReportName) IS NOT NULL THEN MAX(d.TerminalName+'' - ''+d.ReportName) ELSE MAX(d.TerminalName) END TerminalName,
            t.TransactionType,
            MAX(dm.Model) DeviceModel,
            MAX(td.typedesc) TransactionTypeName,
            CONVERT(MONEY, SUM(CASE WHEN t.TransactionType < 100 THEN t.AmountRequest ELSE -1*t.AmountRequest END))/100 RequestAmount,
            CONVERT(MONEY, SUM(CASE WHEN t.TransactionType=8 THEN t.AmountRequest WHEN t.TransactionType=108 THEN -1*t.AmountRequest ELSE t.AmountSettlement-t.AmountSurcharge END))/100 DispensedAmount,
            CONVERT(MONEY, SUM(t.AmountSurcharge))/100 SurchargeAmount,
            CONVERT(MONEY,SUM(t.AmountSurchargeWaived))/100 AmountSurchargeWaived,
            COUNT(*) AS TransactionCount
        FROM dbo.tbl_trn_Transaction t
        JOIN dbo.tbl_Device d ON t.DeviceId = d.Id AND d.IsoId = @IsoId
        LEFT JOIN @TransactionTypeDesc td on td.Id = t.Id  
        LEFT JOIN dbo.tbl_DeviceModel dm on d.ModelId = dm.Id
        LEFT JOIN dbo.tbl_upm_User u ON t.CreatedUserId = u.Id
        WHERE t.SystemDate >= @StartDate AND t.SystemDate <= @EndDate
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
    
    SET @SQL = @SQL + N' GROUP BY t.DeviceId,ISNULL(u.LastName, '''') + '','' + ISNULL(u.FirstName, ''''),t.transactiontype' 

    EXEC sp_executesql @SQL, N'@UserId bigint, @IsoId bigint, @TerminalName varchar(13), @TransactionType nvarchar(200), @StartDate datetime, @EndDate datetime',@UserId, @IsoId, @TerminalName, @TransactionType, @StartDate, @EndDate
END
GO
