SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_dev_GetDeviceStateFile]
@DeviceEmulation bigint = NULL
AS
BEGIN
  IF @DeviceEmulation IS NULL
    SELECT
      StateFileName,
      DefAuthState,
      DefDenyState,
      NextStates,
      LanguageStateOffsets
    FROM dbo.tbl_DeviceStateFile
    ORDER BY StateFileName 
  ELSE
    SELECT 
      s.StateFileName,
      s.DefAuthState,
      s.DefDenyState,
      s.NextStates,
      s.LanguageStateOffsets
    FROM dbo.tbl_DeviceStateFile s
    JOIN dbo.tbl_DeviceConfigFile c ON s.StateFileName = c.StateFileName
    WHERE c.DeviceEmulation = @DeviceEmulation
    ORDER BY s.StateFileName 
END
GO
