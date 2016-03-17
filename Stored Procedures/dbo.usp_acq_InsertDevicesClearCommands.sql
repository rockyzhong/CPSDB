SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_acq_InsertDevicesClearCommands]
@UpdatedUserId bigint,
@DeviceId  bigint
AS
BEGIN 

IF NOT EXISTS (select top 1 UpdatedUserId from [dbo].[tbl_UpdateCommands] where UpdatedUserId=@UpdatedUserId and updatecommand=(SELECT 'sptermapp\clrterm ' + convert(varchar(20), TerminalName)
   FROM tbl_Device WHERE Id = @DeviceId) )
   INSERT INTO tbl_UpdateCommands
   SELECT @UpdatedUserId, GETUTCDATE(), 'sptermapp\clrterm ' + convert(varchar(20), TerminalName)
   FROM tbl_Device WHERE Id = @DeviceId
   ELSE
   UPDATE tbl_UpdateCommands set UpdatedDate=GETUTCDATE() where UpdatedUserId=@UpdatedUserId and updatecommand=(SELECT 'sptermapp\clrterm ' + convert(varchar(20), TerminalName)
   FROM tbl_Device WHERE Id = @DeviceId)
   
   RETURN 0
END
GO
