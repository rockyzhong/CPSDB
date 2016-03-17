SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_dev_GetDeviceView]
@DeviceViewId      bigint
AS
BEGIN
  SELECT v.Id DeviceViewId,v.UserId,v.ViewName,v.PageSize,
         v.SortColumnId,c.Description SortColumnDescription,v.SortDirection,
         v.LoadAtStartUp,v.GlobalView,v.UpdatedDate,v.UpdatedUserId
  FROM dbo.tbl_DeviceView   v
  JOIN dbo.tbl_DeviceColumn c ON v.SortColumnId=c.Id
  WHERE v.Id=@DeviceViewId
END
GO
