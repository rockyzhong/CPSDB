SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_net_UpdateNetworkgetTelecheck]
@NetworkMerchantId bigint,
@MerchantIdNo1 NVARCHAR(30),
@MerchantIdNo2 NVARCHAR(30),
@MerchantIdNo3 NVARCHAR(30),
@CheckType NVARCHAR(50),
@CheckLimit BIGINT,
@DisplayTransHist bit,
@TransHistDays bigint,
@KioskEnabled bit,
@UpdateUserId bigint
AS
BEGIN

UPDATE tbl_NetworkMerchantTeleCheck set MerchantIdNo1=@MerchantIdNo1, MerchantIdNo2=@MerchantIdNo2, MerchantIdNo3=@MerchantIdNo3, CheckType=@CheckType, CheckLimit=@CheckLimit, DisplayTransHist=@DisplayTransHist, TransHistDays=@TransHistDays,
KioskEnabled=@KioskEnabled, UpdateDate=GETUTCDATE(), UpdateUserId=@UpdateUserId WHERE NetworkMerchantId = @NetworkMerchantId

END
GO
