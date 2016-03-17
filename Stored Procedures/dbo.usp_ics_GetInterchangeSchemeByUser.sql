SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[usp_ics_GetInterchangeSchemeByUser]
@UserId     bigint,
@StartsWith nvarchar(20) = Null
WITH EXECUTE AS 'dbo'
AS
BEGIN
  DECLARE @SQL nvarchar(max) 
  SET @SQL='
  DECLARE @Source TABLE(Id bigint)
  INSERT INTO @Source EXEC dbo.usp_upm_GetObjectIds @UserId,5,1

  SELECT i.Id InterchangeSchemeId,i.InterchangeSchemeName,i.Description,COUNT(*) DeviceCount
  FROM dbo.tbl_InterchangeScheme i
  JOIN dbo.tbl_DeviceToInterchangeScheme d ON i.Id=d.InterchangeSchemeId
  WHERE i.Id IN (SELECT Id FROM @Source)'
  IF @StartsWith IS NOT NULL  SET @SQL=@SQL+' AND i.InterchangeSchemeName LIKE @StartsWith + ''%'''
  SET @SQL=@SQL+' GROUP BY i.Id,i.InterchangeSchemeName,i.Description ORDER BY InterchangeSchemeName'
  EXEC SP_EXECUTESQL @SQL,N'@UserId bigint,@StartsWith nvarchar(20)',@UserId,@StartsWith
END
GO
