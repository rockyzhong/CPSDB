SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_trn_UpdateTelecheckACHCount]
AS
BEGIN

DECLARE @CurDate DATETIME,@PreDate DATETIME
SET @CurDate=GETUTCDATE()
SELECT TOP 1 @PreDate=UpdatedDate FROM dbo.tbl_trn_TransactionTeleCheckACHCount 

IF OBJECT_ID('tempdb..#TermpTransactionTeleCheckACHCount') IS NOT NULL
BEGIN
	TRUNCATE TABLE #TermpTransactionTeleCheckACHCount
	DROP TABLE #TermpTransactionTeleCheckACHCount
END

SELECT CustomerId,MIN(SystemTime) EnrollDate,SUM(CASE WHEN TransactionType IN (52,56) THEN 1 ELSE 0 END) AS ACHTransCount, SUM(CASE WHEN TransactionType IN (52,56) THEN AmountSettlement ELSE 0 END) AS ACHTransAmount,
SUM(CASE WHEN TransactionType IN (54,61,63) THEN 1 ELSE 0 END) AS NonACHTransCount, SUM(CASE WHEN TransactionType IN (54,61,63) THEN AmountSettlement ELSE 0 END) AS NonACHTransAmount,MIN(@CurDate) UpdatedDate
INTO #TermpTransactionTeleCheckACHCount
FROM dbo.tbl_trn_Transaction WHERE TransactionType IN (52,56,54,61,63) AND ResponseCodeInternal=0 AND CustomerId IS NOT NULL AND SystemTime BETWEEN @PreDate AND @CurDate
GROUP BY CustomerId ORDER BY CustomerId DESC

MERGE INTO dbo.tbl_trn_TransactionTeleCheckACHCount tta
USING #TermpTransactionTeleCheckACHCount ttb
ON tta.CustomerId=ttb.CustomerId
WHEN MATCHED THEN 
  UPDATE 
  SET tta.ACHTransCount=tta.ACHTransCount+ttb.ACHTransCount,tta.ACHTransAmount=tta.ACHTransAmount+ttb.ACHTransAmount,
      tta.NonACHTransCount=tta.NonACHTransCount+ttb.NonACHTransCount,tta.NonACHTransAmount=tta.NonACHTransAmount+ttb.NonACHTransAmount,tta.UpdatedDate=@CurDate
WHEN NOT MATCHED BY TARGET THEN
  INSERT (CustomerId,EnrollDate,ACHTransCount,ACHTransAmount,NonACHTransCount,NonACHTransAmount,UpdatedDate)
  VALUES (ttb.CustomerId,ttb.EnrollDate,ttb.ACHTransCount,ttb.ACHTransAmount,ttb.NonACHTransCount,ttb.NonACHTransAmount,@CurDate);
IF OBJECT_ID('tempdb..#TermpTransactionTeleCheckACHCount') IS NOT NULL
BEGIN
	TRUNCATE TABLE #TermpTransactionTeleCheckACHCount
	DROP TABLE #TermpTransactionTeleCheckACHCount
END

UPDATE dbo.tbl_trn_TransactionTeleCheckACHCount SET UpdatedDate=@CurDate
END   
GO
