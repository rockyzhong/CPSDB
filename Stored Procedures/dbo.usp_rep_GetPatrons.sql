SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE PROCEDURE [dbo].[usp_rep_GetPatrons]
	 @FirstName NVARCHAR(25) =null
	, @LastName NVARCHAR(25) =null
	, @IdNumber NVARCHAR(20) =null
	, @IdState  NVARCHAR(3)  =null
WITH EXECUTE AS 'dbo'
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @SQL nvarchar(max)
	SET @IdState=ISNULL(@IdState,'')
	SET @SQL = N'
	SELECT TOP 100 [ID]
      ,[FirstName],[LASTNAME],[IdNumber],[IdState],[IdType]
    FROM [dbo].[tbl_Customer]
    WHERE 1=1'
	
	IF @FirstName IS NOT NULL 
    SET @SQL = @SQL + N' AND [FirstName] like @FirstName + ''%'''
	IF @LastName IS NOT NULL 
	SET @SQL = @SQL + N' AND [LastName] like @LastName + ''%'''
	IF @IdNumber IS NOT NULL 
	SET @SQL = @SQL + N' AND [IdNumber] like @IdNumber + ''%'''
	IF @IdState NOT IN ('','ALL')
	SET @SQL = @SQL + N' AND [IdState] = @IdState'

	SET @SQL=@SQL +  N' ORDER BY [FirstName],[LastName]'
	
	EXEC sp_executesql @SQL, N' @FirstName NVARCHAR(25), @LastName NVARCHAR(25), @IdNumber NVARCHAR(20), @IdState  NVARCHAR(2)', @FirstName, @LastName, @IdNumber, @IdState
END
GO
