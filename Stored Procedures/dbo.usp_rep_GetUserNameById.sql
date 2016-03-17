SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_rep_GetUserNameById]
    @UserID bigint    
AS
BEGIN
    SET NOCOUNT ON
    select UserName from tbl_upm_User where Id=@UserID
END
GO
GRANT EXECUTE ON  [dbo].[usp_rep_GetUserNameById] TO [WebV4Role]
GO
