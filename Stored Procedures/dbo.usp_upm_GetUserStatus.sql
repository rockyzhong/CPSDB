SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-----------------------------------------------------------------------
CREATE PROCEDURE [dbo].[usp_upm_GetUserStatus]
AS
BEGIN
  EXEC dbo.usp_sys_GetTypeValues 21
END
GO
GRANT EXECUTE ON  [dbo].[usp_upm_GetUserStatus] TO [WebV4Role]
GO
