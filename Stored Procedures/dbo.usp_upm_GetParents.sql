SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_upm_GetParents]
@UserId     bigint
AS
BEGIN
  SET NOCOUNT ON

  DECLARE @UserIds TABLE(UserId bigint)
  WHILE EXISTS (SELECT * FROM dbo.tbl_upm_User WHERE ParentId IS NOT NULL AND Id=@UserId)
  BEGIN
    SELECT @UserId=ParentId FROM dbo.tbl_upm_User WHERE ParentId IS NOT NULL AND Id=@UserId
    INSERT INTO @UserIds(UserId) VALUES(@UserId)
  END
  
  SELECT u.Id UserId,u.UserType UserType,u.UserName,u.FirstName,u.LastName,u.MiddleInitial,u.Password,
         u.PasswordChangeDate,u.PasswordExpiryDate,u.LockoutDate,u.LockCount,u.ParentId,u.UserStatus
  FROM dbo.tbl_upm_User u
  WHERE u.Id IN (SELECT UserId FROM @UserIds)
END
GO
GRANT EXECUTE ON  [dbo].[usp_upm_GetParents] TO [WebV4Role]
GO
