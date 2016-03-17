SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/**/
/**/
/**/
CREATE PROCEDURE [dbo].[usp_sys_ClearupExpiredRecords]
AS
BEGIN
  SET NOCOUNT ON
  IF EXISTS(SELECT * FROM dbo.sysobjects WHERE name='tbl_AuditLog' AND type='U')
    DELETE FROM dbo.tbl_AuditLog WHERE UpdatedDate<DATEADD(month,-24,GETUTCDATE())
END
GO
GRANT EXECUTE ON  [dbo].[usp_sys_ClearupExpiredRecords] TO [WebV4Role]
GO
