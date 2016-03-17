SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[usp_iso_InsertPaymentMethod]
@IsoId bigint,
@PaymentId bigint,
@DisplayName nvarchar(256),
@DefaultEnabled bit= 0,   --default disable 
--@UpdatedDate datetime =null,
@UpdatedUserId bigint =null
WITH EXECUTE AS 'dbo'
AS
BEGIN
	INSERT INTO tbl_IsoPaymentMethod
	VALUES (@IsoId,@PaymentId,@DisplayName,@DefaultEnabled,GETUTCDATE(),@UpdatedUserId);
END
GO
