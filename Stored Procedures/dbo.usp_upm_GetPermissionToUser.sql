SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-------------------------CPS_Cage_Permissions_Names_Descriptions -------------------------


CREATE PROCEDURE [dbo].[usp_upm_GetPermissionToUser]
@UserId bigint,
@IsGranted bigint=1
AS
BEGIN
  SET NOCOUNT ON

  DECLARE @Permission TABLE (Id bigint)
  INSERT INTO @Permission 
  SELECT PermissionId
  FROM dbo.tbl_upm_PermissionToUser
  WHERE UserId=@UserId
  GROUP BY PermissionId
  HAVING MIN(CONVERT(bigint,IsGranted))=@IsGranted;

  SELECT p.Id,p.PermissionName,p.Description FROM dbo.tbl_upm_Permission p JOIN @Permission pu ON p.Id=pu.id ORDER BY p.PermissionName 
END
GO
GRANT EXECUTE ON  [dbo].[usp_upm_GetPermissionToUser] TO [WebV4Role]
GO
