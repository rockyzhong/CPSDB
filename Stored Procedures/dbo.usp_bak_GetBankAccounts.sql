SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[usp_bak_GetBankAccounts]
@UserId                  bigint,
@IsoId                   bigint       = NULL,
@Rta                     nvarchar(50) = NULL,
@HolderName              nvarchar(50) = NULL,
@BankAccountType         bigint       = NULL,
@BankAccountCategory     bigint       = NULL,
@Currency                bigint       = NULL,
@SettlementScheduleType  bigint       = NULL, 
@SurchargeScheduleType   bigint       = NULL, 
@InterchangeScheduleType bigint       = NULL,
@ConsolidationType       bigint       = NULL,
@BankCountryId           bigint       = NULL,
@BankAccountStatus       bigint       = NULL,
@Registered              bit          = NULL,
@Undeleted               bit          = NULL,
@OrderColumn             nvarchar(200),
@OrderDirection          nvarchar(200),
@PageSize                bigint,
@PageNumber              bigint,
@Count                   bigint OUTPUT
WITH EXECUTE AS 'dbo'
AS
BEGIN
  SET NOCOUNT ON

  SET @Rta=REPLACE(@Rta,'*','%')
  SET @HolderName=REPLACE(@HolderName,'*','%')

  DECLARE @StartRow bigint,@EndRow bigint
  SET @StartRow=(@PageNumber-1)*@PageSize+1
  SET @EndRow  =@PageNumber*@PageSize+1

  DECLARE @Source SourceTABLE
  INSERT INTO @Source EXEC dbo.usp_upm_GetObjectIds @UserId,3,1

  DECLARE @SQL nvarchar(max),@SQL0 nvarchar(max)
  SET @SQL0='
  FROM dbo.tbl_BankAccount b JOIN @Source o ON b.Id=o.Id
  LEFT JOIN dbo.tbl_Iso i ON b.IsoId=i.Id
  LEFT JOIN dbo.tbl_BankAccountSchedule s1 ON b.Id=s1.BankAccountId AND s1.FundsType=1
  LEFT JOIN dbo.tbl_BankAccountSchedule s2 ON b.Id=s2.BankAccountId AND s2.FundsType=2
  LEFT JOIN dbo.tbl_BankAccountSchedule s3 ON b.Id=s3.BankAccountId AND s3.FundsType=3
  LEFT JOIN dbo.tbl_Address a ON b.BankAddressId=a.Id LEFT JOIN dbo.tbl_Region r ON a.RegionId=r.Id
  WHERE 1>0'
  IF @IsoId                   IS NOT NULL  SET @SQL0=@SQL0+' AND b.IsoId=@IsoId'
  IF @Rta                     IS NOT NULL  SET @SQL0=@SQL0+' AND b.Rta LIKE @Rta'
  IF @HolderName              IS NOT NULL  SET @SQL0=@SQL0+' AND b.HolderName LIKE @HolderName'
  IF @BankAccountType         IS NOT NULL  SET @SQL0=@SQL0+' AND b.BankAccountType=@BankAccountType'
  IF @BankAccountCategory     IS NOT NULL  SET @SQL0=@SQL0+' AND b.BankAccountCategory=@BankAccountCategory'
  IF @Currency                IS NOT NULL  SET @SQL0=@SQL0+' AND b.Currency=@Currency'
  IF @SettlementScheduleType  IS NOT NULL  SET @SQL0=@SQL0+' AND s1.ScheduleType=@SettlementScheduleType'  
  IF @SurchargeScheduleType   IS NOT NULL  SET @SQL0=@SQL0+' AND s2.ScheduleType=@SurchargeScheduleType'  
  IF @InterchangeScheduleType IS NOT NULL  SET @SQL0=@SQL0+' AND s3.ScheduleType=@InterchangeScheduleType'  
  IF @ConsolidationType       IS NOT NULL  SET @SQL0=@SQL0+' AND b.ConsolidationType=@ConsolidationType'
  IF @BankCountryId           IS NOT NULL  SET @SQL0=@SQL0+' AND r.CountryId=@BankCountryId'
  IF @BankAccountStatus       IS NOT NULL  SET @SQL0=@SQL0+' AND b.BankAccountStatus=@BankAccountStatus'
  IF @Registered=1                         SET @SQL0=@SQL0+' AND b.BankAccountCategory IN (2,3)'
  IF @Undeleted=1                          SET @SQL0=@SQL0+' AND b.BankAccountStatus<>4'
    
  SET @SQL='
  SELECT @Count=Count(*) '+@SQL0
  EXEC sp_executesql @SQL,N'@Source SourceTABLE READONLY,@IsoId bigint,@Rta nvarchar(50),@HolderName nvarchar(50),@BankAccountType bigint,@BankAccountCategory bigint,@Currency bigint,@SettlementScheduleType bigint,@SurchargeScheduleType bigint,@InterchangeScheduleType bigint,@ConsolidationType bigint,@BankCountryId bigint,@BankAccountStatus bigint,@Count bigint OUTPUT',@Source,@IsoId,@Rta,@HolderName,@BankAccountType,@BankAccountCategory,@Currency,@SettlementScheduleType,@SurchargeScheduleType,@InterchangeScheduleType,@ConsolidationType,@BankCountryId,@BankAccountStatus,@Count OUTPUT

  SET @SQL='
  WITH BankAccounts AS (
  SELECT b.Id BankAccountId,b.BankAccountType,b.BankAccountCategory,b.HolderName,b.Rta,b.Currency,b.BankName,b.ConsolidationType,r.CountryId BankCountryId,b.BankAccountStatus,b.IsoId,i.RegisteredName,
  s1.ScheduleType SettlementScheduleType,s2.ScheduleType SurchargeScheduleType,s3.ScheduleType InterchangeScheduleType,
  ROW_NUMBER() OVER(ORDER BY '+@OrderColumn+' '+@OrderDirection+N') AS RowNumber '+@SQL0+')

  SELECT BankAccountId,BankAccountType,BankAccountCategory,HolderName,Rta,Currency,BankName,ConsolidationType,BankCountryId,BankAccountStatus,IsoId,RegisteredName,SettlementScheduleType,SurchargeScheduleType,InterchangeScheduleType
  FROM BankAccounts WHERE RowNumber>=@StartRow AND RowNumber<@EndRow ORDER BY '+@OrderColumn+' '+@OrderDirection
  
  EXEC sp_executesql @SQL,N'@Source SourceTABLE READONLY,@IsoId bigint,@Rta nvarchar(50),@HolderName nvarchar(50),@BankAccountType bigint,@BankAccountCategory bigint,@Currency bigint,@SettlementScheduleType bigint,@SurchargeScheduleType bigint,@InterchangeScheduleType bigint,@ConsolidationType bigint,@BankCountryId bigint,@BankAccountStatus bigint,@StartRow bigint,@EndRow bigint',@Source,@IsoId,@Rta,@HolderName,@BankAccountType,@BankAccountCategory,@Currency,@SettlementScheduleType,@SurchargeScheduleType,@InterchangeScheduleType,@ConsolidationType,@BankCountryId,@BankAccountStatus,@StartRow,@EndRow

  RETURN 0
END
GO
GRANT EXECUTE ON  [dbo].[usp_bak_GetBankAccounts] TO [WebV4Role]
GO
