SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[usp_net_GetNetworkCurrencyExchangeRate]
@NetworkId    bigint,
@FromCurrency bigint,
@ToCurrency   bigint,
@ExchangeRate numeric(9,6) OUTPUT
AS
BEGIN
  SELECT @ExchangeRate=ExchangeRate FROM dbo.tbl_NetworkCurrencyExchangeRate WHERE NetworkId=@NetworkId AND FromCurrency=@FromCurrency AND ToCurrency=@ToCurrency
END
GO
GRANT EXECUTE ON  [dbo].[usp_net_GetNetworkCurrencyExchangeRate] TO [WebV4Role]
GO
