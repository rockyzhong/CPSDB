SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_upm_GetRole] 
@RoleId bigint
AS
BEGIN
  SELECT Id,RoleName,Description,UpdatedUserId FROM dbo.tbl_upm_Role WHERE Id=@RoleId
END
GO
GRANT EXECUTE ON  [dbo].[usp_upm_GetRole] TO [WebV4Role]
GO
