SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_sys_GetParameter]
@Name  nvarchar(50),
@Value nvarchar(50) OUT
AS
BEGIN
  SELECT @Value=Value FROM dbo.tbl_Parameter WHERE Name=@Name
END
GO
GRANT EXECUTE ON  [dbo].[usp_sys_GetParameter] TO [WebV4Role]
GO
