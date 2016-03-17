SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/***/
CREATE PROCEDURE [dbo].[usp_bak_GetBankAccountByUser]
@UserId     bigint,
@StartsWith nvarchar(20) = NULL,
@Contain    nvarchar(20) = NULL
WITH EXECUTE AS 'dbo'
AS
BEGIN
  SET NOCOUNT ON

  DECLARE @SQL nvarchar(max) 
  SET @SQL='
  DECLARE @Source TABLE(Id bigint)
  INSERT INTO @Source EXEC dbo.usp_upm_GetObjectIds @UserId,3,1

  SELECT b.Id BankAccountId,b.BankAccountType,b.BankAccountCategory,b.HolderName,b.Rta,b.Currency,b.BankName,b.ConsolidationType,b.BankAccountStatus,b.CriminalCheckStatus,b.CriminalCheckIssueDate,
         CASE WHEN LEN(b.RTA)<= 10 THEN b.RTA
              WHEN b.Currency=124  THEN Substring(b.RTA,1,5)+''-''+Substring(b.RTA,6,3)+''-''+Substring(b.RTA,9, 17)
              WHEN b.Currency=840  THEN Substring(b.RTA,1,9)+'' ''+Substring(b.RTA, 10, 20) 
              ELSE b.RTA
         END FormattedRTA      
  FROM dbo.tbl_BankAccount b
  WHERE b.Id IN (SELECT Id FROM @Source)'
  IF @StartsWith IS NOT NULL  SET @SQL=@SQL+' AND b.HolderName LIKE @StartsWith + ''%'''
  IF @Contain    IS NOT NULL  SET @SQL=@SQL+' AND CHARINDEX(@Contain,LTRIM(b.HolderName)+LEFT(LTRIM(b.RTA),5),1)>0'
  SET @SQL=@SQL+' ORDER BY b.HolderName,b.RTA'
  EXEC SP_EXECUTESQL @SQL,N'@UserId bigint,@StartsWith nvarchar(20),@Contain nvarchar(20)',@UserId,@StartsWith,@Contain
END
GO
