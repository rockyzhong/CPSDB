SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[usp_dev_GetPaymentMethod]
@DeviceId   bigint
AS
BEGIN
SELECT PaymentId,IsEnabled FROM               
dbo.tbl_DevicePaymentMethod WHERE  DeviceId =@DeviceId  
END   
GO
