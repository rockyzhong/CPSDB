SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_csm_GetCustomerLoyaltybyIsoTrackData]
  @IsoId  bigint,
  @Track1 NVARCHAR(79),
  @Track2 NVARCHAR(40)
AS
BEGIN 
  SET NOCOUNT ON
  SELECT IsoId,CustomerId,ct.IdNumber,ct.IdState,Track1,Track2,PIN,cl.UpdatedUserId,UpdateTime FROM dbo.tbl_CustomerLoyalty cl
    JOIN dbo.tbl_Customer ct ON cl.CustomerId=ct.Id 
  WHERE cl.IsoId=@IsoId AND cl.Track1=@Track1 AND cl.Track2=@Track2
   
  RETURN 0
END
GO
