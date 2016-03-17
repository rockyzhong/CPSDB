SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_rep_GetFundingForISO]  
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
	DECLARE @BusinessTime nvarchar(4)
	SELECT @BusinessTime=BusinessTime FROM tbl_iso where Id=@IsoId
	SET @StartDate=@StartDate + convert(time,left(@BusinessTime,2)+':'+right(@BusinessTime,2))
	SET @EndDate=@EndDate + convert(time,left(@BusinessTime,2)+':'+right(@BusinessTime,2))
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
		    t.Id Transid,  --transactionID
            t.DeviceSequence,  
            t.DeviceId, 
			t.AuthenticationNumber AuthCode, --auth code
			t.ReferenceNumber ReferenceNumber , --reference number
            d.TerminalName TerminalName,     --TerminalID               
            ISNULL(tv.Description,'''') CardType,     -- Card type     
            t.DeviceDate DeviceDate, --TransactionDate+TransactionTime
            CONVERT(MONEY, CASE WHEN t.TransactionType=8 THEN t.AmountRequest WHEN t.TransactionType=108 THEN -1*t.AmountRequest ELSE t.AmountSettlement-t.AmountSurcharge END)/100 DispensedAmount  --amount funded
        FROM dbo.tbl_trn_Transaction t
        JOIN dbo.tbl_Device d ON t.DeviceId = d.Id AND d.IsoId = @IsoId
        LEFT JOIN dbo.tbl_Device e ON t.SourceDeviceId = e.Id
        LEFT JOIN dbo.tbl_upm_User u ON t.CreatedUserId = u.Id
        LEFT JOIN dbo.tbl_typeValue tv ON t.CustomerMediaType = tv.Value AND tv.TypeId in (45)        -- CardType(45) 
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
              AND t.TransactionType IN (1)
              AND  t.PayoutStatus >2            --the rest and check  
			  
          ) 
          AND t.ResponseCodeInternal = 0'
    IF EXISTS (SELECT * FROM @Permission WHERE Id = 9998) -- Permission=9998 means only viewing transaction created by himself is allowed
      SET @SQL = @SQL + N' AND t.CreatedUserId = @UserId' 
  

    EXEC sp_executesql @SQL, N'@UserId bigint, @IsoId bigint, @TransactionType nvarchar(200), @StartDate datetime, @EndDate datetime',@UserId, @IsoId, @TransactionType, @StartDate, @EndDate
END
GO
