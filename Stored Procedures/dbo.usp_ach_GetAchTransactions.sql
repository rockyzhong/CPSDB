SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_ach_GetAchTransactions]
@AchTransactionId         bigint       =NULL,
@IsoId                    bigint       =NULL,
@SourceType               bigint       =NULL,
@SourceId                 bigint       =NULL,
@BankAccountId            bigint       =NULL,
@StartDate                datetime     =NULL,
@EndDate                  datetime     =NULL,
@AchFileId                bigint       =NULL
WITH EXECUTE AS 'dbo'
AS
BEGIN
  SET NOCOUNT ON

  IF @StartDate IS NULL  SET @StartDate=DATEADD(mm,-3,GETUTCDATE())

  DECLARE @SQL nvarchar(max)
  SET @SQL='
  SELECT t.Id AchTransaction,t.SettlementDate,t.SettlementTime,t.AchFileId,t.SourceType,t.SourceId,
         CASE WHEN t.SourceType=1 THEN d.TerminalName ELSE u.UserName END SourceName,
         CASE WHEN t.SourceType=1 THEN a.AddressLine1 ELSE NULL END SourceLocation,
         t.BankAccountId,b.Rta,b.HolderName,t.FundsType,t.BatchHeader,t.StandardEntryClassCode,ROUND(t.Amount,2) Amount,t.Tax,t.ScheduleType,t.Description,
         CASE WHEN t.SourceType=1 THEN i1.Id ELSE i2.Id END IsoId,
         CASE WHEN t.SourceType=1 THEN i1.RegisteredName ELSE i2.RegisteredName END RegisteredName
  FROM dbo.tbl_AchTransaction t
  LEFT JOIN dbo.tbl_BankAccount b ON t.BankAccountId=b.Id 
  LEFT JOIN dbo.tbl_Device d ON t.SourceType=1 AND t.SourceId=d.Id
  LEFT JOIN dbo.tbl_Iso i1 ON d.IsoId=i1.Id
  LEFT JOIN dbo.tbl_Address a ON d.AddressId=a.Id LEFT JOIN dbo.tbl_Region r ON a.RegionId=r.Id LEFT JOIN dbo.tbl_Country c ON r.CountryId=c.Id
  LEFT JOIN dbo.tbl_upm_User u ON t.SourceType=2 AND t.SourceId=u.Id
  LEFT JOIN dbo.tbl_Iso i2 ON u.IsoId=i2.Id
  WHERE SettlementDate>=@StartDate'
  IF @EndDate          IS NOT NULL  SET @SQL=@SQL+' AND t.SettlementDate<DATEADD(dd,1,@EndDate)'
  IF @AchTransactionId IS NOT NULL  SET @SQL=@SQL+' AND t.Id=@AchTransactionId'
  IF @IsoId            IS NOT NULL  SET @SQL=@SQL+' AND ((t.SourceType=1 AND d.IsoId IN (SELECT @IsoId AS Id UNION SELECT Id FROM dbo.tbl_Iso WHERE ParentId=@IsoId)) OR (t.SourceType=2 AND u.IsoId IN (SELECT @IsoId AS Id UNION SELECT Id FROM dbo.tbl_Iso WHERE ParentId=@IsoId)))'
  IF @SourceType       IS NOT NULL  SET @SQL=@SQL+' AND t.SourceType=@SourceType'
  IF @SourceId         IS NOT NULL  SET @SQL=@SQL+' AND t.SourceId=@SourceId'
  IF @BankAccountId    IS NOT NULL  SET @SQL=@SQL+' AND t.BankAccountId=@BankAccountId'
  IF @AchFileId        IS NOT NULL  SET @SQL=@SQL+' AND t.AchFileId=@AchFileId'
  SET @SQL=@SQL+' ORDER BY b.HolderName,b.Rta,SourceName,t.SettlementTime'

  EXEC sp_executesql @SQL,N'@AchTransactionId bigint,@IsoId bigint,@SourceType bigint,@SourceId bigint,@BankAccountId bigint,@StartDate datetime,@EndDate datetime,@AchFileId bigint',@AchTransactionId,@IsoId,@SourceType,@SourceId,@BankAccountId,@StartDate,@EndDate,@AchFileId
END


GO
GRANT EXECUTE ON  [dbo].[usp_ach_GetAchTransactions] TO [WebV4Role]
GO
