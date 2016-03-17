SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_csm_GetCustomerLoyaltybyIdstate] 
  @IsoId    bigint,
  @Idnumber NVARCHAR(30),
  @IdState  NVARCHAR(20)
AS
BEGIN 
  SET NOCOUNT ON
  SELECT IsoId,CustomerId,ct.IdNumber,ct.IdState,cl.Track1,cl.Track2,PIN,cl.UpdatedUserId,UpdateTime FROM dbo.tbl_CustomerLoyalty cl
    JOIN dbo.tbl_Customer ct ON cl.CustomerId=ct.Id WHERE cl.IsoId=@IsoId AND ct.IdNumber=@Idnumber AND ct.IdState=@IdState
   
  RETURN 0
END
GO
