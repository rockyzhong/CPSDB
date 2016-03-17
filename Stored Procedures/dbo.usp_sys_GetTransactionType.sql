SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_sys_GetTransactionType]
AS
BEGIN
  EXEC dbo.usp_sys_GetTypeValues 19
END
GO
GRANT EXECUTE ON  [dbo].[usp_sys_GetTransactionType] TO [WebV4Role]
GO
