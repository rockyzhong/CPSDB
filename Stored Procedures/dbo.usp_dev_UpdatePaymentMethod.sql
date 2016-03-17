SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[usp_dev_UpdatePaymentMethod]
@DeviceId bigint,
@PaymentId bigint,
@IsEnabled bit,
--@UpdatedDate datetime,
@UpdatedUserId bigint
WITH EXECUTE AS 'dbo'
AS
BEGIN
	UPDATE tbl_DevicePaymentMethod
	SET IsEnabled=@IsEnabled,UpdatedDate=GETUTCDATE(),UpdatedUserId=@UpdatedUserId
	WHERE DeviceId=@DeviceId AND PaymentId=@PaymentId
END
GO
