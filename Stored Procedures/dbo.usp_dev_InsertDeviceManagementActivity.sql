SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[usp_dev_InsertDeviceManagementActivity]
@DeviceId          bigint,
@ManagementDate    datetime,
@ManagementData    nvarchar(200),
@SmartAcquireId     bigint
AS
BEGIN
  SET NOCOUNT ON

  INSERT INTO dbo.tbl_DeviceManagementActivity(DeviceId,ManagementDate,ManagementData,UpdatedUserId)
  VALUES(@DeviceId,@ManagementDate,@ManagementData,@SmartAcquireId)
    ----  insert deviceupdatecommands
   --INSERT INTO tbl_DeviceUpdateCommands
   --SELECT @UpdatedUserId, GETUTCDATE(), 'Sptermapp\loadterm ' + convert(varchar(20), TerminalName)
   --FROM tbl_Device WHERE Id = @DeviceId 
  RETURN 0
END
GO
GRANT EXECUTE ON  [dbo].[usp_dev_InsertDeviceManagementActivity] TO [WebV4Role]
GO
