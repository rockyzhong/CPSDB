SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_iso_GetIsoNetWorkListbyIsoId] (@IsoId bigint)
AS
BEGIN
	SET NOCOUNT ON;

	SELECT nw.Id ID 
    FROM tbl_IsoCageCheckTransactionConfig cc JOIN tbl_Network nw ON cc.NetworkId = nw.Id
	WHERE cc.IsoId = @IsoId
	UNION
	SELECT nw1.Id ID
    FROM tbl_NetworkRouteRule nr JOIN tbl_Network nw1 ON nr.NetworkCode = nw1.NetworkCode
	WHERE nr.IsoId =  @IsoId AND nr.RuleStatus =1
	
END
GO
