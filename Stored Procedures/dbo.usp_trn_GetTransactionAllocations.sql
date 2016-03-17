SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_trn_GetTransactionAllocations]
@TransactionId           bigint,
@TransactionDate         datetime
AS
BEGIN
  SET NOCOUNT ON
  
  IF NOT EXISTS(SELECT Id FROM dbo.tbl_trn_TransactionAllocation WHERE TransactionId=@TransactionId)
  BEGIN
    DECLARE @NRTCommissionBankAccountId bigint,@SettlementDeviceOffDays bigint
    SELECT @NRTCommissionBankAccountId=CONVERT(bigint,Value) FROM dbo.tbl_Parameter WHERE Name='NRTCommissionBankAccountId'

    /***** Create settlement records from transaction records *****/
    INSERT INTO dbo.tbl_trn_TransactionAllocation(SettlementType,TransactionId,SystemDate,DeviceId,BankAccountId,FundsType,BaseAmount)
    SELECT 
      1 SettlementType,@TransactionId TransactionId,t.SystemDate,t.DeviceId,
      ISNULL(b2.BankAccountId,b1.BankAccountId) BankAccountId,1 FundsType,
      t.AmountSettlement-t.AmountSurcharge BaseAmount
    FROM dbo.tbl_trn_Transaction t
    JOIN dbo.tbl_Device                                 d  ON d.Id=t.DeviceId
    JOIN dbo.tbl_DeviceToSettlementAccount              b1 ON b1.DeviceId=t.DeviceId AND b1.StartDate<=t.Systemdate AND b1.EndDate>t.Systemdate
    LEFT JOIN dbo.tbl_DeviceToSettlementAccountOverride b2 ON b2.DeviceId=t.DeviceId AND b2.StartDate<=t.Systemdate AND b2.EndDate>t.Systemdate AND b2.OverrideType=1 AND b2.OverrideData=t.TransactionType 
    WHERE t.Id=@TransactionId
      AND t.TransactionType IN (1,2,3,4,5,6,7,8,9,10,11,12,101,103,104,107,108,109,110,111,112)    
      AND t.ResponseCodeInternal=0 AND (t.TransactionState=1 OR (t.TransactionState=2 AND d.QuestionablePolicy=1))
      AND t.AmountSettlement-t.AmountSurcharge<>0
    
    /***** Create surcharge records from transaction records *****/
    INSERT INTO dbo.tbl_trn_TransactionAllocation(SettlementType,TransactionId,SystemDate,DeviceId,BankAccountId,FundsType,SplitType,SplitData,BaseAmount)
    SELECT
      1 SettlementType,@TransactionId TransactionId,t.SystemDate,t.DeviceId,
      ISNULL(ISNULL(b3.BankAccountId,b2.BankAccountId),b1.BankAccountId) BankAccountId,2 FundsType,
      ISNULL(ISNULL(b3.SplitType,b2.SplitType),b1.SplitType) SplitType,ISNULL(ISNULL(b3.SplitData,b2.SplitData),b1.SplitData) SplitData,
      t.AmountSurcharge
    FROM dbo.tbl_trn_Transaction t
    JOIN dbo.tbl_Device                                     d  ON d.Id=t.DeviceId
    LEFT JOIN dbo.tbl_DeviceToSurchargeSplitAccountOverride b3 ON b3.DeviceId=t.DeviceId AND b3.StartDate<=t.Systemdate AND b3.EndDate>t.Systemdate AND b3.OverrideType=1 AND b3.OverrideData=t.TransactionType
    LEFT JOIN dbo.tbl_DeviceToSurchargeSplitAccountOverride b2 ON b2.DeviceId=t.DeviceId AND b2.StartDate<=t.Systemdate AND b2.EndDate>t.Systemdate AND b2.OverrideType=2 AND b2.OverrideData=t.IssuerNetworkId AND b3.Id IS NULL
    LEFT JOIN dbo.tbl_DeviceToSurchargeSplitAccount         b1 ON b1.DeviceId=t.DeviceId AND b1.StartDate<=t.Systemdate AND b1.EndDate>t.Systemdate AND b3.Id IS NULL AND b2.Id IS NULL
    WHERE t.Id=@TransactionId
      AND t.TransactionType IN (1,2,3,4,5,6,7,8,9,10,11,12,101,103,104,107,108,109,110,111,112)    
      AND t.ResponseCodeInternal=0 AND (t.TransactionState=1 OR (t.TransactionState=2 AND d.QuestionablePolicy=1))
      AND t.AmountSurcharge<>0
    
    /***** Create interchange records from transaction records *****/
    INSERT INTO dbo.tbl_trn_TransactionAllocation(SettlementType,TransactionId,SystemDate,DeviceId,BankAccountId,FundsType,SplitType,SplitData,BaseAmount)
    SELECT 
      1 SettlementType,@TransactionId TransactionId,t.SystemDate,t.DeviceId,
      b.BankAccountId,3 FundsType,
      b.SplitType,b.SplitData,
      CASE WHEN t.ResponseCodeInternal=0 THEN a.AmountApproval ELSE a.AmountDeclined END BaseAmount
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
    WHERE t.Id=@TransactionId
      AND t.TransactionType IN (1,2,3,4,5,6,7,8,9,10,11,12,101,103,104,107,108,109,110,111,112)    
      AND CASE WHEN t.ResponseCodeInternal=0 THEN a.AmountApproval ELSE a.AmountDeclined END <> 0

    /***** Create credit commission records from transaction records *****/
    INSERT INTO dbo.tbl_trn_TransactionAllocation(SettlementType,TransactionId,SystemDate,DeviceId,BankAccountId,FundsType,BaseAmount)
    SELECT 
      2 SettlementType,@TransactionId TransactionId,t.SystemDate,t.DeviceId,
      ISNULL(b2.BankAccountId,b1.BankAccountId) BankAccountId,1 FundsType,
      -t.AmountCommission BaseAmount
    FROM dbo.tbl_trn_Transaction t
    JOIN dbo.tbl_Device                                 d  ON d.Id=t.DeviceId
    JOIN dbo.tbl_DeviceToSettlementAccount              b1 ON b1.DeviceId=t.DeviceId AND b1.StartDate<=t.Systemdate AND b1.EndDate>t.Systemdate
    LEFT JOIN dbo.tbl_DeviceToSettlementAccountOverride b2 ON b2.DeviceId=t.DeviceId AND b2.StartDate<=t.Systemdate AND b2.EndDate>t.Systemdate AND b2.OverrideType=1 AND b2.OverrideData=t.TransactionType 
    WHERE t.Id=@TransactionId
      AND t.TransactionType IN (1,2,3,4,5,6,7,8,9,10,11,12,101,103,104,107,108,109,110,111,112)    
      AND t.ResponseCodeInternal=0 AND (t.TransactionState=1 OR (t.TransactionState=2 AND d.QuestionablePolicy=1))
      AND t.AmountCommission<>0

    /***** Update amount *****/
    UPDATE dbo.tbl_trn_TransactionAllocation SET Amount=
      CASE WHEN SplitType=0 OR (SplitType=2 AND SplitData>0) THEN BaseAmount*CONVERT(money,SplitData)/1000000
           WHEN SplitType=1 AND FundsType=2                  THEN SplitData
           WHEN SplitType=2 AND FundsType=2                  THEN BaseAmount+SplitData
           WHEN SplitType=1 AND FundsType=3                  THEN SplitData
           WHEN SplitType=2 AND FundsType=3                  THEN BaseAmount+SplitData
           ELSE                                                   0
      END
    WHERE TransactionId=@TransactionId
    
    /***** Create debit commission records from transaction records *****/
    INSERT INTO dbo.tbl_trn_TransactionAllocation(SettlementType,TransactionId,SystemDate,DeviceId,BankAccountId,FundsType,BaseAmount,Amount)
    SELECT SettlementType,TransactionId,SystemDate,DeviceId,@NRTCommissionBankAccountId BankAccountId,FundsType,-1*BaseAmount,-1*Amount
    FROM dbo.tbl_trn_TransactionAllocation t
    WHERE TransactionId=@TransactionId AND SettlementType=2
  END    

  /***** Update SettlementDate *****/
  DECLARE @Id bigint,@DeviceId bigint,@BankAccountId bigint,@FundsType bigint,@SystemDate datetime,@SettlementDate datetime
  DECLARE TempCursor CURSOR LOCAL FOR SELECT Id,DeviceId,BankAccountId,FundsType,SystemDate FROM dbo.tbl_trn_TransactionAllocation WHERE TransactionId=@TransactionId AND SettlementDate IS NULL
  OPEN TempCursor
  FETCH NEXT FROM TempCursor INTO @Id,@DeviceId,@BankAccountId,@FundsType,@SystemDate
  WHILE @@Fetch_Status=0
  BEGIN
    SELECT @SettlementDate=MAX(SettlementDate) FROM dbo.tbl_AchTransaction WHERE SourceType=1 AND SourceId=@DeviceId AND BankAccountId=@BankAccountId AND FundsType=@FundsType AND SettlementTime>@SystemDate
    UPDATE dbo.tbl_trn_TransactionAllocation SET SettlementDate=@SettlementDate WHERE Id=@Id
    FETCH NEXT FROM TempCursor INTO @Id,@DeviceId,@BankAccountId,@FundsType,@SystemDate
  END  
  CLOSE TempCursor
  DEALLOCATE TempCursor
    
  SELECT a.FundsType,a.BaseAmount,b.HolderName,b.Rta,a.Amount,a.SettlementDate
  FROM dbo.tbl_trn_TransactionAllocation a
  JOIN dbo.tbl_BankAccount b ON a.BankAccountId=b.Id
  WHERE TransactionId=@TransactionId
END
GO
GRANT EXECUTE ON  [dbo].[usp_trn_GetTransactionAllocations] TO [WebV4Role]
GO
