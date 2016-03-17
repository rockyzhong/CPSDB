SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[usp_upm_UpdateUser]
@UserId         bigint,
@UserType       bigint,
@FirstName      nvarchar(50),
@LastName       nvarchar(50),
@MiddleInitial  nvarchar(50),
@IsoId          bigint,
@UserStatus     bigint,
@UpdatedUserId  bigint,
@BadgeName      nvarchar(30)
AS
BEGIN
  SET NOCOUNT ON
  UPDATE dbo.tbl_upm_User SET UserType=@UserType,FirstName=@FirstName,LastName=@LastName,MiddleInitial=@MiddleInitial,IsoId=@IsoId,UserStatus=@UserStatus,UpdatedUserId=@UpdatedUserId,BadgeName=@BadgeName WHERE Id=@UserId
  RETURN 0
END
GO
GRANT EXECUTE ON  [dbo].[usp_upm_UpdateUser] TO [WebV4Role]
GO
