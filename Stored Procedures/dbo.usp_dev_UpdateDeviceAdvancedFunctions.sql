SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[usp_dev_UpdateDeviceAdvancedFunctions]
@DeviceId                   bigint,
@FunctionFlags              bigint,
@RefusedTransactionTypeList nvarchar(50),
@MaximumDispensedAmount     bigint,
@UpdatedUserId              bigint,
@SmartAcquireId  bigint =0
AS
BEGIN
  SET NOCOUNT ON
  DECLARE  @DeviceStatus bigint
  UPDATE dbo.tbl_Device SET FunctionFlags=@FunctionFlags,RefusedTransactionTypeList=@RefusedTransactionTypeList,MaximumDispensedAmount=@MaximumDispensedAmount,UpdatedUserId=@UpdatedUserId WHERE Id=@DeviceId
  SELECT @DeviceStatus=DeviceStatus  FROM tbl_Device where Id=@DeviceId
  IF @DeviceStatus=1
  exec usp_acq_InsertDevicesUpdateCommands @SmartAcquireId,@DeviceId
  RETURN 0
END
GO
