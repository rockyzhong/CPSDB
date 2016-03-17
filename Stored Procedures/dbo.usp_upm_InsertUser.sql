SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[usp_upm_InsertUser]
@UserId              bigint OUTPUT,
@ParentId            bigint,
@UserType            bigint,
@UserName            nvarchar(50),
@FirstName           nvarchar(50),
@LastName            nvarchar(50),
@MiddleInitial       nvarchar(50),
@Password            varchar(512),
@AddressId           bigint OUTPUT,
@IsoId               bigint,
@UserStatus          bigint,
@UpdatedUserId       bigint,
@BadgeName           nvarchar(30),
@ForcePasswordExpiry bigint
AS
BEGIN
  SET NOCOUNT ON

  DECLARE @PasswordExpiryDate datetime
  IF @ForcePasswordExpiry=1
    SET @PasswordExpiryDate=GETUTCDATE()
  ELSE
  BEGIN
    DECLARE @PasswordExpiryDays bigint
    EXEC dbo.usp_sys_GetParameter N'PasswordExpiryDays',@PasswordExpiryDays OUT
    SET @PasswordExpiryDate=DATEADD(dd,ISNULL(@PasswordExpiryDays,60),GETUTCDATE())
  END

  INSERT INTO dbo.tbl_Address(UpdatedUserId) VALUES(@UpdatedUserId)
  SELECT @AddressId=IDENT_CURRENT('tbl_Address')

  INSERT INTO dbo.tbl_upm_User(ParentId,UserType,UserName,FirstName,LastName,MiddleInitial,Password,PasswordExpiryDate,PasswordChangeDate,AddressId,IsoId,UserStatus,UpdatedUserId,BADGENAME) VALUES(@ParentId,@UserType,@UserName,@FirstName,@LastName,@MiddleInitial,@Password,@PasswordExpiryDate,GETUTCDATE(),@AddressId,@IsoId,@UserStatus,@UpdatedUserId,@BadgeName)
  SELECT @UserId=IDENT_CURRENT('tbl_upm_User')
  
  INSERT dbo.tbl_upm_Object(SourceId,SourceType,CreatedUserId) VALUES(@UserId,2,@UpdatedUserId)
  RETURN 0
END
GO
GRANT EXECUTE ON  [dbo].[usp_upm_InsertUser] TO [WebV4Role]
GO
