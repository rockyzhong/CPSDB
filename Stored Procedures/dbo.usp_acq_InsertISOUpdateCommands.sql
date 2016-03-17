SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_acq_InsertISOUpdateCommands]
@UpdatedUserId bigint,
@IsoId   bigint
AS
BEGIN 

IF NOT EXISTS (select top 1 UpdatedUserId from [dbo].[tbl_UpdateCommands] where UpdatedUserId=@UpdatedUserId and updatecommand=(SELECT 'sptermapp\loadiso ' + convert(varchar(20), @IsoId))
   )
   INSERT INTO tbl_UpdateCommands
   SELECT @UpdatedUserId, GETUTCDATE(),'sptermapp\loadiso ' +convert(varchar(20), @IsoId)
  -- FROM dbo.tbl_Iso WHERE Id = @IsoId
   ELSE
   UPDATE tbl_UpdateCommands set UpdatedDate=GETUTCDATE() where UpdatedUserId=@UpdatedUserId and updatecommand=(SELECT 'sptermapp\loadiso ' + convert(varchar(20), @IsoId))
   
   RETURN 0
END
GO
