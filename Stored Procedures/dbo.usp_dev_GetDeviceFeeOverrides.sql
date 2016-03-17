SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_dev_GetDeviceFeeOverrides] 
  @DeviceId   bigint
AS
BEGIN 
  SELECT o.Id FeeOverrideId,o.DeviceId,o.FeeOverridePriority,o.FeeFixed,o.FeePercentage,r.Id FeeOverrideRuleId,r.FeeOverrideType,r.FeeOverrideData
  FROM dbo.tbl_DeviceFeeOverride o JOIN dbo.tbl_DeviceFeeOverrideRule r ON r.FeeOverrideId=o.Id
  WHERE DeviceId=@DeviceId ORDER BY o.FeeOverridePriority,r.FeeOverrideType
END
GO
GRANT EXECUTE ON  [dbo].[usp_dev_GetDeviceFeeOverrides] TO [WebV4Role]
GO
