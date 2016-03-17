SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_upm_GetPermissionIds]
@UserId bigint,
@IsGranted bigint=1
AS
BEGIN
  SET NOCOUNT ON

  IF @UserId=1
  BEGIN
    IF @IsGranted=1
      SELECT Id FROM dbo.tbl_upm_Permission WHERE Id<>9998
    ELSE
      SELECT Id FROM dbo.tbl_upm_Permission WHERE Id=-1
  END    
  ELSE  
    SELECT PermissionId
    FROM (
      -- Get permissions from user role
      SELECT PermissionId, IsGranted
      FROM dbo.tbl_upm_PermissionToRole A
      WHERE RoleId IN (
      SELECT RoleId
      FROM dbo.tbl_upm_UserToRole
      WHERE UserId=@UserId
      )
      UNION
      -- Get permissions from user 
      SELECT PermissionId, IsGranted 
      FROM dbo.tbl_upm_PermissionToUser
      WHERE UserId=@UserId
    ) UP
    GROUP BY PermissionId
    HAVING MIN(CONVERT(bigint,IsGranted))=@IsGranted
END
GO
GRANT EXECUTE ON  [dbo].[usp_upm_GetPermissionIds] TO [WebV4Role]
GO
