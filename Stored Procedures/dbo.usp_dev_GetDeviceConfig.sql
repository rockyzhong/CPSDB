SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_dev_GetDeviceConfig] 
@DeviceId bigint
AS
BEGIN
  SELECT c.Id DeviceConfigId,c.DeviceConfigFileId,f.ConfigDesc,f.ScreenFileName,f.ConfigValueFileName,f.StateFileName,o.Id OverrideFileId,o.OverrideFileName,o.OverrideFileDesc,c.ConfigID
  FROM dbo.tbl_DeviceConfig c 
  JOIN dbo.tbl_DeviceConfigFile f ON f.Id=c.DeviceConfigFileId
  LEFT JOIN dbo.tbl_DeviceOverrideFile o ON o.Id=c.DeviceOverrideFileId
  WHERE c.DeviceId=@DeviceId
END
GO
