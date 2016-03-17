SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_dev_SetDeviceCutoverOffsetSurcharge] 
  @DeviceId       bigint,
  @DepositExec    bit,
  @CutoverOffset  bigint,
  @UpdatedUserId  bigint
AS
BEGIN 
  EXEC dbo.usp_dev_SetDeviceCutoverOffset @DeviceId,2,@DepositExec,@CutoverOffset,@UpdatedUserId
END
GO
GRANT EXECUTE ON  [dbo].[usp_dev_SetDeviceCutoverOffsetSurcharge] TO [WebV4Role]
GO
