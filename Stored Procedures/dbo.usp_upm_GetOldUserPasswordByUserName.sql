SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[usp_upm_GetOldUserPasswordByUserName] 
@Username nvarchar(50)
AS
BEGIN
  SELECT UserName,PasswordMD5,PasswordEncrypt,PasswordType
  FROM tbl_upm_User_Old
  WHERE UserName=@Username
END
GO
