SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_upm_InsertUserToRole] (@UserId bigint,@RoleId bigint,@UpdatedUserId bigint)
AS
BEGIN
  SET NOCOUNT ON
  INSERT INTO dbo.tbl_upm_UserToRole(UserId,RoleId,UpdatedUserId) VALUES(@UserId,@RoleId,@UpdatedUserId)
  RETURN 0
END
GO
GRANT EXECUTE ON  [dbo].[usp_upm_InsertUserToRole] TO [WebV4Role]
GO
