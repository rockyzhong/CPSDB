SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_rep_GetTransactionLookup]
    @UserID bigint,
    @DeviceId bigint,
    @BatchId nvarchar(25),
    @StartDate datetime,
    @EndDate datetime,
    @TimeZone varchar(50)
WITH EXECUTE AS 'dbo'
AS
BEGIN
    SET NOCOUNT ON
-- only date--
    SELECT @StartDate=LEFT(Convert(datetime, SWITCHOFFSET(CONVERT(VARCHAR, @StartDate, 20) + ' ' + @TimeZone,'+00:00')),11)
    SELECT @EndDate=LEFT(DATEADD(DAY,1,Convert(datetime, SWITCHOFFSET(CONVERT(VARCHAR, @EndDate, 20) + ' ' + @TimeZone,'+00:00'))),11)

    DECLARE @SQL nvarchar(max)
    SET @SQL = N'
    DECLARE @Source TABLE(Id bigint)
    IF @UserId IS NOT NULL
      INSERT INTO @Source EXEC dbo.usp_upm_GetObjectIds @UserId,1,1

    SELECT 
        t.Id TransactionId, 
        d.Id TerminalId, 
        d.TerminalName, 
        t.DeviceSequence,
        t.DeviceDate, 
        t.IssuerNetworkId,
        tv1.Name TransactionType,
        t.ResponseCodeInternal,
        tv2.Name ResponseNameInternal,
        t.TransactionReason TransactionReasonCode,
        tv3.Name TransactionReasonName,
        t.BatchId,
        ''X'' + t.PAN PAN,
        tv4.Name SourceAccountType,
        CASE WHEN(tv5.Value&0x02000000=0x02000000) THEN 0 ELSE 1 END  [Chip Card],
        CASE WHEN(tv5.Value&0x01000000=0x01000000) THEN 0 ELSE 1 END  [Chip Txn],
        CONVERT(MONEY, t.AmountRequest)/100 RequestedAmount,
        CONVERT(MONEY, t.AmountAuthenticate)/100 AuthenticateAmount,
        CONVERT(MONEY, t.AmountSettlement-t.AmountSurcharge)/100 DispensedAmount,
        CONVERT(MONEY, t.AmountSurcharge)/100 SurchargeAmount,
        CONVERT(MONEY, t.AmountCashBack)/100 CashBackAmount,
        CONVERT(MONEY, t.AmountConvinience)/100 ConvinienceAmount
    FROM dbo.tbl_trn_Transaction t
    JOIN dbo.tbl_Device d ON t.DeviceId=d.Id
    LEFT JOIN dbo.tbl_TypeValue tv1 ON t.TransactionType     =tv1.Value AND tv1.TypeId=19
    LEFT JOIN dbo.tbl_TypeValue tv2 ON t.ResponseCodeInternal=tv2.Value AND tv2.TypeId=105
    LEFT JOIN dbo.tbl_TypeValue tv3 ON t.TransactionReason   =tv3.Value AND tv3.TypeId=129
    LEFT JOIN dbo.tbl_TypeValue tv4 ON t.SourceAccountType   =tv4.Value AND tv4.TypeId=145
    LEFT JOIN dbo.tbl_TypeValue tv5 ON t.TransactionFlags    =tv5.Value AND tv5.TypeId=127
    
    WHERE t.SystemTime >= @StartDate AND t.SystemTime <= @EndDate'
    IF @UserId IS NOT NULL
      SET @SQL=@SQL+N' AND t.DeviceId IN (SELECT Id FROM @Source)'
    IF @DeviceId IS NOT NULL 
      SET @SQL=@SQL+N' AND t.DeviceId = @DeviceId'
    IF @BatchId IS NOT NULL 
    SET @SQL=@SQL+N' AND t.BatchId = @BatchId'
    SET @SQL=@SQL+N' ORDER BY d.TerminalName,t.DeviceDate'

    EXEC sp_executesql @SQL, N'@UserID bigint, @DeviceId bigint, @BatchId nvarchar(25), @StartDate datetime, @EndDate datetime', @UserID, @DeviceId, @BatchId, @StartDate, @EndDate
END
GO
