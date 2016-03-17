SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_upm_GetPartialModules] (@UserId nvarchar(200),@ModuleId nvarchar(200))
AS
BEGIN
	
	DECLARE @Permission SourceTable
	INSERT INTO @Permission EXEC dbo.usp_upm_GetPermissionIds @UserId
   
    IF @ModuleId =7  -- Certegy
	SELECT m.Id ModuleId,m.ModuleName,m.SortOrder SortOrder1,mi.Id MenuItemId,mi.MenuItemName,mi.MenuItemNav,mi.SortOrder SortOrder2,mi.PermissionId
	FROM dbo.tbl_MenuItem mi JOIN dbo.tbl_Module m ON m.Id=mi.ModuleId WHERE mi.PermissionId IN (SELECT Id FROM @Permission) AND mi.ModuleId<>@ModuleId AND mi.id<>289
	ORDER BY m.SortOrder, mi.SortOrder
	ELSE IF @ModuleId=59 --TeleCheck
	SELECT m.Id ModuleId,m.ModuleName,m.SortOrder SortOrder1,mi.Id MenuItemId,mi.MenuItemName,mi.MenuItemNav,mi.SortOrder SortOrder2,mi.PermissionId
	FROM dbo.tbl_MenuItem mi JOIN dbo.tbl_Module m ON m.Id=mi.ModuleId WHERE mi.PermissionId IN (SELECT Id FROM @Permission) AND mi.ModuleId<>@ModuleId AND mi.id<>303
	ORDER BY m.SortOrder, mi.SortOrder
	ELSE 
	SELECT m.Id ModuleId,m.ModuleName,m.SortOrder SortOrder1,mi.Id MenuItemId,mi.MenuItemName,mi.MenuItemNav,mi.SortOrder SortOrder2,mi.PermissionId
	FROM dbo.tbl_MenuItem mi JOIN dbo.tbl_Module m ON m.Id=mi.ModuleId WHERE mi.PermissionId IN (SELECT Id FROM @Permission) AND mi.ModuleId<>@ModuleId AND mi.id NOT IN (289,303)
	ORDER BY m.SortOrder, mi.SortOrder
END
GO
