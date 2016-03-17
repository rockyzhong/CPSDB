SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_upm_GetUserLoginAudit]
@Days         bigint,
@ActivityType bigint,
@UserName     nvarchar(50),
@PageSize     bigint,
@PageNumber   bigint,
@Count        bigint OUTPUT
WITH EXECUTE AS 'dbo'
AS
BEGIN
  SET NOCOUNT ON

  DECLARE @StartRow bigint,@EndRow bigint
  SET @StartRow=(@PageNumber-1)*@PageSize+1
  SET @EndRow  =@PageNumber*@PageSize+1
  
  DECLARE @SQL nvarchar(max)
  SET @SQL='SELECT @Count=Count(*) FROM dbo.tbl_upm_UserLoginAudit WHERE 1>0'
  IF @Days         IS NOT NULL  SET @SQL=@SQL+' AND ActivityTime>=DATEADD(dd,-1*@Days,GETUTCDATE())'
  IF @ActivityType IS NOT NULL  SET @SQL=@SQL+' AND ActivityType=@ActivityType'
  IF @UserName     IS NOT NULL  SET @SQL=@SQL+' AND UserName=@UserName'
  EXEC sp_executesql @SQL,N'@Days bigint,@ActivityType bigint,@UserName nvarchar(50),@Count bigint OUTPUT',@Days,@ActivityType,@UserName,@Count OUTPUT
  
  SET @SQL='
  WITH UserLoginAudit AS (
  SELECT a.Id,a.UserName,a.ActivityTime,a.ActivityType,b.Description ActivityTypeDescription,a.IsSuccessful,a.Description,ROW_NUMBER() OVER(ORDER BY ActivityTime DESC) AS RowNumber 
  FROM dbo.tbl_upm_UserLoginAudit a JOIN dbo.tbl_TypeValue b ON b.TypeId=73 AND b.Value=a.ActivityType WHERE 1>0'
  IF @Days         IS NOT NULL  SET @SQL=@SQL+' AND ActivityTime>=DATEADD(dd,-1*@Days,GETUTCDATE())'
  IF @ActivityType IS NOT NULL  SET @SQL=@SQL+' AND ActivityType=@ActivityType'
  IF @UserName     IS NOT NULL  SET @SQL=@SQL+' AND UserName=@UserName'
  SET @SQL=@SQL+')
  SELECT Id,UserName,ActivityTime,ActivityType,ActivityTypeDescription,IsSuccessful,Description
  FROM UserLoginAudit WHERE RowNumber>=@StartRow AND RowNumber<@EndRow ORDER BY ActivityTime DESC'
  EXEC sp_executesql @SQL,N'@Days bigint,@ActivityType bigint,@UserName nvarchar(50),@StartRow bigint,@EndRow bigint',@Days,@ActivityType,@UserName,@StartRow,@EndRow
END
GO
