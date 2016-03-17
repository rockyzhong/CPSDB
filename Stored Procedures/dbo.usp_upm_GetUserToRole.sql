SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_upm_GetUserToRole] (@UserId bigint)
AS
BEGIN
  SET NOCOUNT ON
  SELECT r.Id,r.RoleName,r.Description FROM dbo.tbl_upm_Role r JOIN dbo.tbl_upm_UserToRole ur ON r.id=ur.RoleId WHERE ur.UserId=@UserId
END
GO
GRANT EXECUTE ON  [dbo].[usp_upm_GetUserToRole] TO [WebV4Role]
GO
