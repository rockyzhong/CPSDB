SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_upm_GetInheritParentId]
@UserId     bigint,
@SourceType bigint,
@ParentId   bigint OUTPUT
AS
BEGIN
  SET NOCOUNT ON

  WHILE EXISTS (SELECT * FROM dbo.tbl_upm_User u JOIN dbo.tbl_upm_UserInherit i ON u.Id=i.UserId WHERE u.ParentId IS NOT NULL AND i.UserId=@UserId AND i.SourceType IN (0,@SourceType))
  BEGIN
    SELECT @ParentId=u.ParentId FROM dbo.tbl_upm_User u JOIN dbo.tbl_upm_UserInherit i ON u.Id=i.UserId WHERE u.ParentId IS NOT NULL AND i.UserId=@UserId AND i.SourceType IN (0,@SourceType)
    SET @UserId=@ParentId
  END
  
  RETURN 0
END
GO
GRANT EXECUTE ON  [dbo].[usp_upm_GetInheritParentId] TO [WebV4Role]
GO
