SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_upm_UpdateUserLoginAudit]
@UserLoginAuditId    bigint,
@UserName            nvarchar(50),
@ActivityTime        datetime,
@ActivityType        bigint,
@IsSuccessful        bit,
@Description         nvarchar(100),
@UpdatedUserId       bigint
AS
BEGIN
  SET NOCOUNT ON
  UPDATE dbo.tbl_upm_UserLoginAudit SET UserName=@UserName,ActivityTime=@ActivityTime,ActivityType=@ActivityType,IsSuccessful=@IsSuccessful,Description=@Description,UpdatedUserId=@UpdatedUserId WHERE Id=@UserLoginAuditId
  RETURN 0
END
GO
GRANT EXECUTE ON  [dbo].[usp_upm_UpdateUserLoginAudit] TO [WebV4Role]
GO
