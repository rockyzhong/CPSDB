SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_sys_GetTypeValue]
@TypeId bigint,
@Value bigint
AS
BEGIN
  SELECT Name,Value,Description FROM dbo.tbl_TypeValue WHERE TypeId=@TypeId AND Value=@Value
END
GO
GRANT EXECUTE ON  [dbo].[usp_sys_GetTypeValue] TO [WebV4Role]
GO
