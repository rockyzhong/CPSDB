SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/**/
CREATE PROCEDURE [dbo].[usp_dev_GetDeviceToInterchangeScheme] 
  @DeviceId                      bigint,
  @InterchangeSchemeId           bigint OUTPUT
AS
BEGIN 
  SET NOCOUNT ON
  
  SELECT @InterchangeSchemeId=InterchangeSchemeId FROM dbo.tbl_DeviceToInterchangeScheme WHERE DeviceId=@DeviceId
  
  RETURN 0
END
GO
GRANT EXECUTE ON  [dbo].[usp_dev_GetDeviceToInterchangeScheme] TO [WebV4Role]
GO
