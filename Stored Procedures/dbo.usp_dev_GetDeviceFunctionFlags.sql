SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_dev_GetDeviceFunctionFlags]
AS
BEGIN
  SELECT FunctionId,FunctionDesc,DefaultState,WarningText FROM dbo.tbl_DeviceFunctionFlags ORDER BY FunctionId
END
GO
GRANT EXECUTE ON  [dbo].[usp_dev_GetDeviceFunctionFlags] TO [WebV4Role]
GO
