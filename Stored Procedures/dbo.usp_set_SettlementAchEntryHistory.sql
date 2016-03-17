SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[usp_set_SettlementAchEntryHistory] 
@SettlementDate datetime
AS
BEGIN
  SET NOCOUNT ON

  /***** Generate ach entry records *****/
  INSERT INTO dbo.tbl_AchEntryHistory(
    SettlementDate,AchFileId,AchFileNumber,BatchHeader,StandardEntryClassCode,
    BankAccountHolderName,BankAccountType,BankAccountRta,
    ReferenceName,PayoutDate,Amount) 
  SELECT 
    @SettlementDate,t.AchFileId,dbo.udf_GetAchFileNumber(@SettlementDate,t.AchFileId),t.BatchHeader,t.StandardEntryClassCode,
    b.HolderName,b.BankAccountType,b.Rta,
    dbo.udf_GetSourceName(t.SourceType,t.SourceId)+dbo.udf_GetFundsTypeCode(t.FundsType) ReferenceName,
    DATEADD(dd,dbo.udf_GetPayoutDays(t.BankAccountId,t.SourceType,t.SourceId,t.FundsType),@SettlementDate) PayoutDate,
    SUM(Amount)/100
  FROM dbo.tbl_AchTransaction t
  JOIN dbo.tbl_BankAccount    b ON b.Id=t.BankAccountId
  WHERE t.SettlementDate=@SettlementDate AND t.SettlementStatus=1 AND b.ConsolidationType=1
  GROUP BY t.AchFileId,t.BatchHeader,t.StandardEntryClassCode,t.BankAccountId,t.FundsType,t.SourceType,t.SourceId,b.HolderName,b.BankAccountType,b.Rta
  
  INSERT INTO dbo.tbl_AchEntryHistory(
    SettlementDate,AchFileId,AchFileNumber,BatchHeader,StandardEntryClassCode,
    BankAccountHolderName,BankAccountType,BankAccountRta,
    ReferenceName,PayoutDate,Amount) 
  SELECT 
    @SettlementDate,t.AchFileId,dbo.udf_GetAchFileNumber(@SettlementDate,t.AchFileId),t.BatchHeader,t.StandardEntryClassCode,
    b.HolderName,b.BankAccountType,b.Rta,
    dbo.udf_GetSourceName(t.SourceType,t.SourceId) ReferenceName,
    DATEADD(dd,dbo.udf_GetPayoutDays(t.BankAccountId,t.SourceType,t.SourceId,1),@SettlementDate) PayoutDate,
    SUM(Amount)/100
  FROM dbo.tbl_AchTransaction t
  JOIN dbo.tbl_BankAccount    b ON b.Id=t.BankAccountId
  WHERE t.SettlementDate=@SettlementDate AND t.SettlementStatus=1 AND b.ConsolidationType=2
  GROUP BY t.AchFileId,t.BatchHeader,t.StandardEntryClassCode,t.BankAccountId,t.SourceType,t.SourceId,b.HolderName,b.BankAccountType,b.Rta
    
  INSERT INTO dbo.tbl_AchEntryHistory(
    SettlementDate,AchFileId,AchFileNumber,BatchHeader,StandardEntryClassCode,
    BankAccountHolderName,BankAccountType,BankAccountRta,
    ReferenceName,PayoutDate,Amount) 
  SELECT 
    @SettlementDate,t.AchFileId,dbo.udf_GetAchFileNumber(@SettlementDate,t.AchFileId),t.BatchHeader,t.StandardEntryClassCode,
    b.HolderName,b.BankAccountType,b.Rta,
    f.CompanyName+dbo.udf_GetFundsTypeCode(t.FundsType) ReferenceName,
    DATEADD(dd,dbo.udf_GetPayoutDays(t.BankAccountId,0,0,t.FundsType),@SettlementDate) PayoutDate,
    SUM(Amount)/100
  FROM dbo.tbl_AchTransaction t
  JOIN dbo.tbl_BankAccount    b ON b.Id=t.BankAccountId
  JOIN dbo.tbl_AchFile        f ON f.Id=t.AchFileId
  WHERE t.SettlementDate=@SettlementDate AND t.SettlementStatus=1 AND b.ConsolidationType=3
  GROUP BY t.AchFileId,t.BatchHeader,t.StandardEntryClassCode,t.BankAccountId,t.FundsType,b.HolderName,b.BankAccountType,b.Rta,f.CompanyName

  INSERT INTO dbo.tbl_AchEntryHistory(
    SettlementDate,AchFileId,AchFileNumber,BatchHeader,StandardEntryClassCode,
    BankAccountHolderName,BankAccountType,BankAccountRta,
    ReferenceName,PayoutDate,Amount) 
  SELECT 
    @SettlementDate,t.AchFileId,dbo.udf_GetAchFileNumber(@SettlementDate,t.AchFileId),t.BatchHeader,t.StandardEntryClassCode,
    b.HolderName,b.BankAccountType,b.Rta,
    f.CompanyName ReferenceName,
    DATEADD(dd,dbo.udf_GetPayoutDays(t.BankAccountId,0,0,1),@SettlementDate) PayoutDate,
    SUM(Amount)/100
  FROM dbo.tbl_AchTransaction t
  JOIN dbo.tbl_BankAccount    b ON b.Id=t.BankAccountId
  JOIN dbo.tbl_AchFile        f ON f.Id=t.AchFileId
  WHERE t.SettlementDate=@SettlementDate AND t.SettlementStatus=1 AND b.ConsolidationType=4
  GROUP BY t.AchFileId,t.BatchHeader,t.StandardEntryClassCode,t.BankAccountId,b.HolderName,b.BankAccountType,b.Rta,f.CompanyName

  /***** Generate zreo balancing entry *****/
  INSERT INTO dbo.tbl_AchEntryHistory(
    SettlementDate,AchFileId,AchFileNumber,BatchHeader,StandardEntryClassCode,
    BankAccountHolderName,BankAccountType,BankAccountRta,
    ReferenceName,PayoutDate,Amount) 
  SELECT 
    @SettlementDate,t.AchFileId,t.AchFileNumber,f.SettlementLabel BatchHeader,f.StandardEntryClassCode,
    b.HolderName,b.BankAccountType,b.Rta,
    N'Offset' ReferenceName,
    DATEADD(dd,dbo.udf_GetPayoutDays(o.BankAccountId,0,0,1),@SettlementDate) PayoutDate,
    -1*SUM(t.Amount)
  FROM dbo.tbl_AchEntryHistory t
  JOIN dbo.tbl_AchFileOffsetBankAccount o ON o.AchFileId=t.AchFileId AND o.FundsType=0
  JOIN dbo.tbl_BankAccount              b ON b.Id=o.BankAccountId
  JOIN dbo.tbl_AchFile                  f ON f.Id=t.AchFileId
  WHERE t.SettlementDate=@SettlementDate AND t.SettlementStatus=1
  GROUP BY t.AchFileId,t.AchFileNumber,o.BankAccountId,f.SettlementLabel,f.StandardEntryClassCode,b.HolderName,b.BankAccountType,b.Rta
    
  INSERT INTO dbo.tbl_AchEntryHistory(
     SettlementDate,AchFileId,AchFileNumber,BatchHeader,StandardEntryClassCode,
    BankAccountHolderName,BankAccountType,BankAccountRta,
    ReferenceName,PayoutDate,Amount) 
  SELECT 
    @SettlementDate,t.AchFileId,dbo.udf_GetAchFileNumber(@SettlementDate,t.AchFileId),
    CASE WHEN o.FundsType=1 THEN f.SettlementLabel WHEN o.FundsType=2 THEN f.SurchargeLabel ELSE f.InterchangeLabel END BatchHeader,f.StandardEntryClassCode,
    b.HolderName,b.BankAccountType,b.Rta,    
    N'Offset' ReferenceName,
    DATEADD(dd,dbo.udf_GetPayoutDays(o.BankAccountId,0,0,o.FundsType),@SettlementDate) PayoutDate,
    -1*SUM(Amount)/100
  FROM dbo.tbl_AchTransaction t
  JOIN dbo.tbl_AchFileOffsetBankAccount o ON o.AchFileId=t.AchFileId AND o.FundsType=t.FundsType
  JOIN dbo.tbl_BankAccount              b ON b.Id=o.BankAccountId
  JOIN dbo.tbl_AchFile                  f ON f.Id=t.AchFileId
  WHERE t.SettlementDate=@SettlementDate AND t.SettlementStatus=1
  GROUP BY t.AchFileId,o.BankAccountId,o.FundsType,f.SettlementLabel,f.SurchargeLabel,f.InterchangeLabel,f.StandardEntryClassCode,b.HolderName,b.BankAccountType,b.Rta

  /***** Summarize total debit/credit count and amount for the setlement file *****/
  INSERT INTO dbo.tbl_AchFileHistory(SettlementDate,AchFileId,AchFileNumber,CreditCount,CreditAmount,DebitCount,DebitAmount,FileCreationNo) 
  SELECT 
    @SettlementDate,t.AchFileId,t.AchFileNumber,
    SUM(CASE WHEN t.Amount>0 THEN 1        ELSE 0 END),
    SUM(CASE WHEN t.Amount>0 THEN t.Amount ELSE 0 END),
    SUM(CASE WHEN t.Amount<0 THEN 1        ELSE 0 END),
    SUM(CASE WHEN t.Amount<0 THEN t.Amount ELSE 0 END),
    f.FileCreationNo+1
  FROM dbo.tbl_AchEntryHistory t
  JOIN dbo.tbl_AchFile         f ON f.Id=t.AchFileId
  WHERE t.SettlementDate=@SettlementDate AND t.SettlementStatus=1
  GROUP BY t.AchFileId,t.AchFileNumber,f.FileCreationNo

  --Update file creation number for the settlement template file
  UPDATE dbo.tbl_AchFile SET FileCreationNo=FileCreationNo+1 WHERE Id IN (SELECT DISTINCT AchFileId FROM dbo.tbl_AchEntryHistory WHERE SettlementDate=@SettlementDate AND SettlementStatus=1)

  -- Update Ach transaction settlement status
  UPDATE dbo.tbl_AchTransaction  SET SettlementStatus=2 WHERE SettlementDate=@SettlementDate AND SettlementStatus=1

  -- Update Ach entry settlement status
  UPDATE dbo.tbl_AchEntryHistory SET SettlementStatus=2 WHERE SettlementDate=@SettlementDate AND SettlementStatus=1
END
GO
