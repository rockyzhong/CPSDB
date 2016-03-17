SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_upm_UpdateParentId]
@UserId              bigint,
@ParentId            bigint,
@UpdatedUserId       bigint
AS
BEGIN
  SET NOCOUNT ON

  UPDATE dbo.tbl_upm_UserInherit SET UpdatedUserId=@UpdatedUserId WHERE UserId=@UserId
  DELETE FROM dbo.tbl_upm_UserInherit WHERE UserId=@UserId

  UPDATE dbo.tbl_upm_ObjectToUser SET UpdatedUserId=@UpdatedUserId WHERE UserId=@UserId
  DELETE FROM dbo.tbl_upm_ObjectToUser WHERE UserId=@UserId

  UPDATE dbo.tbl_upm_PermissionToUser SET UpdatedUserId=@UpdatedUserId WHERE UserId=@UserId
  DELETE FROM dbo.tbl_upm_PermissionToUser WHERE UserId=@UserId

  UPDATE dbo.tbl_upm_UserToRole SET UpdatedUserId=@UpdatedUserId WHERE UserId=@UserId
  DELETE FROM dbo.tbl_upm_UserToRole WHERE UserId=@UserId
  
  UPDATE dbo.tbl_upm_User SET ParentId=@ParentId,UpdatedUserId=@UpdatedUserId WHERE Id=@UserId
  
  RETURN 0
END
GO
GRANT EXECUTE ON  [dbo].[usp_upm_UpdateParentId] TO [WebV4Role]
GO
