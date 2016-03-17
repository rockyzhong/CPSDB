SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_dev_GetDeviceTitle31]
@DeviceId          bigint
AS
BEGIN
  SELECT Id DeviceTitle31Id,DeviceId,WindowNumber,AreaID
  FROM dbo.tbl_DeviceTitle31
  WHERE DeviceId=@DeviceId
END
GO
GRANT EXECUTE ON  [dbo].[usp_dev_GetDeviceTitle31] TO [WebV4Role]
GO
