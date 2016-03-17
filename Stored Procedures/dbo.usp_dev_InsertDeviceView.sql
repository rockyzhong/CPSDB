SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_dev_InsertDeviceView]
@DeviceViewId      bigint OUTPUT, 
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
  
  INSERT INTO dbo.tbl_DeviceView(UserId,ViewName,PageSize,SortColumnId,SortDirection,LoadAtStartUp,GlobalView,UpdatedDate,UpdatedUserId) 
  VALUES(@UserId,@ViewName,@PageSize,@SortColumnId,@SortDirection,@LoadAtStartUp,@GlobalView,@UpdatedDate,@UpdatedUserId)
  SELECT @DeviceViewId=IDENT_CURRENT('tbl_DeviceView')
  
  RETURN 0
END
GO
