SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[usp_net_DeleteNetworkCurrencyExchangeRate]
@NetworkCurrencyExchangeRateId bigint,
@UpdatedUserId                 bigint,
@SmartAcquireId                bigint =0
AS
BEGIN
  Declare @networkid bigint
  SET NOCOUNT ON
  SELECT @networkid = networkid from dbo.tbl_NetworkCurrencyExchangeRate WHERE Id=@NetworkCurrencyExchangeRateId
  UPDATE dbo.tbl_NetworkCurrencyExchangeRate SET UpdatedUserId=@UpdatedUserId WHERE Id=@NetworkCurrencyExchangeRateId
  DELETE FROM dbo.tbl_NetworkCurrencyExchangeRate WHERE Id=@NetworkCurrencyExchangeRateId
  exec usp_acq_InsertNetworkUpdateCommands @SmartAcquireId,@NetworkId    
  RETURN 0
END
GO
GRANT EXECUTE ON  [dbo].[usp_net_DeleteNetworkCurrencyExchangeRate] TO [WebV4Role]
GO
