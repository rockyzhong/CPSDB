SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[usp_net_GetNetworkCurrency]
@NetworkId      bigint
AS
BEGIN
  SELECT FromCurrency,ToCurrency FROM dbo.tbl_NetworkCurrencyExchangeRate WHERE NetworkId=@NetworkId
END
GO
GRANT EXECUTE ON  [dbo].[usp_net_GetNetworkCurrency] TO [WebV4Role]
GO
