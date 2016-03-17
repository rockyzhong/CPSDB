SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_dev_GetDeviceFilter]
@DeviceFilterID bigint = NULL,
@UserId         bigint
WITH EXECUTE AS 'dbo'
AS
BEGIN
  SET NOCOUNT ON

  DECLARE @SQL nvarchar(max)
  --IF @UserId=1 
  --   IF @DeviceFilterID is not null
  --SELECT 
  --  Id DeviceFilterId,
  --  ColumnId,
  --  FilterName,
  --  Description,
  --  FilterQuery,
  --  ParameterName,
  --  DataField,
  --  DataFormat,
  --  Regex,
  --  Rank,
  --  ltrim(rtrim(FilterType)) as FilterType,
  --  FilterStatus,
  --  PermissionId
  --FROM dbo.tbl_DeviceFilter where id=@DeviceFilterID
  -- ELSE 
  -- SELECT 
  --  Id DeviceFilterId,
  --  ColumnId,
  --  FilterName,
  --  Description,
  --  FilterQuery,
  --  ParameterName,
  --  DataField,
  --  DataFormat,
  --  Regex,
  --  Rank,
  --  ltrim(rtrim(FilterType)) as FilterType,
  --  FilterStatus,
  --  PermissionId
  --FROM dbo.tbl_DeviceFilter
  --ELSE
  --BEGIN
  SET @SQL='
  DECLARE @PermissionGranted TABLE (Id bigint)
  INSERT INTO @PermissionGranted EXEC dbo.usp_upm_GetPermissionIds @UserId,1

  DECLARE @PermissionDenied TABLE (Id bigint)
  INSERT INTO @PermissionDenied  EXEC dbo.usp_upm_GetPermissionIds @UserId,0
  
  SELECT 
    Id DeviceFilterId,
    ColumnId,
    FilterName,
    Description,
    FilterQuery,
    ParameterName,
    DataField,
    DataFormat,
    Regex,
    Rank,
    ltrim(rtrim(FilterType)) as FilterType,
    FilterStatus,
    PermissionId
  FROM dbo.tbl_DeviceFilter
  WHERE (PermissionId IS NULL OR (PermissionId IN (SELECT Id FROM @PermissionGranted) AND PermissionId NOT IN (SELECT Id FROM @PermissionDenied)))'
  IF @DeviceFilterID IS NOT NULL  SET @SQL=@SQL+' AND Id=@DeviceFilterID'
  EXEC sp_executesql @SQL,N'@DeviceFilterID bigint,@UserId bigint',@DeviceFilterID,@UserId
END
--END
GO
