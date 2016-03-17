SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[usp_hdk_GetHelpDesks] 
@UserId bigint
AS
BEGIN
  SET NOCOUNT ON

  DECLARE @Permission TABLE (Id bigint)
  INSERT INTO @Permission EXEC dbo.usp_upm_GetPermissionIds @UserId,1

  SELECT h.Id HelpDeskId,h.ContactName,h.PhoneNumber,h.UpdatedDate,h.PermissionId,p.PermissionName
  FROM dbo.tbl_HelpDesk h
  LEFT JOIN dbo.tbl_upm_Permission p ON p.Id=h.PermissionId
  WHERE h.PermissionId IS NULL OR h.PermissionId IN (SELECT Id FROM @Permission)
END
GO
