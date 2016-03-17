SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_dev_InsertDeviceFee] 
@DeviceFeeId        bigint OUTPUT,
@DeviceId           bigint,
@IsoId              bigint,
@FeeType            bigint,
@StartDate          datetime,
@EndDate            datetime,
@AmountFrom         bigint,
@AmountTo           bigint,
@FeeFixed           bigint,
@FeePercentage      bigint,
@FeeAddedPercentage bigint,
@UpdatedUserId      bigint,
@SmartAcquireId  bigint =0
AS
BEGIN 
  SET NOCOUNT ON
  DECLARE @DeviceStatus bigint
  EXEC usp_acq_InsertISOUpdateCommands @SmartAcquireId,@IsoId
  INSERT INTO dbo.tbl_DeviceFee(DeviceId,IsoId,FeeType,StartDate,EndDate,AmountFrom,AmountTo,FeeFixed,FeePercentage,FeeAddedPercentage,UpdatedUserId)
  VALUES(@DeviceId,@IsoId,@FeeType,@StartDate,@EndDate,@AmountFrom,@AmountTo,@FeeFixed,@FeePercentage,@FeeAddedPercentage,@UpdatedUserId)
  SELECT @DeviceFeeId=IDENT_CURRENT('tbl_DeviceFee')
  SELECT @DeviceStatus=DeviceStatus  FROM tbl_Device where Id=@DeviceId
  IF @DeviceStatus=1
  exec usp_acq_InsertDevicesUpdateCommands @SmartAcquireId,@DeviceId
  RETURN 0
END
GO
GRANT EXECUTE ON  [dbo].[usp_dev_InsertDeviceFee] TO [WebV4Role]
GO
