SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_upm_SetUserInherit]
@UserId              bigint,
@SourceType          bigint,
@Inherit             bit,
@UpdatedUserId       bigint
AS
BEGIN
  SET NOCOUNT ON

  IF @Inherit=1 AND NOT EXISTS(SELECT * FROM dbo.tbl_upm_UserInherit WHERE UserId=@UserId AND SourceType=@SourceType)
    INSERT INTO dbo.tbl_upm_UserInherit(UserId,SourceType,UpdatedUserId) VALUES(@UserId,@SourceType,@UpdatedUserId)
  
  IF @Inherit=0 AND EXISTS(SELECT * FROM dbo.tbl_upm_UserInherit WHERE UserId=@UserId AND SourceType=@SourceType)
  BEGIN
    UPDATE dbo.tbl_upm_UserInherit SET UpdatedUserId=@UpdatedUserId WHERE UserId=@UserId AND SourceType=@SourceType
    DELETE FROM dbo.tbl_upm_UserInherit WHERE UserId=@UserId AND SourceType=@SourceType
  END
  
  RETURN 0
END
GO
GRANT EXECUTE ON  [dbo].[usp_upm_SetUserInherit] TO [WebV4Role]
GO
