SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_net_GetNetworkgetTelecheck]
@NetworkMerchantId bigint
AS
BEGIN

SELECT Id, NetworkMerchantId, MerchantIdNo1, MerchantIdNo2, MerchantIdNo3, CheckType, DisplayTransHist,
TransHistDays,KioskEnabled, CheckLimit FROM tbl_NetworkMerchantTeleCheck WHERE NetworkMerchantId = @NetworkMerchantId

END
GO
