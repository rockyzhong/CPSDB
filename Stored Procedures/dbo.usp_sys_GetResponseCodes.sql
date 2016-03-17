SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_sys_GetResponseCodes]
@ResponseTypeId           bigint,
@ResponseCodeExternal     nvarchar(50),
@ResponseSubCodeExternal  nvarchar(50)
AS
BEGIN
  SELECT TOP 1 * FROM dbo.tbl_ResponseCode WHERE ResponseTypeId=@ResponseTypeId AND ResponseCodeExternal=@ResponseCodeExternal AND (ResponseCodeExternal='-1' OR @ResponseSubCodeExternal is NULL OR ResponseSubCodeExternal=@ResponseSubCodeExternal)
END
GO
GRANT EXECUTE ON  [dbo].[usp_sys_GetResponseCodes] TO [WebV4Role]
GO
