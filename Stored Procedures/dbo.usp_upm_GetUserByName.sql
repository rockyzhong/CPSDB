SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[usp_upm_GetUserByName] (@UserName nvarchar(200))
AS
BEGIN
  SELECT u.Id UserId,u.UserType,u.UserName,u.FirstName,u.LastName,u.MiddleInitial,u.Password,
		 u.PasswordChangeDate,u.PasswordExpiryDate,u.LockoutDate,u.LockCount,u.ParentId,u.UserStatus,
		 u.BADGENAME,i.TradeName1,i.TradeName2,i.TradeName3,i.Id IsoId,i.IsoCode
  FROM dbo.tbl_upm_User u LEFT JOIN dbo.tbl_Iso i ON u.IsoId=i.Id
  WHERE u.UserName=@UserName 
END
GO
GRANT EXECUTE ON  [dbo].[usp_upm_GetUserByName] TO [WebV4Role]
GO
