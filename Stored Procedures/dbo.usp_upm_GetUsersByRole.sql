SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_upm_GetUsersByRole] (@RoleId bigint)
AS
BEGIN
  SELECT u.Id UserId,u.UserType UserType,u.UserName,u.FirstName,u.LastName,u.MiddleInitial,u.Password,
		 u.PasswordChangeDate,u.PasswordExpiryDate,u.LockoutDate,u.LockCount,u.ParentId,u.UserStatus,
		 i.TradeName1,i.TradeName2,i.TradeName3,i.Id IsoId,i.IsoCode
  FROM dbo.tbl_upm_User u JOIN dbo.tbl_upm_UserToRole ur ON u.Id=ur.UserID LEFT JOIN dbo.tbl_Iso i ON u.IsoId=i.Id
  WHERE ur.RoleId=@RoleId 
END
GO
GRANT EXECUTE ON  [dbo].[usp_upm_GetUsersByRole] TO [WebV4Role]
GO
