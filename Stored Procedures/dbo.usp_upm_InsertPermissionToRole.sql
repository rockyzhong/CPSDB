SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_upm_InsertPermissionToRole]
@RoleId        bigint,
@PermissionId  nvarchar(max),
@IsGranted     bigint,
@UpdatedUserId bigint
AS
BEGIN
  SET NOCOUNT ON
  
  DECLARE @Permission TABLE (Id bigint)
  INSERT INTO @Permission EXEC dbo.usp_sys_Split @PermissionId

  INSERT INTO dbo.tbl_upm_PermissionToRole(RoleId,PermissionId,IsGranted,UpdatedUserId) 
  SELECT @RoleId,Id,@IsGranted,@UpdatedUserId FROM @Permission
  WHERE Id NOT IN (SELECT PermissionId FROM dbo.tbl_upm_PermissionToRole WHERE RoleId=@RoleId AND IsGranted=@IsGranted)

  RETURN 0
END
GO
GRANT EXECUTE ON  [dbo].[usp_upm_InsertPermissionToRole] TO [WebV4Role]
GO
