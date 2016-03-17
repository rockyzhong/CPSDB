SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_dev_GetDeviceModels]
AS
BEGIN
  SELECT Id ModelId,Make,Model,FeatureFlags,DeviceEmulation,LoadAsEmulation,MaxBillsPerCassette,MaxBillsPerDispense
  FROM dbo.tbl_DeviceModel
  ORDER BY Make,Model
END
GO
GRANT EXECUTE ON  [dbo].[usp_dev_GetDeviceModels] TO [WebV4Role]
GO
