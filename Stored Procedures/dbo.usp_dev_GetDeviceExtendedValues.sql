SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_dev_GetDeviceExtendedValues] 
@DeviceId            bigint
AS
BEGIN
  SELECT v.Id DeviceExtendedValueId,v.DeviceId,v.DeviceEmulation,v.ExtendedColumnType,c.ExtendedColumnLabel,v.ExtendedColumnValue,v.SwitchUserFlag
  FROM dbo.tbl_DeviceExtendedValue v 
  LEFT JOIN dbo.tbl_DeviceExtendedColumn c ON v.DeviceEmulation=c.DeviceEmulation AND v.ExtendedColumnType=c.ExtendedColumnType
  WHERE v.DeviceId=@DeviceId AND NOT (v.DeviceEmulation=0 AND v.ExtendedColumnType BETWEEN 300 AND 317)
  ORDER BY c.ExtendedColumnLabel
END
GO
GRANT EXECUTE ON  [dbo].[usp_dev_GetDeviceExtendedValues] TO [WebV4Role]
GO
