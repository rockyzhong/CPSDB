SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_rou_GetRoutingConfig]
@CountryCode bigint
AS
BEGIN
  -- BIN Group Properties
  SELECT BINGroup,BINGroupProperty,Issuers
  FROM dbo.tbl_BINGroupProperty
  WHERE CountryCode=@CountryCode
  ORDER BY BINGroup

  -- Routing Code Properties
  SELECT RoutingCode,RoutingProperty,Issuers
  FROM dbo.tbl_RoutingProperty
  WHERE CountryCode=@CountryCode
  ORDER BY RoutingCode

  -- Routing Criteria
  SELECT Priority,MapIndex,Surchargeable,
         ConditionType1,ConditionValue1,ConditionType2,ConditionValue2,ConditionType3,ConditionValue3,
         ConditionType4,ConditionValue4,ConditionType5,ConditionValue5,ConditionType6,ConditionValue6,
         ConditionType7,ConditionValue7,ConditionType8,ConditionValue8,ConditionType9,ConditionValue9
  FROM dbo.tbl_RoutingCondition
  WHERE CountryCode=@CountryCode
  ORDER BY Priority
END  
GO
GRANT EXECUTE ON  [dbo].[usp_rou_GetRoutingConfig] TO [SAV4Role]
GRANT EXECUTE ON  [dbo].[usp_rou_GetRoutingConfig] TO [WebV4Role]
GO
