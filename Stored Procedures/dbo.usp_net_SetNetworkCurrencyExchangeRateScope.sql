SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[usp_net_SetNetworkCurrencyExchangeRateScope]
@NetworkId     bigint,
@FromCurrency  bigint,
@ToCurrency    bigint,
@ExchangeRate  numeric(9,6),
@Allowance     numeric(9,6),
@UpdatedUserId bigint
--@SmartAcquireId         bigint =0
AS
BEGIN
  SET NOCOUNT ON
  
  IF NOT EXISTS(SELECT * FROM dbo.tbl_NetworkCurrencyExchangeRateScope WHERE NetworkId=@NetworkId AND FromCurrency=@FromCurrency AND ToCurrency=@ToCurrency)
    INSERT INTO dbo.tbl_NetworkCurrencyExchangeRateScope(NetworkId,FromCurrency,ToCurrency,ExchangeRate,Allowance,UpdatedDate,UpdatedUserId) VALUES(@NetworkId,@FromCurrency,@ToCurrency,@ExchangeRate,@Allowance,GETUTCDATE
(),@UpdatedUserId)
  ELSE
    UPDATE dbo.tbl_NetworkCurrencyExchangeRateScope SET ExchangeRate=@ExchangeRate,Allowance=@Allowance,UpdatedDate=GETUTCDATE(),UpdatedUserId=@UpdatedUserId WHERE NetworkId=@NetworkId AND FromCurrency=@FromCurrency 
AND ToCurrency=@ToCurrency
 -- exec usp_acq_InsertNetworkUpdateCommands @SmartAcquireId,@NetworkId  
  RETURN 0   
END
GO
GRANT EXECUTE ON  [dbo].[usp_net_SetNetworkCurrencyExchangeRateScope] TO [WebV4Role]
GO
