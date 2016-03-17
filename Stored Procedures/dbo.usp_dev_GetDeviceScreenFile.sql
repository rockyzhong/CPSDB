SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/***/
CREATE PROCEDURE [dbo].[usp_dev_GetDeviceScreenFile]
@StateFileName   nvarchar(200) = NULL,
@DeviceEmulation bigint = NULL
AS
BEGIN
  IF @StateFileName IS NULL AND @DeviceEmulation IS NULL
    SELECT DISTINCT ScreenFileName FROM dbo.tbl_DeviceConfigFile ORDER BY ScreenFileName
  ELSE   
    SELECT DISTINCT ScreenFileName FROM dbo.tbl_DeviceConfigFile WHERE DeviceEmulation=@DeviceEmulation AND StateFileName=@StateFileName
END
GO
