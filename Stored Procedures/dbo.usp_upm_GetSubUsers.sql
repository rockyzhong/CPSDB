SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[usp_upm_GetSubUsers] (@UserId bigint)
AS
BEGIN
  SELECT u.Id UserId,u.UserType UserType,u.UserName,u.FirstName,u.LastName,u.MiddleInitial,u.Password,
         u.PasswordChangeDate,u.PasswordExpiryDate,u.LockoutDate,u.LockCount,u.ParentId,u.UserStatus,u.BadgeName,
         dbo.udf_GetSubUserCount(u.Id) ChildCount,
         i.Id IsoId,i.RegisteredName,i.TradeName1,i.TradeName2,i.TradeName3,i.IsoCode
  FROM dbo.tbl_upm_User u 
  LEFT JOIN dbo.tbl_Iso i ON u.IsoId=i.Id
  WHERE u.ParentId=@UserId
END
GO
GRANT EXECUTE ON  [dbo].[usp_upm_GetSubUsers] TO [WebV4Role]
GO
