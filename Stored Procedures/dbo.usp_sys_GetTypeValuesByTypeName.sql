SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_sys_GetTypeValuesByTypeName]
@TypeName nvarchar(50)
AS
BEGIN
  SELECT v.Name,v.Value,v.Description FROM dbo.tbl_TypeValue v JOIN dbo.tbl_Type t ON v.TypeId=t.Id WHERE t.Name=@TypeName
END
GO
GRANT EXECUTE ON  [dbo].[usp_sys_GetTypeValuesByTypeName] TO [WebV4Role]
GO
