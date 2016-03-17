SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_dev_GetDeviceOverrideFile]
AS
BEGIN
  SELECT Id DeviceOverrideFileId,OverrideFileName,OverrideFileDesc
  FROM dbo.tbl_DeviceOverrideFile
  ORDER BY OverrideFileName
END
GO
