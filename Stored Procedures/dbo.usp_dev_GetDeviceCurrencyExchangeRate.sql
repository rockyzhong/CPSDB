SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[usp_dev_GetDeviceCurrencyExchangeRate]
@DeviceId     bigint,
@FromCurrency bigint,
@ToCurrency   bigint,
@ExchangeRate numeric(9,6) OUTPUT
AS
BEGIN
  SELECT @ExchangeRate=ExchangeRate FROM dbo.tbl_DeviceCurrencyExchangeRate WHERE DeviceId=@DeviceId AND FromCurrency=@FromCurrency AND ToCurrency=@ToCurrency
END
GO
GRANT EXECUTE ON  [dbo].[usp_dev_GetDeviceCurrencyExchangeRate] TO [WebV4Role]
GO
