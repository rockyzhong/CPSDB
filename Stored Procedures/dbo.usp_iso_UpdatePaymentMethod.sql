SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[usp_iso_UpdatePaymentMethod]
@IsoId bigint,
@PaymentId bigint,
@DefaultEnabled bit,
@DisplayName nvarchar(50),
@UpdatedUserId bigint
WITH EXECUTE AS 'dbo'
AS
BEGIN
       UPDATE tbl_IsoPaymentMethod
       SET DefaultEnabled=@DefaultEnabled,DisplayName=@DisplayName,UpdatedDate=GETUTCDATE(), UpdatedUserId=@UpdatedUserId
       WHERE IsoId =@IsoId AND PaymentId = @PaymentId
END
GO
