SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_sys_GetTypeValueByName]
@TypeId bigint,
@Name   nvarchar(50)
AS
BEGIN
  SELECT Name,Value,Description FROM dbo.tbl_TypeValue WHERE TypeId=@TypeId AND Name=@Name
END
GO
GRANT EXECUTE ON  [dbo].[usp_sys_GetTypeValueByName] TO [WebV4Role]
GO
