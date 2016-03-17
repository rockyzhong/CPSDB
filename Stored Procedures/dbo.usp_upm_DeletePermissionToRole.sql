SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_upm_DeletePermissionToRole]
@RoleId        bigint,
@PermissionId  nvarchar(max),
@IsGranted     bigint,
@UpdatedUserId bigint
AS
BEGIN
  SET NOCOUNT ON

  DECLARE @Permission TABLE (Id bigint)
  INSERT INTO @Permission EXEC dbo.usp_sys_Split @PermissionId

  UPDATE dbo.tbl_upm_PermissionToRole SET UpdatedUserId=@UpdatedUserId WHERE RoleId=@RoleId AND PermissionId IN (SELECT Id FROM @Permission) AND IsGranted=@IsGranted
  DELETE FROM dbo.tbl_upm_PermissionToRole WHERE RoleId=@RoleId AND PermissionId IN (SELECT Id FROM @Permission) AND IsGranted=@IsGranted

  RETURN 0
END
GO
GRANT EXECUTE ON  [dbo].[usp_upm_DeletePermissionToRole] TO [WebV4Role]
GO
