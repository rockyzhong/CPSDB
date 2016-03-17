SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_dev_GetDeviceConfigValueFile]
@DeviceEmulation bigint = NULL
AS
BEGIN
  IF @DeviceEmulation IS NULL
    SELECT DISTINCT ConfigValueFileName FROM dbo.tbl_DeviceConfigFile ORDER BY ConfigValueFileName 
  ELSE
    SELECT DISTINCT ConfigValueFileName FROM dbo.tbl_DeviceConfigFile WHERE DeviceEmulation = @DeviceEmulation ORDER BY ConfigValueFileName 
END
GO
