SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[usp_iso_GetNetworkRouteRule] 
@IsoId bigint
AS
BEGIN
  SET NOCOUNT ON

  SELECT nr.id Id, nr.ConditionExtendValue ConditionExtendValue, nr.ConditionType ConditionType, nr.ConditionValue ConditionValue, 
  tv.Name ConditionValueName,nr.NetworkCode NetworkCode,t.Name ConditionTypeName
  FROM dbo.tbl_NetworkRouteRule nr
  JOIN dbo.tbl_TypeValue tv ON  nr.ConditionValue = tv.Value and nr.ConditionType = tv.TypeId
  JOIN dbo.tbl_Type t ON nr.ConditionType = t.id
  WHERE nr.IsoId = @IsoId AND nr.RuleStatus = 1
END
GO
