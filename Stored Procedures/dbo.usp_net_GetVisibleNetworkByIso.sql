SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_net_GetVisibleNetworkByIso]
@IsoId      bigint,
@UserId     bigint
AS
BEGIN
  SET NOCOUNT ON
  IF @UserId=1
  SELECT n.Id NetworkId,n.Currency,n.NetworkCode,n.NetworkName,n.Description 
  FROM tbl_NetworkMerchant nm JOIN tbl_Network n ON nm.NetworkId=n.Id
  where nm.IsoId=@IsoId
  ELSE 
  SELECT n.Id NetworkId,n.Currency,n.NetworkCode,n.NetworkName,n.Description 
  FROM tbl_NetworkMerchant nm JOIN tbl_Network n ON nm.NetworkId=n.Id
  where nm.IsoId=@IsoId AND 
  n.id IN (SELECT otu.ObjectId FROM dbo.tbl_upm_ObjectToUser otu JOIN dbo.tbl_upm_Object tuo ON 
  otu.ObjectId=tuo.id AND tuo.SourceType=6 AND otu.UserId=@UserId AND otu.IsGranted=1)
END
GO
