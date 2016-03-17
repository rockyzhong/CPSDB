SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[usp_rep_GetTransactionInterchange]
    @UserID bigint,
    @DeviceId bigint,
    @StartDate datetime,
    @EndDate datetime
WITH EXECUTE AS 'dbo'
AS
BEGIN
    SET NOCOUNT ON

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
        t.SystemDate, 
        tv1.Name TransactionType,
        ''X'' + t.PAN PAN,
        t.IssuerNetworkId,
        CONVERT(MONEY, t.AmountRequest)/100 RequestedAmount,
        CONVERT(MONEY, t.AmountSettlement-t.AmountSurcharge)/100 DispensedAmount,
        CONVERT(MONEY, t.AmountSurcharge)/100 SurchargeAmount,
        CONVERT(MONEY, tf.AmountInterchangePaid)/100 InterchangeAmountPaid,
        CONVERT(MONEY, t.AmountSettlement+tf.AmountInterchangePaid)/100 TotalAmount
    FROM dbo.tbl_trn_Transaction t
    JOIN dbo.tbl_Device d ON t.DeviceId=d.Id
    JOIN dbo.tbl_trn_TransactionAmountInter tf ON t.Id=tf.TranId
    LEFT JOIN dbo.tbl_TypeValue tv1 ON t.TransactionType=tv1.Value AND tv1.TypeId=19
    WHERE t.SystemSettlementDate >= @StartDate AND t.SystemSettlementDate <= @EndDate AND tf.InterchangeAmountPaid>0'
    IF @UserId IS NOT NULL
      SET @SQL=@SQL+N' AND t.DeviceId IN (SELECT Id FROM @Source)'
    IF @DeviceId IS NOT NULL 
      SET @SQL=@SQL+N' AND t.DeviceId = @DeviceId'
    SET @SQL=@SQL+N' ORDER BY d.TerminalName,t.SystemDate'

    EXEC sp_executesql @SQL, N'@UserID bigint, @DeviceId bigint, @StartDate datetime, @EndDate datetime', @UserID, @DeviceId, @StartDate, @EndDate
END
GO
