SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_dev_DeactivateDeviceToSettlementAccountOverride]
@DeviceId      bigint,
@Date          datetime,
@UpdatedUserId bigint
AS
BEGIN
  SET NOCOUNT ON

  UPDATE dbo.tbl_DeviceToSettlementAccountOverride SET EndDate=@Date,UpdatedUserId=@UpdatedUserId WHERE DeviceId=@DeviceId AND EndDate=CONVERT(datetime,'39991231',112)
  
  RETURN 0
END
GO
GRANT EXECUTE ON  [dbo].[usp_dev_DeactivateDeviceToSettlementAccountOverride] TO [WebV4Role]
GO
