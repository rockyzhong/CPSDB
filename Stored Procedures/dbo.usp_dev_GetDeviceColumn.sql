SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_dev_GetDeviceColumn]
@DeviceColumnID bigint = NULL,
@UserId         bigint
WITH EXECUTE AS 'dbo'
AS
BEGIN
  SET NOCOUNT ON
  
  DECLARE @SQL nvarchar(max)
  SET @SQL='
  DECLARE @PermissionGranted TABLE (Id bigint)
  INSERT INTO @PermissionGranted EXEC dbo.usp_upm_GetPermissionIds @UserId,1

  DECLARE @PermissionDenied TABLE (Id bigint)
  INSERT INTO @PermissionDenied  EXEC dbo.usp_upm_GetPermissionIds @UserId,0
  
  SELECT 
    Id DeviceColumnId,
    ColumnName,
    ISNULL(ColumnCaption,ColumnName) AS ColumnCaption,
    ISNULL(ColumnHeader ,ColumnName) as ColumnHeader,
    Description,
    SampleData,
    Required,
    Sortable,
    Rank,
    ColumnStatus,
    PermissionId
  FROM dbo.tbl_DeviceColumn
  WHERE (PermissionId IS NULL OR (PermissionId IN (SELECT Id FROM @PermissionGranted) AND PermissionId NOT IN (SELECT Id FROM @PermissionDenied)))'
  IF @DeviceColumnID IS NOT NULL  SET @SQL=@SQL+' AND Id=@DeviceColumnID'
  EXEC sp_executesql @SQL,N'@DeviceColumnID bigint,@UserId bigint',@DeviceColumnID,@UserId
END
GO
