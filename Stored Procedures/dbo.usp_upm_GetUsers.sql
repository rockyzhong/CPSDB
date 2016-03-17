SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[usp_upm_GetUsers]
@UserId         bigint,
@IsoId          bigint       = NULL,
@UserName       nvarchar(50) = NULL,
@FirstName      nvarchar(50) = NULL,
@LastName       nvarchar(50) = NULL,
@ParentId       bigint       = NULL,
@UserStatus     bigint       = NULL,
@Undeleted      bit          = NULL,
@BadgeName      nvarchar(30) = NULL,
@OrderColumn    nvarchar(200),
@OrderDirection nvarchar(200),
@PageSize       bigint,
@PageNumber     bigint,
@Count          bigint OUTPUT
WITH EXECUTE AS 'dbo'
AS
BEGIN
  SET NOCOUNT ON

  SET @UserName =REPLACE(@UserName,'*','%')
  SET @FirstName=REPLACE(@FirstName,'*','%')
  SET @LastName =REPLACE(@LastName,'*','%')

  DECLARE @StartRow bigint,@EndRow bigint
  SET @StartRow=(@PageNumber-1)*@PageSize+1
  SET @EndRow  =@PageNumber*@PageSize+1

  DECLARE @Source SourceTABLE
  INSERT INTO @Source EXEC dbo.usp_upm_GetObjectIds @UserId,2,1

  DECLARE @SQL nvarchar(max),@SQL0 nvarchar(max)
  SET @SQL0='
  FROM dbo.tbl_upm_User u JOIN @Source s ON u.Id=s.Id
  LEFT JOIN dbo.tbl_upm_User p ON u.ParentId=p.Id 
  LEFT JOIN dbo.tbl_Iso i ON u.IsoId=i.Id 
  WHERE 1>0'
  IF @IsoId        IS NOT NULL  SET @SQL0=@SQL0+' AND u.IsoId=@IsoId'
  IF @UserName     IS NOT NULL  SET @SQL0=@SQL0+' AND u.UserName LIKE @UserName'
  IF @FirstName    IS NOT NULL  SET @SQL0=@SQL0+' AND u.FirstName LIKE @FirstName'
  IF @LastName     IS NOT NULL  SET @SQL0=@SQL0+' AND u.LastName LIKE @LastName'
  IF @ParentId     IS NOT NULL  SET @SQL0=@SQL0+' AND u.ParentId=@ParentId'
  IF @UserStatus   IS NOT NULL  SET @SQL0=@SQL0+' AND u.UserStatus=@UserStatus'
  IF @BadgeName    IS NOT NULL  SET @SQL0=@SQL0+' AND u.BadgeName=@BadgeName'
  IF @Undeleted=1               SET @SQL0=@SQL0+' AND u.UserStatus<>4'
  
  SET @SQL='
  SELECT @Count=Count(*) '+@SQL0
  EXEC sp_executesql @SQL,N'@Source SourceTABLE READONLY,@IsoId bigint,@UserName nvarchar(50),@FirstName nvarchar(50),@LastName nvarchar(50),@ParentId bigint,@UserStatus bigint,@BadgeName nvarchar(30),@Count bigint OUTPUT',@Source,@IsoId,@UserName,@FirstName,@LastName,@ParentId,@UserStatus,@BadgeName,@Count OUTPUT

  SET @SQL='
  WITH Users AS (
  SELECT u.Id UserId,u.UserName,u.FirstName,u.LastName,u.BadgeName,p.Id ParentId,p.UserName ParentUserName,u.UserStatus,i.id IsoId,i.RegisteredName,
  ROW_NUMBER() OVER(ORDER BY u.'+@OrderColumn+' '+@OrderDirection+N') AS RowNumber '+@SQL0+')

  SELECT UserId,UserName,FirstName,LastName,ParentId,ParentUserName,UserStatus,IsoId,RegisteredName,BadgeName
  FROM Users WHERE RowNumber>=@StartRow AND RowNumber<@EndRow ORDER BY '+@OrderColumn+' '+@OrderDirection
  
  EXEC sp_executesql @SQL,N'@Source SourceTABLE READONLY,@IsoId bigint,@UserName nvarchar(50),@FirstName nvarchar(50),@LastName nvarchar(50),@ParentId bigint,@UserStatus bigint,@BadgeName nvarchar(30),@StartRow bigint,@EndRow bigint',@Source,@IsoId,@UserName,@FirstName,@LastName,@ParentId,@UserStatus,@BadgeName,@StartRow,@EndRow

  RETURN 0
END
GO
GRANT EXECUTE ON  [dbo].[usp_upm_GetUsers] TO [WebV4Role]
GO
