SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_upm_GetPermissionToRole]
@RoleId bigint,
@IsGranted bigint=1
AS
BEGIN
  SET NOCOUNT ON

  DECLARE @Permission TABLE (Id bigint)
  INSERT INTO @Permission 
  SELECT PermissionId
  FROM dbo.tbl_upm_PermissionToRole
  WHERE RoleId=@RoleId
  GROUP BY PermissionId
  HAVING MIN(CONVERT(bigint,IsGranted))=@IsGranted

  SELECT p.Id,p.PermissionName,p.Description FROM dbo.tbl_upm_Permission p JOIN @Permission pu ON p.Id=pu.id
END
GO
GRANT EXECUTE ON  [dbo].[usp_upm_GetPermissionToRole] TO [WebV4Role]
GO
