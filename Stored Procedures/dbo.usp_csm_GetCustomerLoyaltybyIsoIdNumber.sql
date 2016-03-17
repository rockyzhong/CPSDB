SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_csm_GetCustomerLoyaltybyIsoIdNumber] 
  @IsoId    bigint,
  @LoaltyCardNumber NVARCHAR(50)
AS
BEGIN 
  SET NOCOUNT ON
  SELECT IsoId,CustomerId,ct.IdNumber,ct.IdState,LoyaltyCardNumber,PIN,cl.UpdatedUserId,UpdateTime FROM dbo.tbl_CustomerLoyalty cl
    JOIN dbo.tbl_Customer ct ON cl.CustomerId=ct.Id WHERE cl.IsoId=@IsoId AND cl.LoyaltyCardNumber=@LoaltyCardNumber 
   
  RETURN 0
END
GO
