SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_upm_UpdateUserPassword] (@UserId bigint, @Password varchar(512),@UpdatedUserId  bigint)
AS
BEGIN
  SET NOCOUNT ON
  
  --Save old password
  DECLARE @Password0 varchar(512)
  SELECT @Password0=Password FROM dbo.tbl_upm_User WHERE Id=@UserId
  INSERT INTO tbl_upm_UserPasswordHistory(UserId,Password,UpdatedUserId) VALUES(@UserId,@Password0,@UpdatedUserId)

  --Get password expire days
  DECLARE @PasswordExpiryDays bigint,@PasswordExpiryDate datetime
  IF @UserId=@UpdatedUserId
  BEGIN
    EXEC dbo.usp_sys_GetParameter N'PasswordExpiryDays',@PasswordExpiryDays OUT
    SET @PasswordExpiryDate=DATEADD(dd,ISNULL(@PasswordExpiryDays,60),GETUTCDATE())
  END
  ELSE
    SET @PasswordExpiryDate=GETUTCDATE()

  --Update password
  UPDATE dbo.tbl_upm_User 
  SET Password=@Password,PasswordChangeDate=GETUTCDATE(),PasswordExpiryDate=@PasswordExpiryDate,UpdatedUserId=@UpdatedUserId
  WHERE Id=@UserId
  
  RETURN 0
END
GO
GRANT EXECUTE ON  [dbo].[usp_upm_UpdateUserPassword] TO [WebV4Role]
GO
