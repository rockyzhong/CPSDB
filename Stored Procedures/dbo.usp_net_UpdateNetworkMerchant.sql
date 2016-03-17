SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[usp_net_UpdateNetworkMerchant]
@NetworkMerchantId bigint,
@NetworkId         bigint,
@IsoId             bigint,
@MerchantId        nvarchar(50),
@UpdatedUserId     bigint
--@SmartAcquireId         bigint =0
AS
BEGIN
  SET NOCOUNT ON

  UPDATE dbo.tbl_NetworkMerchant SET 
  @NetworkId=NetworkId,IsoId=@IsoId,MerchantId=@MerchantId,UpdatedUserId=@UpdatedUserId
  WHERE Id=@NetworkMerchantId
 -- EXEC usp_acq_InsertNetworkUpdateCommands @SmartAcquireId,@NetworkId
  RETURN 0
END
GO
GRANT EXECUTE ON  [dbo].[usp_net_UpdateNetworkMerchant] TO [WebV4Role]
GO
