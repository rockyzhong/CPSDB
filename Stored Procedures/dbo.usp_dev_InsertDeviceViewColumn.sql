SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/***/
CREATE PROCEDURE [dbo].[usp_dev_InsertDeviceViewColumn]
@ViewId            bigint,
@ColumnId          bigint,
@Rank              bigint,
@UpdatedUserId     bigint
AS
BEGIN
  SET NOCOUNT ON
  
  INSERT INTO dbo.tbl_DeviceViewColumn(ViewId,ColumnId,Rank,UpdatedUserId) 
  VALUES(@ViewId,@ColumnId,@Rank,@UpdatedUserId)
  
  RETURN 0
END
GO
