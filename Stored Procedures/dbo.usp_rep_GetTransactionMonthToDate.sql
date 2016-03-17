SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_rep_GetTransactionMonthToDate]
    @UserId bigint,
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
    TerminalName,CONVERT(nvarchar,SystemSettlementDate,112),DeviceSequenceRange,
    DispensedAmount,SurchargeAmount,SettlementAmount,InterchangeAmount,TotalAmount,TotalCount,
    ApprovedCount,ApprovedDispensedCount,ApprovedSurchargedCount,ApprovedInquryCount,ApprovedTransferCount,
    DeclinedCount,DeclinedDispensedCount,DeclinedInquryCount,DeclinedTransferCount,
    Interac,BMO,Circuit,CirrusDom,CirrusIntl,PlUSDom,PLUSIntl,VISADom,VISAIntl,STAR,ChinaUnionPay,Other,
    DeclinedPercent,TerminalApprovedDispensedPercent
  FROM dbo.tbl_trn_TransactionDailySummary
  WHERE SystemSettlementDate>=@StartDate AND SystemSettlementDate<=@EndDate'
  IF @UserId IS NOT NULL
    SET @SQL=@SQL+' AND DeviceId IN (SELECT Id FROM @Source)'
  IF @DeviceId IS NOT NULL
    SET @SQL=@SQL+' AND DeviceId=@DeviceId'
  SET @SQL=@SQL+' ORDER BY TerminalName, SystemSettlementDate'

  EXEC sp_executesql @SQL, N'@UserID bigint, @DeviceId bigint, @StartDate datetime, @EndDate datetime', @UserID, @DeviceId, @StartDate, @EndDate
END
GO
