SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[usp_net_GetNetworkCurrencyExchangeRates]
@NetworkId     bigint,
@FromCurrency  bigint = NULL,
@ToCurrency    bigint = NUll
AS
BEGIN
  IF @FromCurrency IS NOT NULL AND @ToCurrency IS NOT NULL
    SELECT d.Id NetworkCurrencyExchangeRateId,NetworkId,FromCurrency,ToCurrency,ExchangeRate,UpdatedDate,UserName FROM dbo.tbl_NetworkCurrencyExchangeRate d JOIN dbo.tbl_upm_User u ON d.UpdatedUserId=u.Id WHERE NetworkId=@NetworkId AND FromCurrency=@FromCurrency AND ToCurrency=@ToCurrency
  ELSE 
    SELECT d.Id NetworkCurrencyExchangeRateId,NetworkId,FromCurrency,ToCurrency,ExchangeRate,UpdatedDate,UserName FROM dbo.tbl_NetworkCurrencyExchangeRate d JOIN dbo.tbl_upm_User u ON d.UpdatedUserId=u.Id WHERE NetworkId=@NetworkId
END
GO
GRANT EXECUTE ON  [dbo].[usp_net_GetNetworkCurrencyExchangeRates] TO [WebV4Role]
GO
