SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_sys_GetTypeValues]
@TypeId bigint
AS
BEGIN
  SELECT Name,Value,Description FROM dbo.tbl_TypeValue WHERE TypeId=@TypeId
END
GO
GRANT EXECUTE ON  [dbo].[usp_sys_GetTypeValues] TO [WebV4Role]
GO
