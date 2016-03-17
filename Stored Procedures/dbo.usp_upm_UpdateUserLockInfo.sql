SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_upm_UpdateUserLockInfo] (@UserId bigint,@LockoutDate datetime,@LockCount bigint,@UserStatus bigint,@UpdatedUserId  bigint)
AS
BEGIN
  SET NOCOUNT ON
  UPDATE dbo.tbl_upm_User SET LockoutDate=@LockoutDate,LockCount=@LockCount,UserStatus=@UserStatus,UpdatedUserId=@UpdatedUserId WHERE Id=@UserId
  RETURN 0
END
GO
GRANT EXECUTE ON  [dbo].[usp_upm_UpdateUserLockInfo] TO [WebV4Role]
GO
