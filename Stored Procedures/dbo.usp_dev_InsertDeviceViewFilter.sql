SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/***/
CREATE PROCEDURE [dbo].[usp_dev_InsertDeviceViewFilter]
@ViewId            bigint,
@FilterId          bigint,
@Value             nvarchar(200),
@MatchChoice       nvarchar(2),
@UpdatedUserId     bigint
AS
BEGIN
  SET NOCOUNT ON
  
  INSERT INTO dbo.tbl_DeviceViewFilter(ViewId,FilterId,Value,MatchChoice,UpdatedUserId) 
  VALUES(@ViewId,@FilterId,@Value,@MatchChoice,@UpdatedUserId)
  
  RETURN 0
END
GO
