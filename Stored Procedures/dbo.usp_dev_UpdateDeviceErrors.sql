SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[usp_dev_UpdateDeviceErrors]
@DeviceId          bigint,
@AccessoryCode     bigint,
@DeviceEmulation   bigint,
@ErrorText         nvarchar(200),
@ResolvedDate      datetime,
@ResolvedText      nvarchar(200),
@UpdatedUserId     bigint =0,
@SmartAcquireId        bigint =0
AS
BEGIN
  SET NOCOUNT ON

  IF @ResolvedDate IS NOT NULL
    UPDATE dbo.tbl_DeviceError SET ResolvedDate=@ResolvedDate,ResolvedText=@ResolvedText,UpdatedUserId=@UpdatedUserId 
    WHERE DeviceId=@DeviceId AND DeviceEmulation=@DeviceEmulation AND AccessoryCode=@AccessoryCode AND ErrorText LIKE @ErrorText+'%' AND ResolvedDate IS NULL

   -- Add update command for Smart Acquirer 
  exec [dbo].[usp_acq_InsertDevicesUpdateCommands] @SmartAcquireId,@DeviceId

  RETURN 0
END
GO
GRANT EXECUTE ON  [dbo].[usp_dev_UpdateDeviceErrors] TO [WebV4Role]
GO
