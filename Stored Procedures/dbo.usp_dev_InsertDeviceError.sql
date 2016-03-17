SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
----------------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[usp_dev_InsertDeviceError]
@DeviceErrorId     bigint OUTPUT,
@DeviceId          bigint,
@DeviceEmulation   bigint,
@AccessoryCode     bigint,
@StartedDate       datetime,
@ErrorCode         bigint,
@ErrorText         nvarchar(50),
@ResolvedDate      datetime,
@ResolvedText      nvarchar(80),
@UpdatedUserId     bigint
--@SmartAcquierId    bigint
AS
-- Revision 2.2.0 2014.04.08 by Adam Glover
--   Add insert to tbl_DeviceUpdateCommands for both SmartAcquirers
BEGIN
  SET NOCOUNT ON

  INSERT INTO dbo.tbl_DeviceError(DeviceId,DeviceEmulation,AccessoryCode,StartedDate,ErrorCode,ErrorText,ResolvedDate,ResolvedText,UpdatedUserId) 
  VALUES(@DeviceId,@DeviceEmulation,@AccessoryCode,@StartedDate,@ErrorCode,@ErrorText,@ResolvedDate,@ResolvedText,@UpdatedUserId)
  SELECT @DeviceErrorId=IDENT_CURRENT('tbl_DeviceError')
-------------------------------------------------------------------------------------------------------------------
-- Add update command for Smart Acquirer ID 
--  INSERT INTO tbl_DeviceUpdateCommands
 -- SELECT @SmartAcquierId bigint, GETUTCDATE(), 'Sptermapp\loadterm ' + convert(varchar(20), TerminalName) + ' due to InsertDeviceError'
--  FROM tbl_Device WHERE Id = @DeviceId

  RETURN 0
END

GO
GRANT EXECUTE ON  [dbo].[usp_dev_InsertDeviceError] TO [WebV4Role]
GO
