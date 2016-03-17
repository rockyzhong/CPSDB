SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_upm_GetUserInherit]
@UserId              bigint,
@SourceType          bigint,
@Inherit             bit OUTPUT
AS
BEGIN
  SET NOCOUNT ON

  IF EXISTS(SELECT * FROM dbo.tbl_upm_UserInherit WHERE UserId=@UserId AND SourceType=@SourceType)
    SET @Inherit=1
  ELSE
    SET @Inherit=0
  
  RETURN 0
END
GO
GRANT EXECUTE ON  [dbo].[usp_upm_GetUserInherit] TO [WebV4Role]
GO
