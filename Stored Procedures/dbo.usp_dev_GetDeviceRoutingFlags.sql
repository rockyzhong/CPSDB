SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_dev_GetDeviceRoutingFlags]
@CountryCode          bigint
AS
BEGIN
  SELECT Id DeviceRoutingFlagsId,Name,Description,CountryCode
  FROM dbo.tbl_DeviceRoutingFlags
  WHERE CountryCode=@CountryCode
END
GO
GRANT EXECUTE ON  [dbo].[usp_dev_GetDeviceRoutingFlags] TO [WebV4Role]
GO
