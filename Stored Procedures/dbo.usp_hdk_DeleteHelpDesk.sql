SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[usp_hdk_DeleteHelpDesk] 
@HelpDeskId    bigint, 
@UpdatedUserId bigint
AS
BEGIN
  SET NOCOUNT ON

  UPDATE dbo.tbl_HelpDesk SET UpdatedUserId=@UpdatedUserId WHERE Id=@HelpDeskId
  DELETE FROM dbo.tbl_HelpDesk WHERE Id=@HelpDeskId
  
  RETURN 0
END
GO
