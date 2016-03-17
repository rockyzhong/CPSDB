SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_dev_GetDeviceViewColumn]
@DeviceViewId      bigint
AS
BEGIN
  SELECT v.Id ViewId,c.Id ColumnId,c.ColumnName,c.ColumnCaption,c.ColumnHeader,c.Description,
         c.SampleData,c.Required,c.Sortable,c.Rank,c.ColumnStatus,c.PermissionId
  FROM dbo.tbl_DeviceView       v
  JOIN dbo.tbl_DeviceViewColumn o ON v.Id=o.ViewId
  JOIN dbo.tbl_DeviceColumn     c ON o.ColumnId=c.Id
  WHERE v.Id=@DeviceViewId
  ORDER BY o.Rank
END
GO
