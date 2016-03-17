SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_rep_GetTransactionReversal]
    @UserID bigint,
    @DeviceId bigint,
    @TransactionType nvarchar(200),
    @StartDate datetime,
    @EndDate datetime
WITH EXECUTE AS 'dbo'
AS
BEGIN
    SET NOCOUNT ON
    
    IF @TransactionType=N'ATM Transactions'                   SET @TransactionType=N'WTH,INQ,TSF,DEP,STM,NFO,RWT,RTS,RDP'
    ELSE IF @TransactionType IN (N'POS Debit',N'POS Credit')  SET @TransactionType=N'PUR,PRE,PAC,RET,VSA,VRE,RPU,RPR,RPA,RRT,RVS,RVR'

    DECLARE @SQL nvarchar(max)
    SET @SQL = N'
    DECLARE @Source TABLE(Id bigint)
    IF @UserId IS NOT NULL
      INSERT INTO @Source EXEC dbo.usp_upm_GetObjectIds @UserId,1,1

    DECLARE @TransactionTypeName TABLE (Name nvarchar(200))
    DECLARE @TransactionTypeValue TABLE (Value bigint)
    IF @TransactionType IS NOT NULL
    BEGIN
      INSERT INTO @TransactionTypeName(Name) EXEC dbo.usp_sys_Split @TransactionType
      INSERT INTO @TransactionTypeValue(Value) SELECT Value FROM dbo.tbl_TypeValue WHERE TypeId=19 AND Name IN (SELECT Name FROM @TransactionTypeName)
    END  

    SELECT 
        t.Id TransactionId, 
        d.Id TerminalId, 
        d.TerminalName, 
        t.DeviceSequence,
        t.SystemDate, 
        tv.Name TransactionType,
        t.ResponseCodeInternal,
        ''X'' + t.PAN PAN,
        CONVERT(money, t.AmountRequest)/100 RequestedAmount,
        CONVERT(money, t.AmountSettlement-t.AmountSurcharge+r.AmountSettlement-r.AmountSurcharge)/100 DispensedAmount,
        CONVERT(money, t.AmountSurcharge+r.AmountSurcharge)/100 SurchargeAmount
    FROM dbo.tbl_trn_Transaction t
    JOIN dbo.tbl_trn_Transaction r ON r.OriginalTransactionId=t.Id
    JOIN dbo.tbl_Device d ON t.DeviceId=d.Id
    LEFT JOIN dbo.tbl_TypeValue tv ON t.TransactionType=tv.Value AND tv.TypeId=19
    WHERE t.SystemSettlementDate >= @StartDate AND t.SystemSettlementDate <= @EndDate  AND t.ReversalType>0'
    IF @UserId IS NOT NULL
      SET @SQL=@SQL+N' AND t.DeviceId IN (SELECT Id FROM @Source)'
    IF @DeviceId IS NOT NULL 
      SET @SQL=@SQL+N' AND t.DeviceId = @DeviceId'
    IF @TransactionType IS NOT NULL
      SET @SQL=@SQL+N' AND t.TransactionType IN (SELECT Value FROM @TransactionTypeValue)'
    IF @TransactionType=N'POS Debit'
      SET @SQL=@SQL+N' AND t.TransactionFlags & 0x00080000=0'
    IF @TransactionType=N'POS Credit'
      SET @SQL=@SQL+N' AND t.TransactionFlags & 0x00080000<>0'
    SET @SQL=@SQL+N' ORDER BY d.TerminalName,t.SystemDate'

    EXEC sp_executesql @SQL, N'@UserID bigint, @DeviceId bigint, @TransactionType nvarchar(200), @StartDate datetime, @EndDate datetime', @UserID, @DeviceId, @TransactionType, @StartDate, @EndDate
END
GO
