SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE PROCEDURE [dbo].[usp_dev_SetDeviceCurrencyExchangeRate]
@DeviceId      bigint,
@FromCurrency  bigint,
@ToCurrency    bigint,
@ExchangeRate  numeric(9,6),
@UpdatedUserId bigint,
@SmartAcquireId  bigint =0
AS
BEGIN
  SET NOCOUNT ON
  DECLARE @DeviceStatus       bigint
  IF NOT EXISTS(SELECT * FROM dbo.tbl_DeviceCurrencyExchangeRate WHERE DeviceId=@DeviceId AND FromCurrency=@FromCurrency AND ToCurrency=@ToCurrency)
    INSERT INTO dbo.tbl_DeviceCurrencyExchangeRate(DeviceId,FromCurrency,ToCurrency,ExchangeRate,UpdatedDate,UpdatedUserId) VALUES(@DeviceId,@FromCurrency,@ToCurrency,@ExchangeRate,GETUTCDATE(),@UpdatedUserId)
  ELSE
    UPDATE dbo.tbl_DeviceCurrencyExchangeRate SET ExchangeRate=@ExchangeRate,UpdatedDate=GETUTCDATE(),UpdatedUserId=@UpdatedUserId WHERE DeviceId=@DeviceId AND FromCurrency=@FromCurrency AND ToCurrency=@ToCurrency
   
   SELECT @DeviceStatus=DeviceStatus  FROM tbl_Device where Id=@DeviceId
   IF @DeviceStatus=1 
   exec usp_acq_InsertDevicesUpdateCommands @SmartAcquireId,@DeviceId 
  RETURN 0
END
GO
GRANT EXECUTE ON  [dbo].[usp_dev_SetDeviceCurrencyExchangeRate] TO [WebV4Role]
GO
