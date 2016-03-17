SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/**/
/**/
/**/
CREATE PROCEDURE [dbo].[usp_dev_GetDeviceCurrency]
@DeviceId      bigint
AS
BEGIN
  SELECT FromCurrency,ToCurrency FROM dbo.tbl_DeviceCurrencyExchangeRate WHERE DeviceId=@DeviceId
END
GO
GRANT EXECUTE ON  [dbo].[usp_dev_GetDeviceCurrency] TO [WebV4Role]
GO
