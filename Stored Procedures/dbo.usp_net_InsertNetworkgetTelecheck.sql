SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE  PROCEDURE [dbo].[usp_net_InsertNetworkgetTelecheck]
@NetworkMerchantId BIGINT, 
@MerchantIdNo1 NVARCHAR(30),
@MerchantIdNo2 NVARCHAR(30),
@MerchantIdNo3 NVARCHAR(30),
@CheckLimit BIGINT,
@CheckType NVARCHAR(50),
@DisplayTransHist BIT,
@TransHistDays BIGINT,
@KioskEnabled BIT,
@UPdateUserId BIGINT
AS
BEGIN
SET NOCOUNT ON

INSERT INTO tbl_NetworkMerchantTeleCheck VALUES (@NetworkMerchantId, @MerchantIdNo1,@MerchantIdNo2, @MerchantIdNo3, @CheckType,@CheckLimit, @DisplayTransHist, @TransHistDays, @KioskEnabled, GETUTCDATE(), @UPdateUserId)

END
GO
