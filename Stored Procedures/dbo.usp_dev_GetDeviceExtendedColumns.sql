SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_dev_GetDeviceExtendedColumns] 
@DeviceEmulation     bigint
AS
BEGIN
  SELECT Id DeviceExtendedColumnId,DeviceEmulation,ExtendedColumnType,ExtendedColumnLabel,ExtendedColumnDescription,SwitchUserFlag
  FROM dbo.tbl_DeviceExtendedColumn
  WHERE DeviceEmulation =@DeviceEmulation OR (DeviceEmulation=0 AND ExtendedColumnType NOT BETWEEN 300 AND 317)
END
GO
GRANT EXECUTE ON  [dbo].[usp_dev_GetDeviceExtendedColumns] TO [WebV4Role]
GO
