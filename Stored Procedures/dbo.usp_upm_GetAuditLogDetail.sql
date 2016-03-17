SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_upm_GetAuditLogDetail]
@UserId        bigint,
@SourceType    bigint,
@SourceName    nvarchar(200),
@UpdatedDate   datetime
WITH EXECUTE AS 'dbo'
AS
BEGIN
  SET NOCOUNT ON

  DECLARE @SQL nvarchar(max)
  SET @SQL='

  SELECT @UserId UserId,b.SourceType,b.SourceId,b.SourceName,a.Type,a.TableName,a.FieldName,a.OldValue,a.NewValue,a.UpdatedDate,a.UpdatedUserId,c.UserName UpdatedUserName
  FROM dbo.tbl_AuditLog a JOIN dbo.tbl_AuditLogSource b ON a.TableName=b.TableName AND a.PrimaryKeyValue=b.PrimaryKeyValue AND a.UpdatedDate=b.UpdatedDate LEFT JOIN dbo.tbl_upm_User c ON a.UpdatedUserId=c.Id
  WHERE b.SourceType=@SourceType AND b.UpdatedDate=@UpdatedDate'
  IF @SourceName IS NOT NULL  SET @SQL=@SQL+' AND b.SourceName=@SourceName'

  EXEC sp_executesql @SQL,N'@UserId bigint,@SourceType bigint,@SourceName nvarchar(200),@UpdatedDate datetime',@UserId,@SourceType,@SourceName,@UpdatedDate
END
GO
