SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[usp_hdk_GetHelpDesk] 
@HelpDeskId bigint
AS
BEGIN
  SET NOCOUNT ON

  SELECT h.Id HelpDeskId,h.ContactName,h.PhoneNumber,h.UpdatedDate,h.PermissionId,p.PermissionName
  FROM dbo.tbl_HelpDesk h
  LEFT JOIN dbo.tbl_upm_Permission p ON p.Id=h.PermissionId
  WHERE h.Id=@HelpDeskId
END
GO
