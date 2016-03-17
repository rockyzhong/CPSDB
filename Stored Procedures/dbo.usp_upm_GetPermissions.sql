SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_upm_GetPermissions]
@UserId bigint,
@IsGranted bigint = 1
AS
BEGIN
  SET NOCOUNT ON
  
  DECLARE @Permission TABLE (Id bigint)
  INSERT INTO @Permission EXEC dbo.usp_upm_GetPermissionIds @UserId,@IsGranted

  SELECT p.Id,p.PermissionName,p.Description FROM dbo.tbl_upm_Permission p JOIN @Permission pu ON p.Id=pu.id
END
GO
GRANT EXECUTE ON  [dbo].[usp_upm_GetPermissions] TO [WebV4Role]
GO
