SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[usp_hdk_InsertHelpDesk] 
@HelpDeskId    bigint OUTPUT,
@ContactName   nvarchar(50),
@PhoneNumber   nvarchar(50),
@PermissionId  bigint,
@UpdatedUserId bigint
AS
BEGIN
  SET NOCOUNT ON

  INSERT INTO dbo.tbl_HelpDesk(ContactName,PhoneNumber,PermissionId,UpdatedDate,UpdatedUserId) VALUES(@ContactName,@PhoneNumber,@PermissionId,GETUTCDATE(),@UpdatedUserId)
  SELECT @HelpDeskId=IDENT_CURRENT('tbl_HelpDesk')
  
  RETURN 0
END
GO
