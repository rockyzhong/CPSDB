SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[usp_net_DeleteNetworkgetTelecheck]
@NetworkMerchantId bigint
AS
BEGIN

DELETE FROM usp_net_DeleteNetworkgetTelecheck WHERE NetworkMerchantId = @NetworkMerchantId

END
GO
