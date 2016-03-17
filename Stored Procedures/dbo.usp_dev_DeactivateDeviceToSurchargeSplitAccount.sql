SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[usp_dev_DeactivateDeviceToSurchargeSplitAccount] 
  @DeviceId                        bigint,
  @EndDate                         datetime,
  @UpdatedUserId                   bigint
  --@SmartAcquireId  bigint =0
AS
BEGIN 
  SET NOCOUNT ON

  UPDATE dbo.tbl_DeviceToSurchargeSplitAccount SET EndDate=@EndDate,UpdatedUserId=@UpdatedUserId WHERE DeviceId=@DeviceId AND EndDate=CONVERT(datetime,'39991231',112)
--  exec usp_acq_InsertDevicesClearCommands @SmartAcquireId,@DeviceId
  RETURN 0
END
GO
GRANT EXECUTE ON  [dbo].[usp_dev_DeactivateDeviceToSurchargeSplitAccount] TO [WebV4Role]
GO
