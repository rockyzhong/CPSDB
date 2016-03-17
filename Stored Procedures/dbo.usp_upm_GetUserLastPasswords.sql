SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_upm_GetUserLastPasswords] (@UserId nvarchar(200))
AS
BEGIN
  SELECT TOP 4 Password FROM dbo.tbl_upm_UserPasswordHistory WHERE UserId=@UserId ORDER BY Id DESC
END
GO
GRANT EXECUTE ON  [dbo].[usp_upm_GetUserLastPasswords] TO [WebV4Role]
GO
