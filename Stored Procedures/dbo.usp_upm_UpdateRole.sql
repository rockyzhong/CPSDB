SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_upm_UpdateRole] 
@RoleId bigint,
@RoleName nvarchar(50),
@Description nvarchar(50),
@UpdatedUserId bigint
AS
BEGIN
  SET NOCOUNT ON
  UPDATE dbo.tbl_upm_Role SET RoleName=@RoleName,Description=@Description,UpdatedUserId=@UpdatedUserId WHERE Id=@RoleId
  RETURN 0
END
GO
GRANT EXECUTE ON  [dbo].[usp_upm_UpdateRole] TO [WebV4Role]
GO
