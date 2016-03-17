SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[usp_dev_SetDeviceError]
@DeviceId          bigint,
@AccessoryCode     bigint,
@DeviceEmulation   bigint,
@ErrorCode         bigint,
@ErrorText         nvarchar(200),
@StartedDate       datetime,
@ResolvedDate      datetime,
@ResolvedText      nvarchar(200),
@UpdatedUserId     bigint=0,
@SmartAcquireId    bigint = 0
AS
-- Revision 2.2.0 2014.04.08 by Adam Glover
--   Add insert to tbl_DeviceUpdateCommands for both SmartAcquirers
BEGIN
  SET NOCOUNT ON

  IF @ResolvedDate IS NOT NULL
    UPDATE dbo.tbl_DeviceError SET ResolvedDate=@ResolvedDate,ResolvedText=@ResolvedText,UpdatedUserId=@UpdatedUserId 
    WHERE DeviceId=@DeviceId AND DeviceEmulation=@DeviceEmulation AND AccessoryCode=@AccessoryCode AND ErrorCode=@ErrorCode AND ResolvedDate IS NULL
  ELSE
  BEGIN
    DECLARE @Suppression int
    SET @Suppression = 0
 
    IF @AccessoryCode=1
    BEGIN
      SELECT TOP 1 @Suppression = Suppression FROM dbo.tbl_EmulationErrorSuppression
      WHERE @ErrorText LIKE ErrorText+'%'
      ORDER BY LEN(ErrorText) DESC

      SELECT TOP 1 @ErrorText=ErrorDescription
      FROM dbo.tbl_EmulationErrorDescription
      WHERE ErrorText=@ErrorText
    END

    -- Do not write the error to database if a suppression entry was found.
    IF @Suppression=0
    BEGIN
      IF EXISTS(SELECT * FROM dbo.tbl_DeviceError 
        WHERE DeviceId=@DeviceId AND DeviceEmulation=@DeviceEmulation AND AccessoryCode=@AccessoryCode AND ErrorCode=@ErrorCode AND ResolvedDate IS NULL)
        UPDATE tbl_DeviceError SET ErrorText=@ErrorText,UpdatedUserId=@UpdatedUserId 
        WHERE DeviceId=@DeviceId AND DeviceEmulation=@DeviceEmulation AND AccessoryCode=@AccessoryCode AND ErrorCode=@ErrorCode AND ResolvedDate IS NULL
      ELSE
        INSERT INTO dbo.tbl_DeviceError(DeviceId,AccessoryCode,DeviceEmulation,ErrorCode,ErrorText,StartedDate,UpdatedUserId) 
        VALUES(@DeviceId,@AccessoryCode,@DeviceEmulation,@ErrorCode,@ErrorText,@StartedDate,@UpdatedUserId)
        
      -- Add update command for Smart Acquirer  
  exec [dbo].[usp_acq_InsertDevicesUpdateCommands] @SmartAcquireId,@DeviceId

    END
  END  
  
  RETURN 0
END
GO
GRANT EXECUTE ON  [dbo].[usp_dev_SetDeviceError] TO [WebV4Role]
GO
