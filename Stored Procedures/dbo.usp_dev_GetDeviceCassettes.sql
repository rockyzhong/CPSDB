SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_dev_GetDeviceCassettes] (@DeviceId bigint)
AS
BEGIN
  SELECT Id DeviceCassetteId,DeviceId,CassetteId,Currency,MediaCode,MediaValue,MediaCurrentCount,MediaCurrentUse,MediaCurrentAdjust,ReplenishmentDate
  FROM dbo.tbl_DeviceCassette
  WHERE DeviceId=@DeviceId
  ORDER BY CassetteId
END
GO
GRANT EXECUTE ON  [dbo].[usp_dev_GetDeviceCassettes] TO [WebV4Role]
GO
