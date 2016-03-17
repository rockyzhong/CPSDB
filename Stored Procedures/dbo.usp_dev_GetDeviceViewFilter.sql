SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_dev_GetDeviceViewFilter]
@DeviceViewId      bigint
AS
BEGIN
  SELECT v.Id ViewId,f.Id FilterId,f.ColumnId,f.FilterName,f.Description,f.FilterQuery,f.ParameterName,
         f.DataField,f.DataFormat,f.Regex,f.Rank,f.FilterType,f.FilterStatus,f.PermissionId,o.Value,o.MatchChoice
  FROM dbo.tbl_DeviceView       v
  JOIN dbo.tbl_DeviceViewFilter o ON v.Id=o.ViewId
  JOIN dbo.tbl_DeviceFilter     f ON o.FilterId=f.Id
  WHERE v.Id=@DeviceViewId
END
GO
