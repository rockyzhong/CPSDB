SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_upm_GetRoles] 
AS
BEGIN
  SELECT Id,RoleName,Description,UpdatedUserId FROM dbo.tbl_upm_Role
END
GO
GRANT EXECUTE ON  [dbo].[usp_upm_GetRoles] TO [WebV4Role]
GO
