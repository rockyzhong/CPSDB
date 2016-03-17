SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[usp_net_InsertNetworkMerchant]
@NetworkMerchantId bigint OUTPUT,
@NetworkId         bigint,
@IsoId             bigint,
@MerchantId        nvarchar(50),
@UpdatedUserId     bigint
--@SmartAcquireId         bigint =0
AS
BEGIN
  SET NOCOUNT ON

  INSERT INTO dbo.tbl_NetworkMerchant(NetworkId,IsoId,MerchantId,UpdatedUserId) VALUES(@NetworkId,@IsoId,@MerchantId,@UpdatedUserId)
  SELECT @NetworkMerchantId=IDENT_CURRENT('tbl_NetworkMerchant')
 -- exec usp_acq_InsertNetworkUpdateCommands @SmartAcquireId,@NetworkId
  RETURN 0
END
GO
GRANT EXECUTE ON  [dbo].[usp_net_InsertNetworkMerchant] TO [WebV4Role]
GO
