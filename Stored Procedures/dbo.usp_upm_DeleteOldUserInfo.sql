SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_upm_DeleteOldUserInfo] 
@Username nvarchar(50),
@Password varchar(512)
AS
BEGIN 
  SET NOCOUNT ON

  UPDATE dbo.tbl_upm_User SET Password=@Password WHERE Username =@Username
  DELETE FROM dbo.tbl_upm_User_Old WHERE Username =@Username

  RETURN 0
END
GO
