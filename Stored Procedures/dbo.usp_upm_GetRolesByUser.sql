SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_upm_GetRolesByUser] 
@UserId bigint
AS
BEGIN
  SET NOCOUNT ON
  
  -- Include self
  DECLARE @UserIds TABLE(UserId bigint);        
  INSERT INTO @UserIds(UserId) VALUES(@UserId);
  
  -- Include sub users
  DECLARE @Count1 bigint = 0,@Count2 bigint = 1;               
  WHILE (@Count2>@Count1)
  BEGIN
    SELECT @Count1=COUNT(*) FROM @UserIds
    INSERT INTO @UserIds(UserId) SELECT Id FROM dbo.tbl_upm_User WHERE ParentId IN (SELECT UserId FROM @UserIds) AND Id NOT IN (SELECT UserId FROM @UserIds)
    SELECT @Count2=COUNT(*) FROM @UserIds
  END

  -- Select roles
  SELECT Id,RoleName,Description FROM dbo.tbl_upm_Role WHERE CreatedUserId IN (SELECT UserId FROM @UserIds)
  UNION
  SELECT a.Id,a.RoleName,a.Description FROM dbo.tbl_upm_Role a JOIN dbo.tbl_upm_UserToRole b ON a.Id=b.RoleId WHERE b.UserId=@UserId;
END
GO
GRANT EXECUTE ON  [dbo].[usp_upm_GetRolesByUser] TO [WebV4Role]
GO
