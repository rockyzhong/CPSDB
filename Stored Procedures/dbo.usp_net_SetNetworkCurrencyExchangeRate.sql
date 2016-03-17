SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[usp_net_SetNetworkCurrencyExchangeRate]
@NetworkId     bigint,
@FromCurrency  bigint,
@ToCurrency    bigint,
@ExchangeRate  numeric(9,6),
@UpdatedUserId bigint,
@SmartAcquireId         bigint =0
AS
BEGIN
  SET NOCOUNT ON
  
  IF NOT EXISTS(SELECT * FROM dbo.tbl_NetworkCurrencyExchangeRate WHERE NetworkId=@NetworkId AND FromCurrency=@FromCurrency AND ToCurrency=@ToCurrency)
    INSERT INTO dbo.tbl_NetworkCurrencyExchangeRate(NetworkId,FromCurrency,ToCurrency,ExchangeRate,UpdatedDate,UpdatedUserId) VALUES(@NetworkId,@FromCurrency,@ToCurrency,@ExchangeRate,GETUTCDATE(),@UpdatedUserId)
  ELSE
    UPDATE dbo.tbl_NetworkCurrencyExchangeRate SET ExchangeRate=@ExchangeRate,UpdatedDate=GETUTCDATE(),UpdatedUserId=@UpdatedUserId WHERE NetworkId=@NetworkId AND FromCurrency=@FromCurrency AND ToCurrency=@ToCurrency
 exec usp_acq_InsertNetworkUpdateCommands @SmartAcquireId,@NetworkId   
  RETURN 0   
END
GO
GRANT EXECUTE ON  [dbo].[usp_net_SetNetworkCurrencyExchangeRate] TO [WebV4Role]
GO
