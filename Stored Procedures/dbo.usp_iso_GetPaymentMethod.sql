SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

 
CREATE PROCEDURE [dbo].[usp_iso_GetPaymentMethod]
@IsoId bigint
AS
BEGIN
SELECT PaymentId,DisplayName, DefaultEnabled FROM dbo.tbl_IsoPaymentMethod  
WHERE  IsoId =@IsoId 
END       
GO
