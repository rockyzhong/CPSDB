SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[usp_dev_UpdateDeviceView]
@DeviceViewId      bigint, 
@UserId            bigint,
@ViewName          nvarchar(200),
@PageSize          bigint,
@SortColumnId      bigint,
@SortDirection     nvarchar(4),
@LoadAtStartUp     bit,
@GlobalView        bit,
@UpdatedDate       datetime,
@UpdatedUserId     bigint
AS
BEGIN
  SET NOCOUNT ON
  
  UPDATE dbo.tbl_DeviceView SET
  UserId=@UserId,ViewName=@ViewName,PageSize=@PageSize,SortColumnId=@SortColumnId,SortDirection=@SortDirection,
  LoadAtStartUp=@LoadAtStartUp,GlobalView=@GlobalView,UpdatedDate=@UpdatedDate,UpdatedUserId=@UpdatedUserId
  WHERE Id=@DeviceViewId
  
  RETURN 0
END
GO
