SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_upm_GetAuditLog]
@UserId        bigint,
@SourceType    bigint,
@SourceName    nvarchar(200),
@BeginDate     datetime,
@EndDate       datetime,
@OldValue      nvarchar(max),
@NewValue      nvarchar(max),
@UpdatedUserId bigint
WITH EXECUTE AS 'dbo'
AS
BEGIN
  SET NOCOUNT ON

  DECLARE @SQL nvarchar(max)
  SET @SQL='
  DECLARE @Role TABLE(Id bigint,RoleName nvarchar(200),Description nvarchar(max))
  DECLARE @Source SourceTABLE

  IF @SourceType=8
  BEGIN
    INSERT INTO @Role EXEC dbo.usp_upm_GetCreatedRolesByUser @UserId
    INSERT INTO @Source SELECT Id FROM @Role
  END  
  ELSE
    INSERT INTO @Source EXEC dbo.usp_upm_GetObjectIds @UserId,@SourceType,1

  SELECT b.SourceType,b.SourceId,b.SourceName,b.IsoName,b.UpdatedDate,COUNT(a.Id) UpdatedCount
  FROM dbo.tbl_AuditLog a JOIN dbo.tbl_AuditLogSource b ON a.TableName=b.TableName AND a.PrimaryKeyValue=b.PrimaryKeyValue AND a.UpdatedDate=b.UpdatedDate
  WHERE b.SourceType=@SourceType AND b.SourceId IN (SELECT Id FROM @Source) AND b.UpdatedDate>=@BeginDate AND b.UpdatedDate<@EndDate'
  IF @SourceName     IS NOT NULL  SET @SQL=@SQL+' AND b.SourceName=@SourceName'
  IF @OldValue       IS NOT NULL  SET @SQL=@SQL+' AND a.OldValue=@OldValue'
  IF @NewValue       IS NOT NULL  SET @SQL=@SQL+' AND a.NewValue=@NewValue'
  IF @UpdatedUserId  IS NOT NULL  SET @SQL=@SQL+' AND a.UpdatedUserId=@UpdatedUserId'
  SET @SQL=@SQL+' GROUP BY b.SourceType,b.SourceId,b.SourceName,b.IsoName,b.UpdatedDate'

  EXEC sp_executesql @SQL,N'@UserId bigint,@SourceType bigint,@SourceName nvarchar(200),@BeginDate datetime,@EndDate datetime,@OldValue nvarchar(max),@NewValue nvarchar(max),@UpdatedUserId bigint',@UserId,@SourceType,@SourceName,@BeginDate,@EndDate,@OldValue,@NewValue,@UpdatedUserId
END

GO
