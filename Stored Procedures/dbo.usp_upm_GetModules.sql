SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_upm_GetModules] (@UserId nvarchar(200))
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @Permission TABLE (Id bigint)
	INSERT INTO @Permission EXEC dbo.usp_upm_GetPermissionIds @UserId

	SELECT m.Id ModuleId,m.ModuleName,m.SortOrder SortOrder1,mi.Id MenuItemId,mi.MenuItemName,mi.MenuItemNav,mi.SortOrder SortOrder2,mi.PermissionId
	FROM dbo.tbl_MenuItem mi JOIN dbo.tbl_Module m ON m.Id=mi.ModuleId WHERE mi.PermissionId IN (SELECT Id FROM @Permission)
	ORDER BY m.SortOrder, mi.SortOrder
END
GO
GRANT EXECUTE ON  [dbo].[usp_upm_GetModules] TO [WebV4Role]
GO
