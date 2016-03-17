SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[usp_dev_GetDeviceModelFeatureFlags]
@DeviceModelId bigint
AS
BEGIN
  SELECT FeatureId,FeatureDesc
  FROM tbl_DeviceModelFeatureFlags f 
  JOIN dbo.tbl_DeviceModel m ON f.FeatureId & m.FeatureFlags <> 0
  WHERE m.Id=@DeviceModelId
END
GO
GRANT EXECUTE ON  [dbo].[usp_dev_GetDeviceModelFeatureFlags] TO [WebV4Role]
GO
