SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_upm_GetObjectType]
AS
BEGIN
  EXEC dbo.usp_sys_GetTypeValues 43
END
GO
GRANT EXECUTE ON  [dbo].[usp_upm_GetObjectType] TO [WebV4Role]
GO
