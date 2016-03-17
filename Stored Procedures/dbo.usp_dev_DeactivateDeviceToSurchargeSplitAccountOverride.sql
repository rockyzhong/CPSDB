SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_dev_DeactivateDeviceToSurchargeSplitAccountOverride]
@DeviceId      bigint,
@Date          datetime,
@UpdatedUserId bigint
AS
BEGIN
  SET NOCOUNT ON

  UPDATE dbo.tbl_DeviceToSurchargeSplitAccountOverride SET EndDate=@Date,UpdatedUserId=@UpdatedUserId WHERE DeviceId=@DeviceId AND EndDate=CONVERT(datetime,'39991231',112)
  
  RETURN 0
END
GO
GRANT EXECUTE ON  [dbo].[usp_dev_DeactivateDeviceToSurchargeSplitAccountOverride] TO [WebV4Role]
GO
