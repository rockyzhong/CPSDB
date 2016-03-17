SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[usp_trn_GetDevicePaymentMethod]
@DeviceId bigint
AS
BEGIN
DECLARE @Isoid bigint
IF exists (SELECT * FROM tbl_DevicePaymentMethod WHERE DeviceId=@DeviceId)
BEGIN 
      SELECT @Isoid=IsoId from dbo.tbl_Device where Id=@DeviceId
      IF EXISTS (SELECT * FROM tbl_IsoPaymentMethod WHERE IsoId=@IsoId)
      SELECT i.PaymentId PaymentId,ISNULL(i.DisplayName,t.Name) Name,d.IsEnabled IsEnabled
      FROM dbo.tbl_TypeValue t
      JOIN dbo.tbl_IsoPaymentMethod i ON i.PaymentId=t.Value AND t.TypeId=195 AND i.IsoId=@Isoid
      JOIN dbo.tbl_DevicePaymentMethod d ON d.PaymentId=t.Value 
      WHERE  d.DeviceId = @DeviceId AND d.IsEnabled=1
      ELSE
         SELECT d.PaymentId PaymentId,t.Name Name,d.IsEnabled IsEnabled
         FROM dbo.tbl_TypeValue t
         JOIN dbo.tbl_DevicePaymentMethod d ON d.PaymentId=t.Value AND t.TypeId=195
         WHERE  d.DeviceId = @DeviceId AND d.IsEnabled=1
END
ELSE
      SELECT t.Value PaymentId,
      t.Name Name,
      1 IsEnabled
      FROM dbo.tbl_TypeValue t
      WHERE  t.Value = 1 AND t.TypeId=195
END
GO
