SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_dev_GetDevicesByUserIdDeviceModelFeatureFlag]
@UserId                 bigint,
@DeviceModelFeatureFlag bigint
AS
BEGIN
  SET NOCOUNT ON

  DECLARE @Source SourceTABLE
  INSERT INTO @Source EXEC dbo.usp_upm_GetObjectIds @UserId,1,1
  
  SELECT d.Id DeviceId,d.TerminalName,d.Location
  FROM dbo.tbl_Device d JOIN @Source s ON d.Id=s.Id
  JOIN dbo.tbl_DeviceModel o ON d.ModelId=o.Id
  WHERE d.DeviceStatus<>4 AND o.FeatureFlags & @DeviceModelFeatureFlag != 0
END
GO
GRANT EXECUTE ON  [dbo].[usp_dev_GetDevicesByUserIdDeviceModelFeatureFlag] TO [WebV4Role]
GO
