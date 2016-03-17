SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_dev_GetDeviceAlertPlusThreshold]
@DeviceId           bigint
AS
BEGIN
  SELECT DeviceId,CassetteId,WarningLevel,UrgentLevel,ActiveThreshold 
  FROM dbo.tbl_DeviceCassette 
  WHERE DeviceId=@DeviceId 
    AND (WarningLevel IS NOT NULL OR UrgentLevel IS NOT NULL OR ActiveThreshold IS NOT NULL)
END
GO
