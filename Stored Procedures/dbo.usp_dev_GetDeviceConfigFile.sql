SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_dev_GetDeviceConfigFile] 
@DeviceEmulation bigint
AS
BEGIN
  SELECT Id DeviceConfigFileId,ConfigDesc,ScreenFileName,ConfigValueFileName,StateFileName
  FROM dbo.tbl_DeviceConfigFile
  WHERE DeviceEmulation=@DeviceEmulation
END
GO
