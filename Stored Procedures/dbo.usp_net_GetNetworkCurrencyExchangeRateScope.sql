SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[usp_net_GetNetworkCurrencyExchangeRateScope]
@NetworkId    bigint,
@FromCurrency bigint,
@ToCurrency   bigint
AS
BEGIN
  SELECT 
  e.Id NetworkCurrencyExchangeRateScopeId,e.NetworkId,
  t1.Value FromCurrency,t1.Name FromCurrencyName,t1.Description FromCurrencyDescription,
  t2.Value ToCurrency,  t2.Name ToCurrencyName,  t2.Description ToCurrencyDescription,
  e.ExchangeRate,e.Allowance,e.UpdatedDate,e.UpdatedUserId,u.UserName UpdatedUserName
  FROM dbo.tbl_NetworkCurrencyExchangeRateScope e
  LEFT JOIN dbo.tbl_TypeValue t1 ON e.FromCurrency =t1.Value AND t1.TypeId=67
  LEFT JOIN dbo.tbl_TypeValue t2 ON e.ToCurrency   =t2.Value AND t2.TypeId=67
  LEFT JOIN dbo.tbl_upm_User  u  ON e.UpdatedUserId=u.Id 
  WHERE NetworkId=@NetworkId AND FromCurrency=@FromCurrency AND ToCurrency=@ToCurrency
END
GO
GRANT EXECUTE ON  [dbo].[usp_net_GetNetworkCurrencyExchangeRateScope] TO [WebV4Role]
GO
