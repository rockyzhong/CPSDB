SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[usp_hdk_UpdateHelpDesk] 
@HelpDeskId    bigint, 
@ContactName   nvarchar(50),
@PhoneNumber   nvarchar(50),
@PermissionId  bigint,
@UpdatedUserId bigint
AS
BEGIN
  SET NOCOUNT ON

  UPDATE dbo.tbl_HelpDesk SET
  ContactName=@ContactName,PhoneNumber=@PhoneNumber,PermissionId=@PermissionId,UpdatedDate=GETUTCDATE(),UpdatedUserId=@UpdatedUserId
  WHERE Id=@HelpDeskId
  
  RETURN 0
END
GO
