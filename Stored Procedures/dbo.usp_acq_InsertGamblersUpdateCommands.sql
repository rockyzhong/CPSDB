SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_acq_InsertGamblersUpdateCommands]
@UpdatedUserId bigint

AS
BEGIN 

IF NOT EXISTS (select top 1 UpdatedUserId from [dbo].[tbl_UpdateCommands] where UpdatedUserId=@UpdatedUserId and updatecommand=(SELECT 'sptermapp\loadblock '))
   INSERT INTO tbl_UpdateCommands
   SELECT @UpdatedUserId, GETUTCDATE(), 'sptermapp\loadblock '
   ELSE
   UPDATE tbl_UpdateCommands set UpdatedDate=GETUTCDATE() where UpdatedUserId=@UpdatedUserId and updatecommand=(SELECT 'sptermapp\loadblock ')
   
   
   RETURN 0
END
GO
