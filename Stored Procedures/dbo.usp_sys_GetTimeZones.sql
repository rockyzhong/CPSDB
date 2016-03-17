SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_sys_GetTimeZones]
AS
BEGIN
  SELECT Id TimeZoneId,TimeZoneName,TimeZoneTime FROM dbo.tbl_TimeZone
END
GO
GRANT EXECUTE ON  [dbo].[usp_sys_GetTimeZones] TO [WebV4Role]
GO
