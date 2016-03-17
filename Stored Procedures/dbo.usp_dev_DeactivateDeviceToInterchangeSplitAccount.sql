SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[usp_dev_DeactivateDeviceToInterchangeSplitAccount] 
  @DeviceId                          bigint,
  @EndDate                           datetime,
  @UpdatedUserId                     bigint
 -- @SmartAcquireId  bigint =0
AS
BEGIN 
  SET NOCOUNT ON

  UPDATE dbo.tbl_DeviceToInterchangeSplitAccount SET EndDate=@EndDate,UpdatedUserId=@UpdatedUserId WHERE DeviceId=@DeviceId AND EndDate=CONVERT(datetime,'39991231',112)
 -- exec usp_acq_InsertDevicesClearCommands @SmartAcquireId,@DeviceId
  RETURN 0
END
GO
GRANT EXECUTE ON  [dbo].[usp_dev_DeactivateDeviceToInterchangeSplitAccount] TO [WebV4Role]
GO
