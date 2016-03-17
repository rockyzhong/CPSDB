SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_dev_GetDeviceViewByUserId]
@UserId bigint
AS
BEGIN
     -- SET NOCOUNT ON added to prevent extra result sets from
     -- interfering with SELECT statements.
     SET NOCOUNT ON;

  SELECT v.Id DeviceViewId,v.UserId,v.ViewName,v.PageSize,
         v.SortColumnId,c.Description SortColumnDescription,v.SortDirection,
         v.LoadAtStartUp,v.GlobalView,v.UpdatedDate,v.UpdatedUserId
  FROM dbo.tbl_DeviceView   v
  JOIN dbo.tbl_DeviceColumn c ON v.SortColumnId=c.Id
  WHERE @UserId=1 OR v.UserId=@UserId OR v.GlobalView=1
END
GO
