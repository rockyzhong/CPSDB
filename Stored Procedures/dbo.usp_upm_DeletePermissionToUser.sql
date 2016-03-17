SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_upm_DeletePermissionToUser]
@UserId        bigint,
@PermissionId  nvarchar(max),
@IsGranted     bigint,
@UpdatedUserId bigint
AS
BEGIN
  SET NOCOUNT ON

  DECLARE @Permission TABLE (Id bigint)
  INSERT INTO @Permission EXEC dbo.usp_sys_Split @PermissionId

  UPDATE dbo.tbl_upm_PermissionToUser SET UpdatedUserId=@UpdatedUserId WHERE UserId=@UserId AND PermissionId IN (SELECT Id FROM @Permission) AND IsGranted=@IsGranted
  DELETE FROM dbo.tbl_upm_PermissionToUser WHERE UserId=@UserId AND PermissionId IN (SELECT Id FROM @Permission) AND IsGranted=@IsGranted

  RETURN 0
END
GO
GRANT EXECUTE ON  [dbo].[usp_upm_DeletePermissionToUser] TO [WebV4Role]
GO
