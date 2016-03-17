SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_set_SettlementAchTransaction] 
@SettlementDate datetime
AS
BEGIN
  SET NOCOUNT ON

  /***********************************************************************************************/
  /***********************************************************************************************/
  /***********************************************************************************************/

  /***** Create credit ach records from Ach schedule *****/
  INSERT INTO dbo.tbl_AchTransaction(
    SettlementDate,SettlementType,SettlementTime,
    SourceType,SourceId,BankAccountId,FundsType,AchFileId,BatchHeader,StandardEntryClassCode,ScheduleType,ScheduleDay,Description,BaseAmount)
  SELECT 
    @SettlementDate,3 SettlementType,@SettlementDate SettlementTime,
    SourceType,SourceId,SourceBankAccountId,FundsType,AchFileId,BatchHeader,StandardEntryClassCode,ScheduleType,ScheduleDay,Description,
    CASE WHEN ScheduleType=1 THEN DATEDIFF(dd,dbo.udf_GetMaxDate(StartDate,DATEADD(dd,1,SettlementDate),OpenDate),dbo.udf_GetScheduleDate(@SettlementDate,0,ScheduleType,ScheduleDay))+1
         WHEN ScheduleType=2 THEN DATEDIFF(ww,dbo.udf_GetMaxDate(StartDate,DATEADD(dd,1,SettlementDate),OpenDate),dbo.udf_GetScheduleDate(@SettlementDate,0,ScheduleType,ScheduleDay))
         WHEN ScheduleType=3 THEN DATEDIFF(mm,dbo.udf_GetMaxDate(StartDate,DATEADD(dd,1,SettlementDate),OpenDate),dbo.udf_GetScheduleDate(@SettlementDate,0,ScheduleType,ScheduleDay))
         ELSE 0
    END*(-Amount)*100
  FROM dbo.tbl_AchSchedule
  WHERE dbo.udf_GetMaxDate(StartDate,DATEADD(dd,1,SettlementDate),OpenDate)<=@SettlementDate 
    AND dbo.udf_GetScheduleDate(@SettlementDate,0,ScheduleType,ScheduleDay)>=@SettlementDate
    AND EndDate>=@SettlementDate
    AND AchScheduleStatus=1

  INSERT INTO dbo.tbl_AchTransaction(
    SettlementDate,SettlementType,SettlementTime,
    SourceType,SourceId,BankAccountId,FundsType,AchFileId,BatchHeader,StandardEntryClassCode,ScheduleType,ScheduleDay,Tax,Description,BaseAmount)
  SELECT 
    @SettlementDate,4 SettlementType,@SettlementDate SettlementTime,
    SourceType,SourceId,SourceBankAccountId,FundsType,AchFileId,BatchHeader,StandardEntryClassCode,ScheduleType,ScheduleDay,dbo.udf_GetTaxName(SourceId,SourceType),Description,
    CASE WHEN ScheduleType=1 THEN DATEDIFF(dd,dbo.udf_GetMaxDate(StartDate,DATEADD(dd,1,SettlementDate),OpenDate),dbo.udf_GetScheduleDate(@SettlementDate,0,ScheduleType,ScheduleDay))+1
         WHEN ScheduleType=2 THEN DATEDIFF(ww,dbo.udf_GetMaxDate(StartDate,DATEADD(dd,1,SettlementDate),OpenDate),dbo.udf_GetScheduleDate(@SettlementDate,0,ScheduleType,ScheduleDay))
         WHEN ScheduleType=3 THEN DATEDIFF(mm,dbo.udf_GetMaxDate(StartDate,DATEADD(dd,1,SettlementDate),OpenDate),dbo.udf_GetScheduleDate(@SettlementDate,0,ScheduleType,ScheduleDay))
         ELSE 0
    END*(-Amount)*100*dbo.udf_GetTaxPercent(SourceId,SourceType)
  FROM dbo.tbl_AchSchedule
  WHERE dbo.udf_GetMaxDate(StartDate,DATEADD(dd,1,SettlementDate),OpenDate)<=@SettlementDate 
    AND dbo.udf_GetScheduleDate(@SettlementDate,0,ScheduleType,ScheduleDay)>=@SettlementDate
    AND EndDate>=@SettlementDate
    AND AchScheduleStatus=1
    AND dbo.udf_GetTaxPercent(SourceId,SourceType)>0

  /***** Create debit ach records from Ach schedule *****/
  INSERT INTO dbo.tbl_AchTransaction(
    SettlementDate,SettlementType,SettlementTime,
    SourceType,SourceId,BankAccountId,FundsType,AchFileId,BatchHeader,StandardEntryClassCode,ScheduleType,ScheduleDay,Description,BaseAmount)
  SELECT 
    @SettlementDate,3 SettlementType,@SettlementDate SettlementTime,
    SourceType,SourceId,DestinationBankAccountId,FundsType,AchFileId,BatchHeader,StandardEntryClassCode,ScheduleType,ScheduleDay,Description,
    CASE WHEN ScheduleType=1 THEN DATEDIFF(dd,dbo.udf_GetMaxDate(StartDate,DATEADD(dd,1,SettlementDate),OpenDate),dbo.udf_GetScheduleDate(@SettlementDate,0,ScheduleType,ScheduleDay))+1
         WHEN ScheduleType=2 THEN DATEDIFF(ww,dbo.udf_GetMaxDate(StartDate,DATEADD(dd,1,SettlementDate),OpenDate),dbo.udf_GetScheduleDate(@SettlementDate,0,ScheduleType,ScheduleDay))
         WHEN ScheduleType=3 THEN DATEDIFF(mm,dbo.udf_GetMaxDate(StartDate,DATEADD(dd,1,SettlementDate),OpenDate),dbo.udf_GetScheduleDate(@SettlementDate,0,ScheduleType,ScheduleDay))
         ELSE 0
    END*Amount*100
  FROM dbo.tbl_AchSchedule
  WHERE dbo.udf_GetMaxDate(StartDate,DATEADD(dd,1,SettlementDate),OpenDate)<=@SettlementDate 
    AND dbo.udf_GetScheduleDate(@SettlementDate,0,ScheduleType,ScheduleDay)>=@SettlementDate
    AND EndDate>=@SettlementDate
    AND AchScheduleStatus=1

  INSERT INTO dbo.tbl_AchTransaction(
    SettlementDate,SettlementType,SettlementTime,
    SourceType,SourceId,BankAccountId,FundsType,AchFileId,BatchHeader,StandardEntryClassCode,ScheduleType,ScheduleDay,Tax,Description,BaseAmount)
  SELECT 
    @SettlementDate,4 SettlementType,@SettlementDate SettlementTime,
    SourceType,SourceId,DestinationBankAccountId,FundsType,AchFileId,BatchHeader,StandardEntryClassCode,ScheduleType,ScheduleDay,dbo.udf_GetTaxName(SourceId,SourceType),Description,
    CASE WHEN ScheduleType=1 THEN DATEDIFF(dd,dbo.udf_GetMaxDate(StartDate,DATEADD(dd,1,SettlementDate),OpenDate),dbo.udf_GetScheduleDate(@SettlementDate,0,ScheduleType,ScheduleDay))+1
         WHEN ScheduleType=2 THEN DATEDIFF(ww,dbo.udf_GetMaxDate(StartDate,DATEADD(dd,1,SettlementDate),OpenDate),dbo.udf_GetScheduleDate(@SettlementDate,0,ScheduleType,ScheduleDay))
         WHEN ScheduleType=3 THEN DATEDIFF(mm,dbo.udf_GetMaxDate(StartDate,DATEADD(dd,1,SettlementDate),OpenDate),dbo.udf_GetScheduleDate(@SettlementDate,0,ScheduleType,ScheduleDay))
         ELSE 0
    END*Amount*100*dbo.udf_GetTaxPercent(SourceId,SourceType)
  FROM dbo.tbl_AchSchedule
  WHERE dbo.udf_GetMaxDate(StartDate,DATEADD(dd,1,SettlementDate),OpenDate)<=@SettlementDate 
    AND dbo.udf_GetScheduleDate(@SettlementDate,0,ScheduleType,ScheduleDay)>=@SettlementDate
    AND EndDate>=@SettlementDate
    AND AchScheduleStatus=1
    AND dbo.udf_GetTaxPercent(SourceId,SourceType)>0

  /***** Update settlement date *****/
  UPDATE dbo.tbl_AchSchedule SET SettlementDate=@SettlementDate 
  WHERE dbo.udf_GetMaxDate(StartDate,DATEADD(dd,1,SettlementDate),OpenDate)<=@SettlementDate 
    AND dbo.udf_GetScheduleDate(@SettlementDate,0,ScheduleType,ScheduleDay)>=@SettlementDate
    AND EndDate>=@SettlementDate
    AND AchScheduleStatus=1
  
  /***********************************************************************************************/
  /***********************************************************************************************/
  /***********************************************************************************************/

  DECLARE @NRTCommissionBankAccountId bigint,@SettlementDeviceOffDays bigint
  SELECT @NRTCommissionBankAccountId=CONVERT(bigint,Value) FROM dbo.tbl_Parameter WHERE Name='NRTCommissionBankAccountId'
  SELECT @SettlementDeviceOffDays   =CONVERT(bigint,Value) FROM dbo.tbl_Parameter WHERE Name='SettlementDeviceOffDays'
  IF @SettlementDeviceOffDays IS NULL OR @SettlementDeviceOffDays<5    SET @SettlementDeviceOffDays=5

  /***** Create ach settlement records from transaction records for schedule payment or day close terminal *****/
  INSERT INTO dbo.tbl_AchTransaction(
    SettlementDate,SettlementType,SettlementTime,
    SourceId,BankAccountId,FundsType,AchFileId,BatchHeader,StandardEntryClassCode,DepositExec,CutoverOffset,ScheduleType,ScheduleDay,ThresholdAmount,
    ApprovedCount,DeclinedCount,ApprovedDispensedCount,ApprovedSurchargedCount,BaseAmount)
  SELECT 
    @SettlementDate,1 SettlementType,
    dbo.udf_GetSettlementTime(c.DepositExec,t.DeviceId,@SettlementDeviceOffDays,@SettlementDate,f.Cutover*60+ISNULL(c.CutoverOffset,0),ISNULL(s2.ScheduleType,s1.ScheduleType),ISNULL(s2.ScheduleDay,s1.ScheduleDay)) SettlementTime,
    t.DeviceId,ISNULL(b2.BankAccountId,b1.BankAccountId) BankAccountId,1 FundsType,s1.AchFileId,f.SettlementLabel,f.StandardEntryClassCode,c.DepositExec,c.CutoverOffset,
    ISNULL(s2.ScheduleType,s1.ScheduleType) ScheduleType,ISNULL(s2.ScheduleDay,s1.ScheduleDay) ScheduleDay,ISNULL(s2.ThresholdAmount,s1.ThresholdAmount) ThresholdAmount,
    SUM(CASE WHEN t.ResponseCodeInternal=0  THEN 1 ELSE 0 END) ApprovedCount,
    SUM(CASE WHEN t.ResponseCodeInternal<>0 THEN 1 ELSE 0 END) DeclinedCount,
    SUM(CASE WHEN t.ResponseCodeInternal=0 AND (t.TransactionState=1 OR (t.TransactionState=2 AND d.QuestionablePolicy=1)) THEN CASE WHEN t.AmountSettlement-t.AmountSurcharge>0 THEN 1 WHEN t.AmountSettlement-t.AmountSurcharge<0 THEN -1 ELSE 0 END ELSE 0 END) ApprovedDispensedCount,
    SUM(CASE WHEN t.ResponseCodeInternal=0 AND (t.TransactionState=1 OR (t.TransactionState=2 AND d.QuestionablePolicy=1)) THEN CASE WHEN t.AmountSurcharge>0                    THEN 1 WHEN t.AmountSurcharge<0                    THEN -1 ELSE 0 END ELSE 0 END) ApprovedSurchargedCount,
    SUM(CASE WHEN t.ResponseCodeInternal=0 AND (t.TransactionState=1 OR (t.TransactionState=2 AND d.QuestionablePolicy=1)) THEN t.AmountSettlement-t.AmountSurcharge ELSE 0 END) BaseAmount
  FROM dbo.tbl_trn_Transaction t
  JOIN dbo.tbl_Device                                 d  ON d.Id=t.DeviceId
  JOIN dbo.tbl_DeviceToSettlementAccount              b1 ON b1.DeviceId=t.DeviceId AND b1.StartDate<=t.Systemdate AND b1.EndDate>t.Systemdate
  LEFT JOIN dbo.tbl_DeviceToSettlementAccountOverride b2 ON b2.DeviceId=t.DeviceId AND b2.StartDate<=t.Systemdate AND b2.EndDate>t.Systemdate AND b2.OverrideType=1 AND b2.OverrideData=t.TransactionType 
  JOIN dbo.tbl_BankAccountSchedule                    s1 ON s1.BankAccountId=ISNULL(b2.BankAccountId,b1.BankAccountId) AND s1.FundsType=1
  LEFT JOIN dbo.tbl_BankAccountScheduleOverride       s2 ON s2.BankAccountId=ISNULL(b2.BankAccountId,b1.BankAccountId) AND s2.FundsType=1 AND s2.DeviceId=t.DeviceId
  JOIN dbo.tbl_AchFile                                f  ON f.Id=s1.AchFileId
  LEFT JOIN dbo.tbl_DeviceCutoverOffset               c  ON c.DeviceId=t.DeviceId AND c.FundsType=1
  WHERE t.SystemDate>=dbo.udf_GetLastSettlementTime(t.DeviceId,ISNULL(b2.BankAccountId,b1.BankAccountId),1,1)
    AND t.SystemDate <dbo.udf_GetSettlementTime(c.DepositExec,t.DeviceId,@SettlementDeviceOffDays,@SettlementDate,f.Cutover*60+ISNULL(c.CutoverOffset,0),ISNULL(s2.ScheduleType,s1.ScheduleType),ISNULL(s2.ScheduleDay,s1.ScheduleDay))
    AND t.TransactionType IN (1,2,3,4,5,6,7,8,9,10,11,12,101,103,104,107,108,109,110,111,112)    
    AND (ISNULL(s2.ScheduleType,s1.ScheduleType) IN (1,2,3) OR c.DepositExec=1)
  GROUP BY 
    t.DeviceId,ISNULL(b2.BankAccountId,b1.BankAccountId),s1.AchFileId,f.SettlementLabel,f.StandardEntryClassCode,f.Cutover,ISNULL(s2.ScheduleType,s1.ScheduleType),ISNULL(s2.ScheduleDay,s1.ScheduleDay),ISNULL(s2.ThresholdAmount,s1.ThresholdAmount),c.DepositExec,c.CutoverOffset
    
  /***** Create ach surcharge records from transaction records for schedule payment or day close terminal *****/
  INSERT INTO dbo.tbl_AchTransaction(
    SettlementDate,SettlementType,SettlementTime,
    SourceId,BankAccountId,FundsType,AchFileId,BatchHeader,StandardEntryClassCode,DepositExec,CutoverOffset,ScheduleType,ScheduleDay,ThresholdAmount,SplitType,SplitData,
    ApprovedCount,DeclinedCount,ApprovedDispensedCount,ApprovedSurchargedCount,BaseAmount)
  SELECT 
    @SettlementDate,1 SettlementType,
    dbo.udf_GetSettlementTime(c.DepositExec,t.DeviceId,@SettlementDeviceOffDays,@SettlementDate,f.Cutover*60+ISNULL(c.CutoverOffset,0),ISNULL(s2.ScheduleType,s1.ScheduleType),ISNULL(s2.ScheduleDay,s1.ScheduleDay)) SettlementTime,
    t.DeviceId,ISNULL(ISNULL(b3.BankAccountId,b2.BankAccountId),b1.BankAccountId) BankAccountId,2 FundsType,s1.AchFileId,f.SurchargeLabel,f.StandardEntryClassCode,c.DepositExec,c.CutoverOffset,
    ISNULL(s2.ScheduleType,s1.ScheduleType) ScheduleType,ISNULL(s2.ScheduleDay,s1.ScheduleDay) ScheduleDay,ISNULL(s2.ThresholdAmount,s1.ThresholdAmount) ThresholdAmount,
    ISNULL(ISNULL(b3.SplitType,b2.SplitType),b1.SplitType) SplitType,ISNULL(ISNULL(b3.SplitData,b2.SplitData),b1.SplitData) SplitData,
    SUM(CASE WHEN t.ResponseCodeInternal=0  THEN 1 ELSE 0 END) ApprovedCount,
    SUM(CASE WHEN t.ResponseCodeInternal<>0 THEN 1 ELSE 0 END) DeclinedCount,
    SUM(CASE WHEN t.ResponseCodeInternal=0 AND (t.TransactionState=1 OR (t.TransactionState=2 AND d.QuestionablePolicy=1)) THEN CASE WHEN t.AmountSettlement-t.AmountSurcharge>0 THEN 1 WHEN t.AmountSettlement-t.AmountSurcharge<0 THEN -1 ELSE 0 END ELSE 0 END) ApprovedDispensedCount,
    SUM(CASE WHEN t.ResponseCodeInternal=0 AND (t.TransactionState=1 OR (t.TransactionState=2 AND d.QuestionablePolicy=1)) THEN CASE WHEN t.AmountSurcharge>0                    THEN 1 WHEN t.AmountSurcharge<0                    THEN -1 ELSE 0 END ELSE 0 END) ApprovedSurchargedCount,
    SUM(CASE WHEN t.ResponseCodeInternal=0 AND (t.TransactionState=1 OR (t.TransactionState=2 AND d.QuestionablePolicy=1)) THEN t.AmountSurcharge ELSE 0 END) BaseAmount
  FROM dbo.tbl_trn_Transaction t
  JOIN dbo.tbl_Device                                     d  ON d.Id=t.DeviceId
  LEFT JOIN dbo.tbl_DeviceToSurchargeSplitAccountOverride b3 ON b3.DeviceId=t.DeviceId AND b3.StartDate<=t.Systemdate AND b3.EndDate>t.Systemdate AND b3.OverrideType=1 AND b3.OverrideData=t.TransactionType
  LEFT JOIN dbo.tbl_DeviceToSurchargeSplitAccountOverride b2 ON b2.DeviceId=t.DeviceId AND b2.StartDate<=t.Systemdate AND b2.EndDate>t.Systemdate AND b2.OverrideType=2 AND b2.OverrideData=t.IssuerNetworkId AND b3.Id IS NULL
  LEFT JOIN dbo.tbl_DeviceToSurchargeSplitAccount         b1 ON b1.DeviceId=t.DeviceId AND b1.StartDate<=t.Systemdate AND b1.EndDate>t.Systemdate AND b3.Id IS NULL AND b2.Id IS NULL
  JOIN dbo.tbl_BankAccountSchedule                        s1 ON s1.BankAccountId=ISNULL(ISNULL(b3.BankAccountId,b2.BankAccountId),b1.BankAccountId) AND s1.FundsType=2
  LEFT JOIN dbo.tbl_BankAccountScheduleOverride           s2 ON s2.BankAccountId=ISNULL(ISNULL(b3.BankAccountId,b2.BankAccountId),b1.BankAccountId) AND s2.FundsType=2 AND s2.DeviceId=t.DeviceId
  JOIN dbo.tbl_AchFile                                    f  ON f.Id=s1.AchFileId
  LEFT JOIN dbo.tbl_DeviceCutoverOffset                   c  ON c.DeviceId=t.DeviceId AND c.FundsType=2
  WHERE t.SystemDate>=dbo.udf_GetLastSettlementTime(t.DeviceId,ISNULL(ISNULL(b3.BankAccountId,b2.BankAccountId),b1.BankAccountId),2,1)
    AND t.SystemDate <dbo.udf_GetSettlementTime(c.DepositExec,t.DeviceId,@SettlementDeviceOffDays,@SettlementDate,f.Cutover*60+ISNULL(c.CutoverOffset,0),ISNULL(s2.ScheduleType,s1.ScheduleType),ISNULL(s2.ScheduleDay,s1.ScheduleDay))
    AND t.TransactionType IN (1,2,3,4,5,6,7,8,9,10,11,12,101,103,104,107,108,109,110,111,112)    
    AND (ISNULL(s2.ScheduleType,s1.ScheduleType) IN (1,2,3) OR c.DepositExec=1)
  GROUP BY 
    t.DeviceId,ISNULL(ISNULL(b3.BankAccountId,b2.BankAccountId),b1.BankAccountId),s1.AchFileId,f.SurchargeLabel,f.StandardEntryClassCode,f.Cutover,ISNULL(s2.ScheduleType,s1.ScheduleType),ISNULL(s2.ScheduleDay,s1.ScheduleDay),ISNULL(s2.ThresholdAmount,s1.ThresholdAmount),c.DepositExec,c.CutoverOffset,
    ISNULL(ISNULL(b3.SplitType,b2.SplitType),b1.SplitType),ISNULL(ISNULL(b3.SplitData,b2.SplitData),b1.SplitData)
    
  /***** Create ach interchange records from transaction records for schedule payment or day close terminal *****/
  INSERT INTO dbo.tbl_AchTransaction(
    SettlementDate,SettlementType,SettlementTime,
    SourceId,BankAccountId,FundsType,AchFileId,BatchHeader,StandardEntryClassCode,DepositExec,CutoverOffset,ScheduleType,ScheduleDay,ThresholdAmount,SplitType,SplitData,
    ApprovedCount,DeclinedCount,ApprovedDispensedCount,ApprovedSurchargedCount,BaseAmount)
  SELECT 
    @SettlementDate,1 SettlementType,
    dbo.udf_GetSettlementTime(c.DepositExec,t.DeviceId,@SettlementDeviceOffDays,@SettlementDate,f.Cutover*60+ISNULL(c.CutoverOffset,0),ISNULL(s2.ScheduleType,s1.ScheduleType),ISNULL(s2.ScheduleDay,s1.ScheduleDay)) SettlementTime,
    t.DeviceId,b.BankAccountId,3 FundsType,s1.AchFileId,f.InterchangeLabel,f.StandardEntryClassCode,c.DepositExec,c.CutoverOffset,
    ISNULL(s2.ScheduleType,s1.ScheduleType) ScheduleType,ISNULL(s2.ScheduleDay,s1.ScheduleDay) ScheduleDay,ISNULL(s2.ThresholdAmount,s1.ThresholdAmount) ThresholdAmount,
    b.SplitType,b.SplitData,
    SUM(CASE WHEN t.ResponseCodeInternal=0  THEN 1 ELSE 0 END) ApprovedCount,
    SUM(CASE WHEN t.ResponseCodeInternal<>0 THEN 1 ELSE 0 END) DeclinedCount,
    SUM(CASE WHEN t.ResponseCodeInternal=0 AND (t.TransactionState=1 OR (t.TransactionState=2 AND d.QuestionablePolicy=1)) THEN CASE WHEN t.AmountSettlement-t.AmountSurcharge>0 THEN 1 WHEN t.AmountSettlement-t.AmountSurcharge<0 THEN -1 ELSE 0 END ELSE 0 END) ApprovedDispensedCount,
    SUM(CASE WHEN t.ResponseCodeInternal=0 AND (t.TransactionState=1 OR (t.TransactionState=2 AND d.QuestionablePolicy=1)) THEN CASE WHEN t.AmountSurcharge>0                    THEN 1 WHEN t.AmountSurcharge<0                    THEN -1 ELSE 0 END ELSE 0 END) ApprovedSurchargedCount,
    SUM(CASE WHEN t.ResponseCodeInternal=0 THEN a.AmountApproval ELSE a.AmountDeclined END) BaseAmount
  FROM dbo.tbl_trn_Transaction t
  JOIN dbo.tbl_Device                           d  ON d.Id=t.DeviceId
  JOIN dbo.tbl_DeviceToInterchangeSplitAccount  b  ON b.DeviceId=t.DeviceId AND b.StartDate<=t.Systemdate AND b.EndDate>t.Systemdate
  JOIN dbo.tbl_DeviceToInterchangeScheme        i  ON i.DeviceId=t.DeviceId
  LEFT JOIN dbo.tbl_InterchangeSchemeSignature  g1 ON g1.InterchangeSchemeId=i.InterchangeSchemeId AND g1.IssuerNetworkId=t.IssuerNetworkId AND g1.TransactionType=t.TransactionType
  LEFT JOIN dbo.tbl_InterchangeSchemeSignature  g2 ON g2.InterchangeSchemeId=i.InterchangeSchemeId AND g2.IssuerNetworkId=t.IssuerNetworkId AND t.TransactionType IN (7,8,9,10,11,12,107,108,109,110,111,112) AND ((t.TransactionFlags & 0x00080000 > 0 AND g2.TransactionType=91) /*POS Credit*/ OR (t.TransactionFlags & 0x00080000 = 0 AND g2.TransactionType=92) /*POS Debit*/)
  LEFT JOIN dbo.tbl_InterchangeSchemeSignature  g3 ON g3.InterchangeSchemeId=i.InterchangeSchemeId AND g3.IssuerNetworkId=N'ALL'            AND g3.TransactionType=t.TransactionType
  LEFT JOIN dbo.tbl_InterchangeSchemeSignature  g4 ON g4.InterchangeSchemeId=i.InterchangeSchemeId AND g4.IssuerNetworkId=N'ALL'            AND t.TransactionType IN (7,8,9,10,11,12,107,108,109,110,111,112) AND ((t.TransactionFlags & 0x00080000 > 0 AND g4.TransactionType=91) /*POS Credit*/ OR (t.TransactionFlags & 0x00080000 = 0 AND g4.TransactionType=92) /*POS Debit*/)
  LEFT JOIN dbo.tbl_InterchangeSchemeSignature  g5 ON g5.InterchangeSchemeId=i.InterchangeSchemeId AND g5.IssuerNetworkId=t.IssuerNetworkId AND g5.TransactionType=0
  LEFT JOIN dbo.tbl_InterchangeSchemeSignature  g6 ON g6.InterchangeSchemeId=i.InterchangeSchemeId AND g6.IssuerNetworkId=N'ALL'            AND g6.TransactionType=0
  JOIN dbo.tbl_InterchangeSchemeSignatureAmount a  ON a.InterchangeSchemeSignatureId=ISNULL(ISNULL(ISNULL(ISNULL(ISNULL(g1.Id,g2.Id),g3.Id),g4.Id),g5.Id),g6.Id) AND a.Recipient=b.Recipient
  JOIN dbo.tbl_BankAccountSchedule              s1 ON s1.BankAccountId=b.BankAccountId AND s1.FundsType=3
  LEFT JOIN dbo.tbl_BankAccountScheduleOverride s2 ON s2.BankAccountId=b.BankAccountId AND s2.FundsType=3 AND s2.DeviceId=t.DeviceId
  JOIN dbo.tbl_AchFile                          f  ON f.Id=s1.AchFileId
  LEFT JOIN dbo.tbl_DeviceCutoverOffset         c  ON c.DeviceId=t.DeviceId AND c.FundsType=3
  WHERE t.SystemDate>=dbo.udf_GetLastSettlementTime(t.DeviceId,b.BankAccountId,3,1)
    AND t.SystemDate <dbo.udf_GetSettlementTime(c.DepositExec,t.DeviceId,@SettlementDeviceOffDays,@SettlementDate,f.Cutover*60+ISNULL(c.CutoverOffset,0),ISNULL(s2.ScheduleType,s1.ScheduleType),ISNULL(s2.ScheduleDay,s1.ScheduleDay))
    AND t.TransactionType IN (1,2,3,4,5,6,7,8,9,10,11,12,101,103,104,107,108,109,110,111,112)    
    AND (ISNULL(s2.ScheduleType,s1.ScheduleType) IN (1,2,3) OR c.DepositExec=1)
  GROUP BY 
    t.DeviceId,b.BankAccountId,s1.AchFileId,f.InterchangeLabel,f.StandardEntryClassCode,f.Cutover,ISNULL(s2.ScheduleType,s1.ScheduleType),ISNULL(s2.ScheduleDay,s1.ScheduleDay),ISNULL(s2.ThresholdAmount,s1.ThresholdAmount),c.DepositExec,c.CutoverOffset,
    b.SplitType,b.SplitData

  /***** Create ach credit commission records from transaction records  for schedule payment or day close terminal*****/
  INSERT INTO dbo.tbl_AchTransaction(
    SettlementDate,SettlementType,SettlementTime,
    SourceId,BankAccountId,FundsType,AchFileId,BatchHeader,StandardEntryClassCode,DepositExec,CutoverOffset,ScheduleType,ScheduleDay,ThresholdAmount,
    ApprovedCount,DeclinedCount,ApprovedDispensedCount,ApprovedSurchargedCount,BaseAmount)
  SELECT 
    @SettlementDate,2 SettlementType,
    dbo.udf_GetSettlementTime(c.DepositExec,t.DeviceId,@SettlementDeviceOffDays,@SettlementDate,f.Cutover*60+ISNULL(c.CutoverOffset,0),ISNULL(s2.ScheduleType,s1.ScheduleType),ISNULL(s2.ScheduleDay,s1.ScheduleDay)) SettlementTime,
    t.DeviceId,ISNULL(b2.BankAccountId,b1.BankAccountId) BankAccountId,1 FundsType,s1.AchFileId,f.SettlementLabel,f.StandardEntryClassCode,c.DepositExec,c.CutoverOffset,
    ISNULL(s2.ScheduleType,s1.ScheduleType) ScheduleType,ISNULL(s2.ScheduleDay,s1.ScheduleDay) ScheduleDay,ISNULL(s2.ThresholdAmount,s1.ThresholdAmount) ThresholdAmount,
    SUM(CASE WHEN t.ResponseCodeInternal=0  THEN 1 ELSE 0 END) ApprovedCount,
    SUM(CASE WHEN t.ResponseCodeInternal<>0 THEN 1 ELSE 0 END) DeclinedCount,
    SUM(CASE WHEN t.ResponseCodeInternal=0 AND (t.TransactionState=1 OR (t.TransactionState=2 AND d.QuestionablePolicy=1)) THEN CASE WHEN t.AmountSettlement-t.AmountSurcharge>0 THEN 1 WHEN t.AmountSettlement-t.AmountSurcharge<0 THEN -1 ELSE 0 END ELSE 0 END) ApprovedDispensedCount,
    SUM(CASE WHEN t.ResponseCodeInternal=0 AND (t.TransactionState=1 OR (t.TransactionState=2 AND d.QuestionablePolicy=1)) THEN CASE WHEN t.AmountSurcharge>0                    THEN 1 WHEN t.AmountSurcharge<0                    THEN -1 ELSE 0 END ELSE 0 END) ApprovedSurchargedCount,
    SUM(CASE WHEN t.ResponseCodeInternal=0 AND (t.TransactionState=1 OR (t.TransactionState=2 AND d.QuestionablePolicy=1)) THEN -t.AmountCommission ELSE 0 END) BaseAmount
  FROM dbo.tbl_trn_Transaction t
  JOIN dbo.tbl_Device                                 d  ON d.Id=t.DeviceId
  JOIN dbo.tbl_DeviceToSettlementAccount              b1 ON b1.DeviceId=t.DeviceId AND b1.StartDate<=t.Systemdate AND b1.EndDate>t.Systemdate
  LEFT JOIN dbo.tbl_DeviceToSettlementAccountOverride b2 ON b2.DeviceId=t.DeviceId AND b2.StartDate<=t.Systemdate AND b2.EndDate>t.Systemdate AND b2.OverrideType=1 AND b2.OverrideData=t.TransactionType 
  JOIN dbo.tbl_BankAccountSchedule                    s1 ON s1.BankAccountId=ISNULL(b2.BankAccountId,b1.BankAccountId) AND s1.FundsType=1
  LEFT JOIN dbo.tbl_BankAccountScheduleOverride       s2 ON s2.BankAccountId=ISNULL(b2.BankAccountId,b1.BankAccountId) AND s2.FundsType=1 AND s2.DeviceId=t.DeviceId
  JOIN dbo.tbl_AchFile                                f  ON f.Id=s1.AchFileId
  LEFT JOIN dbo.tbl_DeviceCutoverOffset               c  ON c.DeviceId=t.DeviceId AND c.FundsType=1
  WHERE t.SystemDate>=dbo.udf_GetLastSettlementTime(t.DeviceId,ISNULL(b2.BankAccountId,b1.BankAccountId),1,2)
    AND t.SystemDate <dbo.udf_GetSettlementTime(c.DepositExec,t.DeviceId,@SettlementDeviceOffDays,@SettlementDate,f.Cutover*60+ISNULL(c.CutoverOffset,0),ISNULL(s2.ScheduleType,s1.ScheduleType),ISNULL(s2.ScheduleDay,s1.ScheduleDay))
    AND t.TransactionType IN (1,2,3,4,5,6,7,8,9,10,11,12,101,103,104,107,108,109,110,111,112)    
    AND (ISNULL(s2.ScheduleType,s1.ScheduleType) IN (1,2,3) OR c.DepositExec=1)
  GROUP BY 
    t.DeviceId,ISNULL(b2.BankAccountId,b1.BankAccountId),s1.AchFileId,f.SettlementLabel,f.StandardEntryClassCode,f.Cutover,ISNULL(s2.ScheduleType,s1.ScheduleType),ISNULL(s2.ScheduleDay,s1.ScheduleDay),ISNULL(s2.ThresholdAmount,s1.ThresholdAmount),c.DepositExec,c.CutoverOffset
  HAVING 
    SUM(CASE WHEN t.ResponseCodeInternal=0 AND (t.TransactionState=1 OR (t.TransactionState=2 AND d.QuestionablePolicy=1)) THEN -t.AmountCommission ELSE 0 END)<>0
    
  /***** Update amount *****/
  UPDATE dbo.tbl_AchTransaction SET Amount=
    CASE WHEN SplitType=0 OR (SplitType=2 AND SplitData>0) THEN BaseAmount*CONVERT(money,SplitData)/1000000
         WHEN SplitType=1 AND FundsType=2                  THEN ApprovedSurchargedCount*SplitData
         WHEN SplitType=2 AND FundsType=2                  THEN BaseAmount+ApprovedSurchargedCount*SplitData
         WHEN SplitType=1 AND FundsType=3                  THEN (ApprovedCount+DeclinedCount)*SplitData
         WHEN SplitType=2 AND FundsType=3                  THEN BaseAmount+(ApprovedCount+DeclinedCount)*SplitData
         ELSE                                                   0
    END
  WHERE SettlementDate=@SettlementDate

  /***********************************************************************************************/
  /***********************************************************************************************/
  /***********************************************************************************************/
  
  DECLARE @AchTransaction TABLE(
    SettlementDate datetime,SettlementType bigint,SettlementTime datetime,
    SourceId bigint,BankAccountId bigint,FundsType bigint,AchFileId bigint,BatchHeader nvarchar(50),StandardEntryClassCode nvarchar(50),DepositExec bigint,CutoverOffset bigint,ScheduleType bigint,ScheduleDay bigint,ThresholdAmount money,SplitType bigint DEFAULT(0),SplitData bigint DEFAULT(1000000),
    ApprovedCount bigint,ApprovedDispensedCount bigint,ApprovedSurchargedCount bigint,DeclinedCount bigint,BaseAmount money,Amount money)

  /***** Create ach settlement records from transaction records for threshold amount payment *****/
  INSERT INTO @AchTransaction(
    SettlementDate,SettlementType,SettlementTime,
    SourceId,BankAccountId,FundsType,AchFileId,BatchHeader,StandardEntryClassCode,DepositExec,CutoverOffset,ScheduleType,ScheduleDay,ThresholdAmount,
    ApprovedCount,DeclinedCount,ApprovedDispensedCount,ApprovedSurchargedCount,BaseAmount)
  SELECT 
    @SettlementDate,1 SettlementType,
    dbo.udf_GetSettlementTime(c.DepositExec,t.DeviceId,@SettlementDeviceOffDays,@SettlementDate,f.Cutover*60+ISNULL(c.CutoverOffset,0),ISNULL(s2.ScheduleType,s1.ScheduleType),ISNULL(s2.ScheduleDay,s1.ScheduleDay)) SettlementTime,
    t.DeviceId,ISNULL(b2.BankAccountId,b1.BankAccountId) BankAccountId,1 FundsType,s1.AchFileId,f.SettlementLabel,f.StandardEntryClassCode,c.DepositExec,c.CutoverOffset,
    ISNULL(s2.ScheduleType,s1.ScheduleType) ScheduleType,ISNULL(s2.ScheduleDay,s1.ScheduleDay) ScheduleDay,ISNULL(s2.ThresholdAmount,s1.ThresholdAmount) ThresholdAmount,
    SUM(CASE WHEN t.ResponseCodeInternal=0  THEN 1 ELSE 0 END) ApprovedCount,
    SUM(CASE WHEN t.ResponseCodeInternal<>0 THEN 1 ELSE 0 END) DeclinedCount,
    SUM(CASE WHEN t.ResponseCodeInternal=0 AND (t.TransactionState=1 OR (t.TransactionState=2 AND d.QuestionablePolicy=1)) THEN CASE WHEN t.AmountSettlement-t.AmountSurcharge>0 THEN 1 WHEN t.AmountSettlement-t.AmountSurcharge<0 THEN -1 ELSE 0 END ELSE 0 END) ApprovedDispensedCount,
    SUM(CASE WHEN t.ResponseCodeInternal=0 AND (t.TransactionState=1 OR (t.TransactionState=2 AND d.QuestionablePolicy=1)) THEN CASE WHEN t.AmountSurcharge>0                    THEN 1 WHEN t.AmountSurcharge<0                    THEN -1 ELSE 0 END ELSE 0 END) ApprovedSurchargedCount,
    SUM(CASE WHEN t.ResponseCodeInternal=0 AND (t.TransactionState=1 OR (t.TransactionState=2 AND d.QuestionablePolicy=1)) THEN t.AmountSettlement-t.AmountSurcharge ELSE 0 END) BaseAmount
  FROM dbo.tbl_trn_Transaction t
  JOIN dbo.tbl_Device                                 d  ON d.Id=t.DeviceId
  JOIN dbo.tbl_DeviceToSettlementAccount              b1 ON b1.DeviceId=t.DeviceId AND b1.StartDate<=t.Systemdate AND b1.EndDate>t.Systemdate
  LEFT JOIN dbo.tbl_DeviceToSettlementAccountOverride b2 ON b2.DeviceId=t.DeviceId AND b2.StartDate<=t.Systemdate AND b2.EndDate>t.Systemdate AND b2.OverrideType=1 AND b2.OverrideData=t.TransactionType 
  JOIN dbo.tbl_BankAccountSchedule                    s1 ON s1.BankAccountId=ISNULL(b2.BankAccountId,b1.BankAccountId) AND s1.FundsType=1
  LEFT JOIN dbo.tbl_BankAccountScheduleOverride       s2 ON s2.BankAccountId=ISNULL(b2.BankAccountId,b1.BankAccountId) AND s2.FundsType=1 AND s2.DeviceId=t.DeviceId
  JOIN dbo.tbl_AchFile                                f  ON f.Id=s1.AchFileId
  LEFT JOIN dbo.tbl_DeviceCutoverOffset               c  ON c.DeviceId=t.DeviceId AND c.FundsType=1
  WHERE t.SystemDate>=dbo.udf_GetLastSettlementTime(t.DeviceId,ISNULL(b2.BankAccountId,b1.BankAccountId),1,1)
    AND t.SystemDate <dbo.udf_GetSettlementTime(c.DepositExec,t.DeviceId,@SettlementDeviceOffDays,@SettlementDate,f.Cutover*60+ISNULL(c.CutoverOffset,0),ISNULL(s2.ScheduleType,s1.ScheduleType),ISNULL(s2.ScheduleDay,s1.ScheduleDay))
    AND t.TransactionType IN (1,2,3,4,5,6,7,8,9,10,11,12,101,103,104,107,108,109,110,111,112)    
    AND (ISNULL(s2.ScheduleType,s1.ScheduleType) IN (5) AND c.DepositExec=0)
  GROUP BY 
    t.DeviceId,ISNULL(b2.BankAccountId,b1.BankAccountId),s1.AchFileId,f.SettlementLabel,f.StandardEntryClassCode,f.Cutover,ISNULL(s2.ScheduleType,s1.ScheduleType),ISNULL(s2.ScheduleDay,s1.ScheduleDay),ISNULL(s2.ThresholdAmount,s1.ThresholdAmount),c.DepositExec,c.CutoverOffset
  HAVING 
    SUM(CASE WHEN t.ResponseCodeInternal=0 AND (t.TransactionState=1 OR (t.TransactionState=2 AND d.QuestionablePolicy=1)) THEN t.AmountSettlement-t.AmountSurcharge ELSE 0 END)<>0
    
  /***** Create ach surcharge records from transaction records for threshold amount payment *****/
  INSERT INTO @AchTransaction(
    SettlementDate,SettlementType,SettlementTime,
    SourceId,BankAccountId,FundsType,AchFileId,BatchHeader,StandardEntryClassCode,DepositExec,CutoverOffset,ScheduleType,ScheduleDay,ThresholdAmount,SplitType,SplitData,
    ApprovedCount,DeclinedCount,ApprovedDispensedCount,ApprovedSurchargedCount,BaseAmount)
  SELECT 
    @SettlementDate,1 SettlementType,
    dbo.udf_GetSettlementTime(c.DepositExec,t.DeviceId,@SettlementDeviceOffDays,@SettlementDate,f.Cutover*60+ISNULL(c.CutoverOffset,0),ISNULL(s2.ScheduleType,s1.ScheduleType),ISNULL(s2.ScheduleDay,s1.ScheduleDay)) SettlementTime,
    t.DeviceId,ISNULL(ISNULL(b3.BankAccountId,b2.BankAccountId),b1.BankAccountId) BankAccountId,2 FundsType,s1.AchFileId,f.SurchargeLabel,f.StandardEntryClassCode,c.DepositExec,c.CutoverOffset,
    ISNULL(s2.ScheduleType,s1.ScheduleType) ScheduleType,ISNULL(s2.ScheduleDay,s1.ScheduleDay) ScheduleDay,ISNULL(s2.ThresholdAmount,s1.ThresholdAmount) ThresholdAmount,
    ISNULL(ISNULL(b3.SplitType,b2.SplitType),b1.SplitType) SplitType,ISNULL(ISNULL(b3.SplitData,b2.SplitData),b1.SplitData) SplitData,
    SUM(CASE WHEN t.ResponseCodeInternal=0  THEN 1 ELSE 0 END) ApprovedCount,
    SUM(CASE WHEN t.ResponseCodeInternal<>0 THEN 1 ELSE 0 END) DeclinedCount,
    SUM(CASE WHEN t.ResponseCodeInternal=0 AND (t.TransactionState=1 OR (t.TransactionState=2 AND d.QuestionablePolicy=1)) THEN CASE WHEN t.AmountSettlement-t.AmountSurcharge>0 THEN 1 WHEN t.AmountSettlement-t.AmountSurcharge<0 THEN -1 ELSE 0 END ELSE 0 END) ApprovedDispensedCount,
    SUM(CASE WHEN t.ResponseCodeInternal=0 AND (t.TransactionState=1 OR (t.TransactionState=2 AND d.QuestionablePolicy=1)) THEN CASE WHEN t.AmountSurcharge>0                    THEN 1 WHEN t.AmountSurcharge<0                    THEN -1 ELSE 0 END ELSE 0 END) ApprovedSurchargedCount,
    SUM(CASE WHEN t.ResponseCodeInternal=0 AND (t.TransactionState=1 OR (t.TransactionState=2 AND d.QuestionablePolicy=1)) THEN t.AmountSurcharge ELSE 0 END) BaseAmount
  FROM dbo.tbl_trn_Transaction t
  JOIN dbo.tbl_Device                                     d  ON d.Id=t.DeviceId
  LEFT JOIN dbo.tbl_DeviceToSurchargeSplitAccountOverride b3 ON b3.DeviceId=t.DeviceId AND b3.StartDate<=t.Systemdate AND b3.EndDate>t.Systemdate AND b3.OverrideType=1 AND b3.OverrideData=t.TransactionType
  LEFT JOIN dbo.tbl_DeviceToSurchargeSplitAccountOverride b2 ON b2.DeviceId=t.DeviceId AND b2.StartDate<=t.Systemdate AND b2.EndDate>t.Systemdate AND b2.OverrideType=2 AND b2.OverrideData=t.IssuerNetworkId AND b3.Id IS NULL
  LEFT JOIN dbo.tbl_DeviceToSurchargeSplitAccount         b1 ON b1.DeviceId=t.DeviceId AND b1.StartDate<=t.Systemdate AND b1.EndDate>t.Systemdate AND b3.Id IS NULL AND b2.Id IS NULL
  JOIN dbo.tbl_BankAccountSchedule                        s1 ON s1.BankAccountId=ISNULL(ISNULL(b3.BankAccountId,b2.BankAccountId),b1.BankAccountId) AND s1.FundsType=2
  LEFT JOIN dbo.tbl_BankAccountScheduleOverride           s2 ON s2.BankAccountId=ISNULL(ISNULL(b3.BankAccountId,b2.BankAccountId),b1.BankAccountId) AND s2.FundsType=2 AND s2.DeviceId=t.DeviceId
  JOIN dbo.tbl_AchFile                                    f  ON f.Id=s1.AchFileId
  LEFT JOIN dbo.tbl_DeviceCutoverOffset                   c  ON c.DeviceId=t.DeviceId AND c.FundsType=2
  WHERE t.SystemDate>=dbo.udf_GetLastSettlementTime(t.DeviceId,ISNULL(ISNULL(b3.BankAccountId,b2.BankAccountId),b1.BankAccountId),2,1)
    AND t.SystemDate <dbo.udf_GetSettlementTime(c.DepositExec,t.DeviceId,@SettlementDeviceOffDays,@SettlementDate,f.Cutover*60+ISNULL(c.CutoverOffset,0),ISNULL(s2.ScheduleType,s1.ScheduleType),ISNULL(s2.ScheduleDay,s1.ScheduleDay))
    AND t.TransactionType IN (1,2,3,4,5,6,7,8,9,10,11,12,101,103,104,107,108,109,110,111,112)    
    AND (ISNULL(s2.ScheduleType,s1.ScheduleType) IN (5) AND c.DepositExec=0)
  GROUP BY 
    t.DeviceId,ISNULL(ISNULL(b3.BankAccountId,b2.BankAccountId),b1.BankAccountId),s1.AchFileId,f.SurchargeLabel,f.StandardEntryClassCode,f.Cutover,ISNULL(s2.ScheduleType,s1.ScheduleType),ISNULL(s2.ScheduleDay,s1.ScheduleDay),ISNULL(s2.ThresholdAmount,s1.ThresholdAmount),c.DepositExec,c.CutoverOffset,
    ISNULL(ISNULL(b3.SplitType,b2.SplitType),b1.SplitType),ISNULL(ISNULL(b3.SplitData,b2.SplitData),b1.SplitData)
    
  /***** Create ach interchange records from transaction records for threshold amount payment *****/
  INSERT INTO @AchTransaction(
    SettlementDate,SettlementType,SettlementTime,
    SourceId,BankAccountId,FundsType,AchFileId,BatchHeader,StandardEntryClassCode,DepositExec,CutoverOffset,ScheduleType,ScheduleDay,ThresholdAmount,SplitType,SplitData,
    ApprovedCount,DeclinedCount,ApprovedDispensedCount,ApprovedSurchargedCount,BaseAmount)
  SELECT 
    @SettlementDate,1 SettlementType,
    dbo.udf_GetSettlementTime(c.DepositExec,t.DeviceId,@SettlementDeviceOffDays,@SettlementDate,f.Cutover*60+ISNULL(c.CutoverOffset,0),ISNULL(s2.ScheduleType,s1.ScheduleType),ISNULL(s2.ScheduleDay,s1.ScheduleDay)) SettlementTime,
    t.DeviceId,b.BankAccountId,3 FundsType,s1.AchFileId,f.InterchangeLabel,f.StandardEntryClassCode,c.DepositExec,c.CutoverOffset,
    ISNULL(s2.ScheduleType,s1.ScheduleType) ScheduleType,ISNULL(s2.ScheduleDay,s1.ScheduleDay) ScheduleDay,ISNULL(s2.ThresholdAmount,s1.ThresholdAmount) ThresholdAmount,
    b.SplitType,b.SplitData,
    SUM(CASE WHEN t.ResponseCodeInternal=0  THEN 1 ELSE 0 END) ApprovedCount,
    SUM(CASE WHEN t.ResponseCodeInternal<>0 THEN 1 ELSE 0 END) DeclinedCount,
    SUM(CASE WHEN t.ResponseCodeInternal=0 AND (t.TransactionState=1 OR (t.TransactionState=2 AND d.QuestionablePolicy=1)) THEN CASE WHEN t.AmountSettlement-t.AmountSurcharge>0 THEN 1 WHEN t.AmountSettlement-t.AmountSurcharge<0 THEN -1 ELSE 0 END ELSE 0 END) ApprovedDispensedCount,
    SUM(CASE WHEN t.ResponseCodeInternal=0 AND (t.TransactionState=1 OR (t.TransactionState=2 AND d.QuestionablePolicy=1)) THEN CASE WHEN t.AmountSurcharge>0                    THEN 1 WHEN t.AmountSurcharge<0                    THEN -1 ELSE 0 END ELSE 0 END) ApprovedSurchargedCount,
    SUM(CASE WHEN t.ResponseCodeInternal=0 THEN a.AmountApproval ELSE a.AmountDeclined END) BaseAmount
  FROM dbo.tbl_trn_Transaction t
  JOIN dbo.tbl_Device                           d  ON d.Id=t.DeviceId
  JOIN dbo.tbl_DeviceToInterchangeSplitAccount  b  ON b.DeviceId=t.DeviceId AND b.StartDate<=t.Systemdate AND b.EndDate>t.Systemdate
  JOIN dbo.tbl_DeviceToInterchangeScheme        i  ON i.DeviceId=t.DeviceId
  LEFT JOIN dbo.tbl_InterchangeSchemeSignature  g1 ON g1.InterchangeSchemeId=i.InterchangeSchemeId AND g1.IssuerNetworkId=t.IssuerNetworkId AND g1.TransactionType=t.TransactionType
  LEFT JOIN dbo.tbl_InterchangeSchemeSignature  g2 ON g2.InterchangeSchemeId=i.InterchangeSchemeId AND g2.IssuerNetworkId=t.IssuerNetworkId AND t.TransactionType IN (7,8,9,10,11,12,107,108,109,110,111,112) AND ((t.TransactionFlags & 0x00080000 > 0 AND g2.TransactionType=91) /*POS Credit*/ OR (t.TransactionFlags & 0x00080000 = 0 AND g2.TransactionType=92) /*POS Debit*/)
  LEFT JOIN dbo.tbl_InterchangeSchemeSignature  g3 ON g3.InterchangeSchemeId=i.InterchangeSchemeId AND g3.IssuerNetworkId=N'ALL'            AND g3.TransactionType=t.TransactionType
  LEFT JOIN dbo.tbl_InterchangeSchemeSignature  g4 ON g4.InterchangeSchemeId=i.InterchangeSchemeId AND g4.IssuerNetworkId=N'ALL'            AND t.TransactionType IN (7,8,9,10,11,12,107,108,109,110,111,112) AND ((t.TransactionFlags & 0x00080000 > 0 AND g4.TransactionType=91) /*POS Credit*/ OR (t.TransactionFlags & 0x00080000 = 0 AND g4.TransactionType=92) /*POS Debit*/)
  LEFT JOIN dbo.tbl_InterchangeSchemeSignature  g5 ON g5.InterchangeSchemeId=i.InterchangeSchemeId AND g5.IssuerNetworkId=t.IssuerNetworkId AND g5.TransactionType=0
  LEFT JOIN dbo.tbl_InterchangeSchemeSignature  g6 ON g6.InterchangeSchemeId=i.InterchangeSchemeId AND g6.IssuerNetworkId=N'ALL'            AND g6.TransactionType=0
  JOIN dbo.tbl_InterchangeSchemeSignatureAmount a  ON a.InterchangeSchemeSignatureId=ISNULL(ISNULL(ISNULL(ISNULL(ISNULL(g1.Id,g2.Id),g3.Id),g4.Id),g5.Id),g6.Id) AND a.Recipient=b.Recipient
  JOIN dbo.tbl_BankAccountSchedule              s1 ON s1.BankAccountId=b.BankAccountId AND s1.FundsType=3
  LEFT JOIN dbo.tbl_BankAccountScheduleOverride s2 ON s2.BankAccountId=b.BankAccountId AND s2.FundsType=3 AND s2.DeviceId=t.DeviceId
  JOIN dbo.tbl_AchFile                          f  ON f.Id=s1.AchFileId
  LEFT JOIN dbo.tbl_DeviceCutoverOffset         c  ON c.DeviceId=t.DeviceId AND c.FundsType=3
  WHERE t.SystemDate>=dbo.udf_GetLastSettlementTime(t.DeviceId,b.BankAccountId,3,1)
    AND t.SystemDate <dbo.udf_GetSettlementTime(c.DepositExec,t.DeviceId,@SettlementDeviceOffDays,@SettlementDate,f.Cutover*60+ISNULL(c.CutoverOffset,0),ISNULL(s2.ScheduleType,s1.ScheduleType),ISNULL(s2.ScheduleDay,s1.ScheduleDay))
    AND t.TransactionType IN (1,2,3,4,5,6,7,8,9,10,11,12,101,103,104,107,108,109,110,111,112)    
    AND (ISNULL(s2.ScheduleType,s1.ScheduleType) IN (5) AND c.DepositExec=0)
  GROUP BY 
    t.DeviceId,b.BankAccountId,s1.AchFileId,f.InterchangeLabel,f.StandardEntryClassCode,f.Cutover,ISNULL(s2.ScheduleType,s1.ScheduleType),ISNULL(s2.ScheduleDay,s1.ScheduleDay),ISNULL(s2.ThresholdAmount,s1.ThresholdAmount),c.DepositExec,c.CutoverOffset,
    b.SplitType,b.SplitData

  /***** Create ach credit commission records from transaction records  for threshold amount payment*****/
  INSERT INTO @AchTransaction(
    SettlementDate,SettlementType,SettlementTime,
    SourceId,BankAccountId,FundsType,AchFileId,BatchHeader,StandardEntryClassCode,DepositExec,CutoverOffset,ScheduleType,ScheduleDay,ThresholdAmount,
    ApprovedCount,DeclinedCount,ApprovedDispensedCount,ApprovedSurchargedCount,BaseAmount)
  SELECT 
    @SettlementDate,2 SettlementType,
    dbo.udf_GetSettlementTime(c.DepositExec,t.DeviceId,@SettlementDeviceOffDays,@SettlementDate,f.Cutover*60+ISNULL(c.CutoverOffset,0),ISNULL(s2.ScheduleType,s1.ScheduleType),ISNULL(s2.ScheduleDay,s1.ScheduleDay)) SettlementTime,
    t.DeviceId,ISNULL(b2.BankAccountId,b1.BankAccountId) BankAccountId,1 FundsType,s1.AchFileId,f.SettlementLabel,f.StandardEntryClassCode,c.DepositExec,c.CutoverOffset,
    ISNULL(s2.ScheduleType,s1.ScheduleType) ScheduleType,ISNULL(s2.ScheduleDay,s1.ScheduleDay) ScheduleDay,ISNULL(s2.ThresholdAmount,s1.ThresholdAmount) ThresholdAmount,
    SUM(CASE WHEN t.ResponseCodeInternal=0  THEN 1 ELSE 0 END) ApprovedCount,
    SUM(CASE WHEN t.ResponseCodeInternal<>0 THEN 1 ELSE 0 END) DeclinedCount,
    SUM(CASE WHEN t.ResponseCodeInternal=0 AND (t.TransactionState=1 OR (t.TransactionState=2 AND d.QuestionablePolicy=1)) THEN CASE WHEN t.AmountSettlement-t.AmountSurcharge>0 THEN 1 WHEN t.AmountSettlement-t.AmountSurcharge<0 THEN -1 ELSE 0 END ELSE 0 END) ApprovedDispensedCount,
    SUM(CASE WHEN t.ResponseCodeInternal=0 AND (t.TransactionState=1 OR (t.TransactionState=2 AND d.QuestionablePolicy=1)) THEN CASE WHEN t.AmountSurcharge>0                    THEN 1 WHEN t.AmountSurcharge<0                    THEN -1 ELSE 0 END ELSE 0 END) ApprovedSurchargedCount,
    SUM(CASE WHEN t.ResponseCodeInternal=0 AND (t.TransactionState=1 OR (t.TransactionState=2 AND d.QuestionablePolicy=1)) THEN -t.AmountCommission ELSE 0 END) BaseAmount
  FROM dbo.tbl_trn_Transaction t
  JOIN dbo.tbl_Device                                 d  ON d.Id=t.DeviceId
  JOIN dbo.tbl_DeviceToSettlementAccount              b1 ON b1.DeviceId=t.DeviceId AND b1.StartDate<=t.Systemdate AND b1.EndDate>t.Systemdate
  LEFT JOIN dbo.tbl_DeviceToSettlementAccountOverride b2 ON b2.DeviceId=t.DeviceId AND b2.StartDate<=t.Systemdate AND b2.EndDate>t.Systemdate AND b2.OverrideType=1 AND b2.OverrideData=t.TransactionType 
  JOIN dbo.tbl_BankAccountSchedule                    s1 ON s1.BankAccountId=ISNULL(b2.BankAccountId,b1.BankAccountId) AND s1.FundsType=1
  LEFT JOIN dbo.tbl_BankAccountScheduleOverride       s2 ON s2.BankAccountId=ISNULL(b2.BankAccountId,b1.BankAccountId) AND s2.FundsType=1 AND s2.DeviceId=t.DeviceId
  JOIN dbo.tbl_AchFile                                f  ON f.Id=s1.AchFileId
  LEFT JOIN dbo.tbl_DeviceCutoverOffset               c  ON c.DeviceId=t.DeviceId AND c.FundsType=1
  WHERE t.SystemDate>=dbo.udf_GetLastSettlementTime(t.DeviceId,ISNULL(b2.BankAccountId,b1.BankAccountId),1,2)
    AND t.SystemDate <dbo.udf_GetSettlementTime(c.DepositExec,t.DeviceId,@SettlementDeviceOffDays,@SettlementDate,f.Cutover*60+ISNULL(c.CutoverOffset,0),ISNULL(s2.ScheduleType,s1.ScheduleType),ISNULL(s2.ScheduleDay,s1.ScheduleDay))
    AND t.TransactionType IN (1,2,3,4,5,6,7,8,9,10,11,12,101,103,104,107,108,109,110,111,112)    
    AND (ISNULL(s2.ScheduleType,s1.ScheduleType) IN (5) AND c.DepositExec=0)
  GROUP BY 
    t.DeviceId,ISNULL(b2.BankAccountId,b1.BankAccountId),s1.AchFileId,f.SettlementLabel,f.StandardEntryClassCode,f.Cutover,ISNULL(s2.ScheduleType,s1.ScheduleType),ISNULL(s2.ScheduleDay,s1.ScheduleDay),ISNULL(s2.ThresholdAmount,s1.ThresholdAmount),c.DepositExec,c.CutoverOffset
  HAVING 
    SUM(CASE WHEN t.ResponseCodeInternal=0 AND (t.TransactionState=1 OR (t.TransactionState=2 AND d.QuestionablePolicy=1)) THEN -t.AmountCommission ELSE 0 END)<>0
    
  /***** Update amount *****/
  UPDATE @AchTransaction SET Amount=
    CASE WHEN SplitType=0 OR (SplitType=2 AND SplitData>0) THEN BaseAmount*CONVERT(money,SplitData)/1000000
         WHEN SplitType=1 AND FundsType=2                  THEN ApprovedSurchargedCount*SplitData
         WHEN SplitType=2 AND FundsType=2                  THEN BaseAmount+ApprovedSurchargedCount*SplitData
         WHEN SplitType=1 AND FundsType=3                  THEN (ApprovedCount+DeclinedCount)*SplitData
         WHEN SplitType=2 AND FundsType=3                  THEN BaseAmount+(ApprovedCount+DeclinedCount)*SplitData
         ELSE                                                   0
    END
  WHERE SettlementDate=@SettlementDate

  /***** Create ach records from table variable records for ThresholdAmount *****/
  DECLARE @BankAccountIdFundsType TABLE(BankAccountId bigint,FundsType bigint)
  INSERT INTO @BankAccountIdFundsType(BankAccountId,FundsType) SELECT BankAccountId,FundsType FROM @AchTransaction GROUP BY BankAccountId,FundsType HAVING SUM(Amount)>MAX(ThresholdAmount)
  
  INSERT INTO dbo.tbl_AchTransaction(
    SettlementDate,SettlementType,SettlementTime,
    SourceId,BankAccountId,FundsType,AchFileId,BatchHeader,StandardEntryClassCode,DepositExec,CutoverOffset,ScheduleType,ScheduleDay,ThresholdAmount,SplitType,SplitData,
    ApprovedCount,DeclinedCount,ApprovedDispensedCount,ApprovedSurchargedCount,BaseAmount,Amount)
  SELECT  
    SettlementDate,SettlementType,SettlementTime,
    SourceId,t.BankAccountId,t.FundsType,AchFileId,BatchHeader,StandardEntryClassCode,DepositExec,CutoverOffset,ScheduleType,ScheduleDay,ThresholdAmount,SplitType,SplitData,
    ApprovedCount,DeclinedCount,ApprovedDispensedCount,ApprovedSurchargedCount,BaseAmount,Amount
  FROM @AchTransaction t
  JOIN @BankAccountIdFundsType b ON b.BankAccountId=t.BankAccountId AND b.FundsType=t.FundsType

  /***********************************************************************************************/
  /***********************************************************************************************/
  /***********************************************************************************************/

  /***** Create ach debit commission records from AchTransaction credit commission records *****/
  INSERT INTO dbo.tbl_AchTransaction(
    SettlementDate,SettlementType,SettlementTime,
    SourceId,BankAccountId,FundsType,AchFileId,BatchHeader,StandardEntryClassCode,DepositExec,CutoverOffset,ScheduleType,ScheduleDay,ThresholdAmount,
    ApprovedCount,DeclinedCount,ApprovedDispensedCount,ApprovedSurchargedCount,BaseAmount,Amount)
  SELECT 
    SettlementDate,SettlementType,SettlementTime,
    SourceId,@NRTCommissionBankAccountId BankAccountId,FundsType,AchFileId,BatchHeader,StandardEntryClassCode,DepositExec,CutoverOffset,ScheduleType,ScheduleDay,ThresholdAmount,
    ApprovedCount,DeclinedCount,ApprovedDispensedCount,ApprovedSurchargedCount,-1*BaseAmount,-1*Amount
  FROM dbo.tbl_AchTransaction  
  WHERE   
    SettlementDate=@SettlementDate AND SettlementType=2 AND SettlementStatus=1
END
GO
