SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[usp_dev_SetDeviceCutoverOffset] 
  @DeviceId       bigint,
  @FundsType      bigint,
  @DepositExec    bit,
  @CutoverOffset  bigint,
  @UpdatedUserId  bigint
 -- @SmartAcquireId  bigint =0
AS
BEGIN 
  SET NOCOUNT ON
  
  IF NOT EXISTS(SELECT * FROM dbo.tbl_DeviceCutoverOffset WHERE DeviceId=@DeviceId AND FundsType=@FundsType)
    INSERT INTO dbo.tbl_DeviceCutoverOffset(DeviceId,FundsType,DepositExec,CutoverOffset,UpdatedUserId)
    VALUES(@DeviceId,@FundsType,@DepositExec,@CutoverOffset,@UpdatedUserId)
  ELSE
    UPDATE dbo.tbl_DeviceCutoverOffset SET 
    DepositExec=@DepositExec,CutoverOffset=@CutoverOffset,UpdatedUserId=@UpdatedUserId
    WHERE DeviceId=@DeviceId AND FundsType=@FundsType
   --exec usp_acq_InsertDevicesUpdateCommands @SmartAcquireId,@DeviceId
  RETURN 0
END
GO
GRANT EXECUTE ON  [dbo].[usp_dev_SetDeviceCutoverOffset] TO [WebV4Role]
GO
