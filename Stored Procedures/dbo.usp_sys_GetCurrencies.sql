SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_sys_GetCurrencies]
AS
BEGIN
  EXEC dbo.usp_sys_GetTypeValues 67
END
GO
GRANT EXECUTE ON  [dbo].[usp_sys_GetCurrencies] TO [WebV4Role]
GO
