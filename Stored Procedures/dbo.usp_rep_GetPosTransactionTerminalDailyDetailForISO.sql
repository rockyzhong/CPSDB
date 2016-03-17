SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[usp_rep_GetPosTransactionTerminalDailyDetailForISO]
    @UserID bigint,
    @IsoID bigint,
    @TerminalId bigint,
    @TransactionType nvarchar(200),
    @StartDate DATETIME,
	@EndDate DATETIME
	 
WITH EXECUTE AS 'dbo'
AS
BEGIN
    SET NOCOUNT ON

    DECLARE @SQL nvarchar(max)
    SET @SQL = N'
    DECLARE @TransactionTypeName TABLE (Name nvarchar(200))
    DECLARE @TransactionTypeValue TABLE (Value bigint)

    INSERT INTO @TransactionTypeName(Name) EXEC dbo.usp_sys_Split @TransactionType
    INSERT INTO @TransactionTypeValue(Value) SELECT Value FROM dbo.tbl_TypeValue WHERE TypeId=19 AND Name IN (SELECT Name FROM @TransactionTypeName)
	 

    SELECT 
        t.Id TransactionId, 
        d.Id TerminalId, 
        d.TerminalName, 
        t.DeviceSequence,
        t.DeviceDate, 
        tv.Name TransactionType,
        CASE WHEN t.TransactionFlags & 0x00080000 = 0 THEN ''Debit'' ELSE ''Credit'' END [Type],
        ''X'' + t.PAN PAN,
        CONVERT(MONEY, t.AmountRequest)/100 RequestedAmount,
        CONVERT(MONEY, t.AmountSettlement-t.AmountSurcharge)/100 DispensedAmount,
        CONVERT(MONEY, t.AmountSurcharge)/100 SurchargeAmount,
        CASE WHEN t.TransactionFlags & 0x00080000 > 0 THEN CONVERT(MONEY,t.AmountCommission)/100 ELSE 0 END NRTCredit,
        CASE WHEN t.TransactionFlags & 0x00080000 > 0 THEN CONVERT(MONEY,t.AmountSurcharge-t.AmountCommission)/100 ELSE 0 END CasinoCredit,
        CASE WHEN t.TransactionFlags & 0x00080000 = 0 THEN CONVERT(MONEY,t.AmountCommission)/100 ELSE 0 END NRTDebit,
        CASE WHEN t.TransactionFlags & 0x00080000 = 0 THEN CONVERT(MONEY,t.AmountSurcharge-t.AmountCommission)/100 ELSE 0 END CasinoDebit
    FROM tbl_trn_Transaction t
    JOIN dbo.tbl_Device d ON d.IsoId = @IsoId AND t.DeviceId = d.Id
    LEFT JOIN dbo.tbl_TypeValue tv ON t.TransactionType = tv.Value AND tv.TypeId=19
    WHERE t.SystemTime Between @StartDate AND @EndDate
      AND t.TransactionType IN (SELECT Value FROM @TransactionTypeValue)'
    IF @TerminalId IS NOT NULL 
      SET @SQL = @SQL + N' AND t.DeviceId = @TerminalId'
    SET @SQL = @SQL + N' ORDER BY t.DeviceDate'

    EXEC sp_executesql @SQL, N'@UserID bigint, @IsoID bigint, @TerminalId bigint, @TransactionType nvarchar(200), @StartDate datetime, @EndDate DATETIME', @UserID, @IsoID, @TerminalId, @TransactionType, @StartDate, @EndDate
END
GO
GRANT EXECUTE ON  [dbo].[usp_rep_GetPosTransactionTerminalDailyDetailForISO] TO [WebV4Role]
GO
