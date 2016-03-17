SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_ach_GetAchSchedules]
@AchScheduleId            bigint       =NULL,
@ScheduleType             bigint       =NULL,
@EffectiveDate            datetime     =NULL,
@SourceType               bigint       =NULL,
@SourceId                 bigint       =NULL,
@SourceBankAccountId      bigint       =NULL,
@DestinationBankAccountId bigint       =NULL,
@Description              nvarchar(200)=NULL,
@AchScheduleStatus        bigint       =NULL,
@UserID                   bigint       =NULL
WITH EXECUTE AS 'dbo'
AS
BEGIN
  SET NOCOUNT ON

  DECLARE @SQL nvarchar(max)
  SET @SQL='
  SELECT a.Id AchScheduleId,a.AchFileId,a.SettlementDate,a.ScheduleType,a.ScheduleDay,a.StartDate,CASE WHEN a.EndDate=CONVERT(datetime,''3999-12-31 23:59:59'',121) THEN NULL ELSE a.EndDate END EndDate,a.SourceType,a.SourceId,CASE WHEN a.SourceType=1 THEN d.TerminalName ELSE u.UserName END SourceName,a.FundsType,a.SourceBankAccountId,bs.HolderName SourceBankAccountHolderName,bs.Rta SourceBankAccountRta,a.DestinationBankAccountId,bd.HolderName DestinationBankAccountHolderName,bd.Rta DestinationBankAccountRta,a.Amount,a.TaxList,a.StandardEntryClassCode,a.BatchHeader,a.Description,a.AchScheduleStatus,a.CreatedDate,a.CreatedUserId,a.UpdatedDate,a.UpdatedUserId 
  FROM dbo.tbl_AchSchedule a
  LEFT JOIN dbo.tbl_Device d ON a.SourceType=1 AND a.SourceId=d.Id
  LEFT JOIN dbo.tbl_upm_User u ON a.SourceType=2 AND a.SourceId=u.Id
  LEFT JOIN dbo.tbl_BankAccount bs ON a.SourceBankAccountId=bs.Id
  LEFT JOIN dbo.tbl_BankAccount bd ON a.DestinationBankAccountId=bd.Id
  WHERE 1>0'
  IF @AchScheduleId            IS NOT NULL  SET @SQL=@SQL+' AND a.Id=@AchScheduleId'
  IF @ScheduleType             IS NOT NULL  SET @SQL=@SQL+' AND a.ScheduleType=@ScheduleType'
  IF @EffectiveDate            IS NOT NULL  SET @SQL=@SQL+' AND a.StartDate<=@EffectiveDate AND a.EndDate>=@EffectiveDate'
  IF @SourceType               IS NOT NULL  SET @SQL=@SQL+' AND a.SourceType=@SourceType'
  IF @SourceId                 IS NOT NULL  SET @SQL=@SQL+' AND a.SourceId=@SourceId'
  IF @SourceBankAccountId      IS NOT NULL  SET @SQL=@SQL+' AND a.SourceBankAccountId=@SourceBankAccountId'
  IF @DestinationBankAccountId IS NOT NULL  SET @SQL=@SQL+' AND a.DestinationBankAccountId=@DestinationBankAccountId'
  IF @Description              IS NOT NULL  SET @SQL=@SQL+' AND a.Description LIKE N''%''+@Description+N''%'''
  IF @AchScheduleStatus        IS NOT NULL  SET @SQL=@SQL+' AND a.AchScheduleStatus=@AchScheduleStatus'
  IF @UserID                   IS NOT NULL
  BEGIN
    SET @SQL='
    DECLARE @DeviceIds  TABLE (Id bigint)
    DECLARE @UserIds    TABLE (Id bigint)    
    DECLARE @AccountIds TABLE (Id bigint)
    
    INSERT INTO @DeviceIds  EXEC dbo.usp_upm_GetObjectIds @UserId,1,1
    INSERT INTO @UserIds    EXEC dbo.usp_upm_GetObjectIds @UserId,2,1
    INSERT INTO @AccountIds EXEC dbo.usp_upm_GetObjectIds @UserId,3,1    
    '+@SQL

    SET @SQL=@SQL+' AND ((a.SourceType=1 AND a.SourceId IN (SELECT Id FROM @DeviceIds)) OR (a.SourceType=2 AND a.SourceId IN (SELECT Id FROM @UserIds))) AND a.SourceBankAccountId IN (SELECT Id FROM @AccountIds) AND a.DestinationBankAccountId IN (SELECT Id FROM @AccountIds)'
  END
  
  EXEC sp_executesql @SQL,N'@AchScheduleId bigint,@ScheduleType bigint,@EffectiveDate datetime,@SourceType bigint,@SourceId bigint,@SourceBankAccountId bigint,@DestinationBankAccountId bigint,@Description nvarchar(200),@AchScheduleStatus bigint,@UserId bigint',@AchScheduleId,@ScheduleType,@EffectiveDate,@SourceType,@SourceId,@SourceBankAccountId,@DestinationBankAccountId,@Description,@AchScheduleStatus,@UserId
    
  RETURN 0
END
GO
GRANT EXECUTE ON  [dbo].[usp_ach_GetAchSchedules] TO [WebV4Role]
GO
