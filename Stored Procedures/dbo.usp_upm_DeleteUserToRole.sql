SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_upm_DeleteUserToRole] (@UserId bigint,@RoleId bigint,@UpdatedUserId bigint)
AS
BEGIN
  SET NOCOUNT ON
  UPDATE dbo.tbl_upm_UserToRole SET UpdatedUserId=@UpdatedUserId WHERE UserId=@UserId AND RoleId=@RoleId
  DELETE FROM dbo.tbl_upm_UserToRole WHERE UserId=@UserId AND RoleId=@RoleId
  RETURN 0
END
GO
GRANT EXECUTE ON  [dbo].[usp_upm_DeleteUserToRole] TO [WebV4Role]
GO
