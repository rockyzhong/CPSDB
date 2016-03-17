SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[usp_dev_InsertPaymentMethod]
@DeviceId bigint,
@PaymentId bigint,
@IsEnabled  bit =0,   -- default disable
--@UpdatedDate datetime=null,
@UpdatedUserId bigint=null
WITH EXECUTE AS 'dbo'
AS
BEGIN
	INSERT INTO tbl_DevicePaymentMethod
	VALUES (@DeviceId,@PaymentId,@IsEnabled,GETUTCDATE(),@UpdatedUserId);
END
GO
