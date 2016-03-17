SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[usp_dev_DeleteDeviceCurrencyExchangeRate]
@DeviceCurrencyExchangeRateId bigint,
@UpdatedUserId                bigint,
@SmartAcquireId  bigint =0
AS
BEGIN
  SET NOCOUNT ON
  DECLARE @DeviceId bigint,@DeviceStatus bigint
 
  SELECT @DeviceId=DeviceId from  dbo.tbl_DeviceCurrencyExchangeRate where Id=@DeviceCurrencyExchangeRateId
  UPDATE dbo.tbl_DeviceCurrencyExchangeRate SET UpdatedUserId=@UpdatedUserId WHERE Id=@DeviceCurrencyExchangeRateId
  DELETE FROM dbo.tbl_DeviceCurrencyExchangeRate WHERE Id=@DeviceCurrencyExchangeRateId
  SELECT @DeviceStatus=DeviceStatus  FROM tbl_Device where Id=@DeviceId
  IF @DeviceStatus=1
  exec usp_acq_InsertDevicesUpdateCommands @SmartAcquireId,@DeviceId    
  RETURN 0
END
GO
GRANT EXECUTE ON  [dbo].[usp_dev_DeleteDeviceCurrencyExchangeRate] TO [WebV4Role]
GO
