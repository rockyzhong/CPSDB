SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_dev_UpdateDeviceFee] 
@DeviceFeeId        bigint,
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
  Declare @DeviceId bigint,@IsoId bigint,@DeviceStatus bigint
  select @DeviceId=DeviceId from dbo.tbl_DeviceFee where Id=@DeviceFeeId
  select @IsoId=IsoId from dbo.tbl_DeviceFee where Id=@DeviceFeeId
  EXEC usp_acq_InsertISOUpdateCommands @SmartAcquireId,@IsoId
  
  
  UPDATE dbo.tbl_DeviceFee SET
  FeeType=@FeeType,StartDate=@StartDate,EndDate=@EndDate,AmountFrom=@AmountFrom,AmountTo=@AmountTo,
  FeeFixed=@FeeFixed,FeePercentage=@FeePercentage,FeeAddedPercentage=@FeeAddedPercentage,UpdatedUserId=@UpdatedUserId
  WHERE Id=@DeviceFeeId
  
  SELECT @DeviceStatus=DeviceStatus  FROM tbl_Device where Id=@DeviceId
  IF @DeviceStatus=1
  EXEC usp_acq_InsertDevicesUpdateCommands @SmartAcquireId,@DeviceId
  RETURN 0
END
GO
GRANT EXECUTE ON  [dbo].[usp_dev_UpdateDeviceFee] TO [WebV4Role]
GO
