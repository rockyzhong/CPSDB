SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_acq_InsertNetworkUpdateCommands]
@UpdatedUserId bigint,
@NetworkId   bigint
AS
BEGIN 

IF NOT EXISTS (select top 1 UpdatedUserId from [dbo].[tbl_UpdateCommands] where UpdatedUserId=@UpdatedUserId and updatecommand=(SELECT 'spnetapp\loadnet ' + convert(varchar(20), NetworkName) 
   FROM dbo.tbl_Network WHERE Id = @NetworkId))
   INSERT INTO tbl_UpdateCommands
   SELECT @UpdatedUserId, GETUTCDATE(),'spnetapp\loadnet ' + convert(varchar(20), NetworkName)
   FROM dbo.tbl_Network WHERE Id = @NetworkId
   ELSE
   UPDATE tbl_UpdateCommands set UpdatedDate=GETUTCDATE() where UpdatedUserId=@UpdatedUserId and updatecommand=(SELECT 'spnetapp\loadnet '+convert(varchar(20), NetworkName) 
   FROM dbo.tbl_Network WHERE Id = @NetworkId)
   
   RETURN 0
END
GO
