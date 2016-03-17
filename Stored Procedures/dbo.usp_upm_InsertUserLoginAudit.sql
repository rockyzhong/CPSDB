SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_upm_InsertUserLoginAudit]
@UserLoginAuditId    bigint OUTPUT,
@UserName            nvarchar(50),
@ActivityTime        datetime,
@ActivityType        bigint,
@IsSuccessful        bit,
@Description         nvarchar(100),
@UpdatedUserId       bigint
AS
BEGIN
  SET NOCOUNT ON

  INSERT INTO dbo.tbl_upm_UserLoginAudit(UserName,ActivityTime,ActivityType,IsSuccessful,Description,UpdatedUserId) VALUES(@UserName,@ActivityTime,@ActivityType,@IsSuccessful,@Description,@UpdatedUserId)
  SELECT @UserLoginAuditId=IDENT_CURRENT('tbl_upm_UserLoginAudit')
  
  RETURN 0
END
GO
GRANT EXECUTE ON  [dbo].[usp_upm_InsertUserLoginAudit] TO [WebV4Role]
GO
