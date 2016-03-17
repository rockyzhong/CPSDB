SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_upm_GetUserType]
AS
BEGIN
  EXEC dbo.usp_sys_GetTypeValues 39
END
GO
GRANT EXECUTE ON  [dbo].[usp_upm_GetUserType] TO [WebV4Role]
GO
