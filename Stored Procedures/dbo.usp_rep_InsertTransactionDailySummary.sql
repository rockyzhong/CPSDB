SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[usp_rep_InsertTransactionDailySummary]
@StartDate       datetime = NULL,
@EndDate         datetime = NULL
AS
BEGIN
  SET NOCOUNT ON
  
  IF @StartDate IS NULL 
    SELECT @StartDate=ISNULL(DATEADD(dd,1,MAX(SystemSettlementDate)),'2013-01-01') FROM dbo.tbl_trn_TransactionDailySummary
  IF @EndDate IS NULL 
    SET @EndDate=DATEADD(dd,-1,DATEDIFF(dd,0,GETUTCDATE()))
  
  DELETE FROM dbo.tbl_trn_TransactionDailySummary WHERE SystemSettlementDate>=@StartDate AND SystemSettlementDate<=@EndDate
  
  DECLARE @ApprovedDispensedCount TABLE(SystemSettlementDate datetime, ApprovedDispensedCount bigint)
  INSERT INTO @ApprovedDispensedCount(SystemSettlementDate,ApprovedDispensedCount) 
  SELECT t.SystemSettlementDate,COUNT(*) 
  FROM dbo.tbl_trn_Transaction t 
  WHERE t.SystemSettlementDate>=@StartDate AND t.SystemSettlementDate<=@EndDate 
    AND t.ResponseCodeInternal=0 AND t.AmountSettlement-t.AmountSurcharge<>0 
  GROUP BY t.SystemSettlementDate

  INSERT INTO dbo.tbl_trn_TransactionDailySummary
   (SystemSettlementDate,DeviceId,TerminalName,DeviceSequenceRange,
    DispensedAmount,SurchargeAmount,SettlementAmount,InterchangeAmount,TotalAmount,TotalCount,
    ApprovedCount,ApprovedDispensedCount,ApprovedSurchargedCount,ApprovedInquryCount,ApprovedTransferCount,
    DeclinedCount,DeclinedDispensedCount,DeclinedInquryCount,DeclinedTransferCount,
    Interac,BMO,Circuit,CirrusDom,CirrusIntl,PlUSDom,PLUSIntl,VISADom,VISAIntl,STAR,ChinaUnionPay,Other,
    DeclinedPercent,TerminalApprovedDispensedPercent)
  SELECT 
    t.SystemSettlementDate,
    t.DeviceId,
    d.TerminalName, 
    RIGHT('00000'+ CONVERT(nvarchar,MIN(t.DeviceSequence)),6)+N' - '+RIGHT('00000'+ CONVERT(nvarchar,MAX(t.DeviceSequence)),6) DeviceSequenceRange,

    CONVERT(money, SUM(CASE WHEN t.ResponseCodeInternal=0 THEN t.AmountSettlement-t.AmountSurcharge ELSE 0 END))/100 DispensedAmount,
    CONVERT(money, SUM(CASE WHEN t.ResponseCodeInternal=0 THEN t.AmountSurcharge                    ELSE 0 END))/100 SurchargeAmount,
    CONVERT(money, SUM(CASE WHEN t.ResponseCodeInternal=0 THEN t.AmountSettlement                   ELSE 0 END))/100 SettlementAmount,
    CONVERT(money, SUM(tf.AmountInterchangePaid))/100                                                                 InterchangeAmount,
    CONVERT(money, SUM(CASE WHEN t.ResponseCodeInternal=0 THEN t.AmountSettlement+tf.AmountInterchangePaid ELSE tf.AmountInterchangePaid END))/100 TotalAmount,
        
    COUNT(*)                                                                                                                                                         TotalCount,        
    COUNT(CASE WHEN t.ResponseCodeInternal=0                                                                                                   THEN 1 ELSE NULL END) ApprovedCount,
    COUNT(CASE WHEN t.ResponseCodeInternal=0 AND t.AmountSettlement-t.AmountSurcharge<>0                                                       THEN 1 ELSE NULL END) ApprovedDispensedCount,
    COUNT(CASE WHEN t.ResponseCodeInternal=0 AND t.AmountSurcharge<>0                                                                          THEN 1 ELSE NULL END) ApprovedSurchargedCount,
    COUNT(CASE WHEN t.ResponseCodeInternal=0 AND t.TransactionType IN (2)                                                                      THEN 1 ELSE NULL END) ApprovedInquryCount,
    COUNT(CASE WHEN t.ResponseCodeInternal=0 AND t.TransactionType IN (3,103)                                                                  THEN 1 ELSE NULL END) ApprovedTransferCount,
        
    COUNT(CASE WHEN t.ResponseCodeInternal<>0                                                                                                  THEN 1 ELSE NULL END) DeclinedCount,
    COUNT(CASE WHEN t.ResponseCodeInternal<>0 AND t.TransactionType NOT IN (2,3,103)                                                           THEN 1 ELSE NULL END) DeclinedDispensedCount,        
    COUNT(CASE WHEN t.ResponseCodeInternal<>0 AND t.TransactionType IN (2)                                                                     THEN 1 ELSE NULL END) DeclinedInquryCount,
    COUNT(CASE WHEN t.ResponseCodeInternal<>0 AND t.TransactionType IN (3,103)                                                                 THEN 1 ELSE NULL END) DeclinedTransferCount,

    COUNT(CASE WHEN t.ResponseCodeInternal=0 AND t.AmountSettlement-t.AmountSurcharge<>0 AND t.IssuerNetworkId IN ('INT', 'RBC', 'KEB')        THEN 1 ELSE NULL END) Interac,
    COUNT(CASE WHEN t.ResponseCodeInternal=0 AND t.AmountSettlement-t.AmountSurcharge<>0 AND t.IssuerNetworkId IN ('BMO')                      THEN 1 ELSE NULL END) BMO,
    COUNT(CASE WHEN t.ResponseCodeInternal=0 AND t.AmountSettlement-t.AmountSurcharge<>0 AND t.IssuerNetworkId IN ('MON', 'AMX', 'DUC')        THEN 1 ELSE NULL END) Circuit,
    COUNT(CASE WHEN t.ResponseCodeInternal=0 AND t.AmountSettlement-t.AmountSurcharge<>0 AND t.IssuerNetworkId IN ('CI0', 'MC0', 'MS0', 'SM0') THEN 1 ELSE NULL END) CirrusDom,
    COUNT(CASE WHEN t.ResponseCodeInternal=0 AND t.AmountSettlement-t.AmountSurcharge<>0 AND t.IssuerNetworkId IN ('CI1', 'MC1', 'MS1', 'SM1') THEN 1 ELSE NULL END) CirrusIntl,
    COUNT(CASE WHEN t.ResponseCodeInternal=0 AND t.AmountSettlement-t.AmountSurcharge<>0 AND t.IssuerNetworkId IN ('PL0', 'SM0')               THEN 1 ELSE NULL END) PlUSDom,
    COUNT(CASE WHEN t.ResponseCodeInternal=0 AND t.AmountSettlement-t.AmountSurcharge<>0 AND t.IssuerNetworkId IN ('PL1', 'SM1')               THEN 1 ELSE NULL END) PLUSIntl,
    COUNT(CASE WHEN t.ResponseCodeInternal=0 AND t.AmountSettlement-t.AmountSurcharge<>0 AND t.IssuerNetworkId IN ('VI0')                      THEN 1 ELSE NULL END) VISADom,
    COUNT(CASE WHEN t.ResponseCodeInternal=0 AND t.AmountSettlement-t.AmountSurcharge<>0 AND t.IssuerNetworkId IN ('VI1')                      THEN 1 ELSE NULL END) VISAIntl,
    COUNT(CASE WHEN t.ResponseCodeInternal=0 AND t.AmountSettlement-t.AmountSurcharge<>0 AND t.IssuerNetworkId IN ('STR')                      THEN 1 ELSE NULL END) STAR,
    COUNT(CASE WHEN t.ResponseCodeInternal=0 AND t.AmountSettlement-t.AmountSurcharge<>0 AND t.IssuerNetworkId IN ('CUP', 'CUR')               THEN 1 ELSE NULL END) ChinaUnionPay,
    COUNT(CASE WHEN t.ResponseCodeInternal=0 AND t.AmountSettlement-t.AmountSurcharge<>0 AND t.IssuerNetworkId NOT IN ('INT', 'RBC', 'KEB', 'BMO', 'MON', 'AMX', 'DUC', 'CI0', 'MC0', 'MS0', 'SM0', 'CI1', 'MC1', 'MS1', 'SM1', 'PL0', 'SM0', 'PL1', 'SM1',  
'VI0', 'VI1', 'STR', 'CUP', 'CUR') THEN 1 ELSE NULL END) Other,
        
    CONVERT(nvarchar,CONVERT(money,COUNT(CASE WHEN t.ResponseCodeInternal<>0 THEN 1 ELSE NULL END)*100)/COUNT(*))+N'%'                                                            DeclinedPercent,
    CONVERT(nvarchar,CONVERT(money,COUNT(CASE WHEN t.ResponseCodeInternal=0 AND t.AmountSettlement-t.AmountSurcharge<>0 THEN 1 ELSE NULL END)*100)/w.ApprovedDispensedCount)+N'%' TerminalApprovedDispensedPercent
  FROM dbo.tbl_trn_Transaction t
  LEFT JOIN dbo.tbl_trn_TransactionAmountInter tf ON t.Id=tf.TranId
  JOIN dbo.tbl_Device d ON t.DeviceId=d.Id
  JOIN @ApprovedDispensedCount w ON w.SystemSettlementDate=t.SystemSettlementDate
  WHERE t.SystemSettlementDate>=@StartDate AND t.SystemSettlementDate<=@EndDate
  GROUP BY t.SystemSettlementDate, t.DeviceId, d.TerminalName, w.ApprovedDispensedCount
  ORDER BY t.SystemSettlementDate, t.DeviceId, d.TerminalName, w.ApprovedDispensedCount
END
GO
