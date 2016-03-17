SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_rep_GetTransactionTerminalSummaryForISO]
    @UserID bigint,
    @IsoID bigint,
    @TransactionType nvarchar(200),
    @StartSettDate datetime,
    @EndSettDate datetime,
    @GroupBySettDate INT,
    @StartTimeZone VARCHAR(10),
	@EndTimeZone VARCHAR(10)
AS
BEGIN
    SET NOCOUNT ON
    
    -- Convert transaction type from name to value
    DECLARE @TransactionTypeName TABLE (Name nvarchar(200))
    DECLARE @TransactionTypeValue TABLE (Value bigint)
    DECLARE @StartUTCTime datetime,@EndUTCTime DATETIME,@CutOverTime NVARCHAR(4) 

    INSERT INTO @TransactionTypeName(Name) EXEC dbo.usp_sys_Split @TransactionType
    INSERT INTO @TransactionTypeValue(Value) SELECT Value FROM dbo.tbl_TypeValue WHERE TypeId=19 AND Name IN (SELECT Name FROM @TransactionTypeName)
    
	SELECT @CutOverTime=ISNULL(CutOverTime,'0000') FROM dbo.tbl_IsoSetCutover WHERE IsoId=@IsoID
	
	--SET @StartUTCTime=DATEADD(MINUTE,CONVERT(BIGINT,RIGHT(@CutOverTime,2)),DATEADD(HOUR,CONVERT(BIGINT,LEFT(@CutOverTime,2)),@StartSettDate))
    --SET @StartUTCTime=Convert(datetime, SWITCHOFFSET(CONVERT(VARCHAR, @StartUTCTime, 20) + ' ' + @StartTimeZone,'+00:00'))
	--SET @EndUTCTime=DATEADD(MINUTE,CONVERT(BIGINT,RIGHT(@CutOverTime,2)),DATEADD(HOUR,CONVERT(BIGINT,LEFT(@CutOverTime,2)),@EndSettDate))
    --SET @EndUTCTime=Convert(datetime, SWITCHOFFSET(CONVERT(VARCHAR, @EndUTCTime, 20) + ' ' + @EndTimeZone,'+00:00'))
	 
	SET @StartSettDate=DATEADD(MINUTE,CONVERT(BIGINT,RIGHT(@CutOverTime,2)),DATEADD(HOUR,CONVERT(BIGINT,LEFT(@CutOverTime,2)),@StartSettDate))
	SET @EndSettDate=DATEADD(MINUTE,CONVERT(BIGINT,RIGHT(@CutOverTime,2)),DATEADD(HOUR,CONVERT(BIGINT,LEFT(@CutOverTime,2)),@EndSettDate))
    SET @StartUTCTime=Convert(datetime, SWITCHOFFSET(CONVERT(VARCHAR, @StartSettDate, 20) + ' ' + @StartTimeZone,'+00:00'))
    SET @EndUTCTime=Convert(datetime, SWITCHOFFSET(CONVERT(VARCHAR, @EndSettDate, 20) + ' ' + @EndTimeZone,'+00:00'))

    IF @GroupBySettDate=1
      SELECT 
          t.DeviceId AS TerminalId,
          d.TerminalName,
          CONVERT(VARCHAR(10),t.SystemSettlementDate, 111) SystemSettlementDate,  -- format to YYYY/MM/DD
          CONVERT(MONEY, SUM(t.AmountSurcharge))/100 AS SurchargeAmount,
          CONVERT(MONEY, SUM(t.AmountSettlement-t.AmountSurcharge))/100 DispensedAmount,
          COUNT(*) AS TnxTotalAttempted,
          COUNT(CASE WHEN t.AmountSurcharge <> 0 THEN 1 ELSE NULL END) TnxTotalSurcharged,
          COUNT(CASE WHEN t.ResponseCodeInternal <> 0 THEN 1 ELSE NULL END) AS TnxTotalDeclined,
          COUNT(CASE WHEN t.TransactionType =1 THEN 1 ELSE NULL END) AS TnxTotalWithdraw,
          COUNT(CASE WHEN t.TransactionType =2 THEN 1 ELSE NULL END) AS TnxTotalInquiry,
          COUNT(CASE WHEN t.TransactionType =3 THEN 1 ELSE NULL END) AS TnxTotalTransfer
      FROM dbo.tbl_trn_Transaction t
      JOIN dbo.tbl_Device d ON d.IsoId = @IsoId AND t.DeviceId = d.Id
      WHERE t.SystemTime BETWEEN @StartUTCTime AND @EndUTCTime
        AND t.TransactionType IN (SELECT Value FROM @TransactionTypeValue)
      GROUP BY t.deviceId, d.TerminalName, t.SystemSettlementDate
      ORDER BY d.TerminalName, t.SystemSettlementDate
    ELSE
    BEGIN
      DECLARE @SettleDateRange VARCHAR(23) -- "YYYY/MM/DD - YYYY/MM/D"
      SET @SettleDateRange = CONVERT(VARCHAR(10), @StartSettDate, 111) + ' - ' + CONVERT(VARCHAR(10), @EndSettDate, 111)
      SELECT 
          t.DeviceId AS TerminalId,
          d.TerminalName,
          @SettleDateRange SystemSettlementDate,
          
          CONVERT(MONEY, SUM(t.AmountSurcharge))/100 AS SurchargeAmount,
          CONVERT(MONEY, SUM(t.AmountSettlement-t.AmountSurcharge))/100 DispensedAmount,
          COUNT(*) AS TnxTotalAttempted,
          COUNT(CASE WHEN t.AmountSurcharge <> 0 THEN 1 ELSE NULL END) TnxTotalSurcharged,
          COUNT(CASE WHEN t.ResponseCodeInternal <> 0 THEN 1 ELSE NULL END) AS TnxTotalDeclined,
          COUNT(CASE WHEN t.TransactionType =1 THEN 1 ELSE NULL END) AS TnxTotalWithdraw,
          COUNT(CASE WHEN t.TransactionType =2 THEN 1 ELSE NULL END) AS TnxTotalInquiry,
          COUNT(CASE WHEN t.TransactionType =3 THEN 1 ELSE NULL END) AS TnxTotalTransfer
      FROM dbo.tbl_trn_Transaction t
      JOIN dbo.tbl_Device d ON d.IsoId = @IsoId AND t.DeviceId = d.Id
      WHERE t.SystemTime BETWEEN @StartUTCTime AND @EndUTCTime
        AND t.TransactionType IN (SELECT Value FROM @TransactionTypeValue)
      GROUP BY t.DeviceId, d.TerminalName
      ORDER BY d.TerminalName
    END
END
GO
GRANT EXECUTE ON  [dbo].[usp_rep_GetTransactionTerminalSummaryForISO] TO [WebV4Role]
GO
