SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_dev_GetDeviceFeeOverrideRules] 
@FeeOverrideId bigint
AS
BEGIN 
  SELECT Id FeeOverrideRuleId,FeeOverrideId,FeeOverrideType,FeeOverrideData
  FROM dbo.tbl_DeviceFeeOverrideRule
  WHERE FeeOverrideId=@FeeOverrideId
END
GO
GRANT EXECUTE ON  [dbo].[usp_dev_GetDeviceFeeOverrideRules] TO [WebV4Role]
GO
