SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[usp_dev_GetDeviceCurrencyExchangeRates]
@DeviceId      bigint,
@FromCurrency  bigint = NULL,
@ToCurrency    bigint = NUll
AS
BEGIN
  IF @FromCurrency IS NOT NULL AND @ToCurrency IS NOT NULL
    SELECT d.Id DeviceCurrencyExchangeRateId,DeviceId,FromCurrency,ToCurrency,ExchangeRate,UpdatedDate,UserName FROM dbo.tbl_DeviceCurrencyExchangeRate d JOIN dbo.tbl_upm_User u ON d.UpdatedUserId=u.Id WHERE DeviceId=@DeviceId AND FromCurrency=@FromCurrency AND ToCurrency=@ToCurrency
  ELSE 
    SELECT d.Id DeviceCurrencyExchangeRateId,DeviceId,FromCurrency,ToCurrency,ExchangeRate,UpdatedDate,UserName FROM dbo.tbl_DeviceCurrencyExchangeRate d JOIN dbo.tbl_upm_User u ON d.UpdatedUserId=u.Id WHERE DeviceId=@DeviceId
END
GO
GRANT EXECUTE ON  [dbo].[usp_dev_GetDeviceCurrencyExchangeRates] TO [WebV4Role]
GO
