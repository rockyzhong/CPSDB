SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[usp_trn_GetCardTransactionPaymentInfo]
@TransId  Bigint,
@DeviceId Bigint
AS
BEGIN
  SET NOCOUNT ON
  DECLARE @IsoId bigint
  SELECT @IsoId = IsoId  from tbl_Device where Id=@DeviceId
  IF EXISTS (SELECT Id FROM tbl_IsoPaymentMethod WHERE IsoId= @IsoId)   
  SELECT p.PaymentId  PaymentId,
  p.Amount Amount,
  ISNULL(i.DisplayName,t.Name) Name
  FROM tbl_trn_TransactionPaymentMethod p
  JOIN dbo.tbl_IsoPaymentMethod i ON i.PaymentId=p.PaymentId  AND i.IsoId=@Isoid
  JOIN dbo.tbl_TypeValue t ON i.PaymentId=t.value AND t.TypeId=195
  WHERE TransId=@TransId 
  ELSE
	 SELECT p.PaymentId  PaymentId,
      p.Amount Amount,
      t.Name Name
      FROM tbl_trn_TransactionPaymentMethod p
      JOIN dbo.tbl_TypeValue t ON p.PaymentId=t.value AND t.TypeId=195
      WHERE TransId=@TransId 
  RETURN 0
END

GO
