SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_upm_Createnewuserswithfourroles]

---Make sure isoadmin has been created before running scripts below:
---First import excel into table report tbl_upm_newuserimport
---Column
---Fullname, Firstname, Lastname,MiddleInitial,importUsertype   (1,2,3,4 )     
--- 1. means cashieruser, 2. means audituser,3. means superuser,4. means adminuser 5.superuser+Cashier+Audituser+Adminuser
--- 6. -- Superuser+Cashier  7. superuser+Cashier+Audituser 8. Superuser+Cashier+Adminuser 9. Supseruser+Audituser 10. Supseruser+Adminuser 11. Supseruser+Adminuser+Audituser
---Added new column username for certain requirement   20151026
---Added merchant admin 20151027 and 4 roles and related users 20151028
---Devived into two SP (createnewadmin and createnewusers) 20151030
 @IsoId bigint,
 @AuditRoleId bigint,
 @CashierRoleId bigint,
 @SupervisorRoleId BIGINT,
 @AdminRoleId BIGINT,
 @AuditUserId BIGINT,
 @CashierUserId BIGINT,
 @SupervisorUserId BIGINT,
 @AdminUserId BIGINT
AS BEGIN
SET NOCOUNT ON
DECLARE @UserId  bigint,@AddressId  bigint 

 
------------------------------  Insert new users ------------------------
DECLARE @NewUserId bigint,@UserType nvarchar(50),@UserName nvarchar(50),@FirstName nvarchar(50),@LastName nvarchar(50),@MiddleInitial nvarchar(50),@NewUserName NVARCHAR(50)
DECLARE TempCursor CURSOR LOCAL FOR SELECT  Id,Usertype, FirstName, LastName , ISNULL(MiddleInitial,''),UserName FROM tbl_upm_NewUserImport ORDER BY id
    OPEN TempCursor
    FETCH NEXT FROM TempCursor INTO @NewUserId,@UserType,@FirstName,@LastName,@MiddleInitial,@NewUserName
      WHILE @@Fetch_Status=0
      BEGIN
	    IF @NewUserName IS NULL
		  BEGIN 
		     IF NOT EXISTS (select id from tbl_upm_user where UserName=LEFT(LTRIM(@Firstname),1)+LTRIM(RTRIM(@LastName)))
	         SET @UserName=LEFT(LTRIM(@Firstname),1)+LTRIM(RTRIM(@LastName))
				ELSE IF NOT EXISTS (select id from tbl_upm_user where UserName=LTRIM(RTRIM(@Firstname))+LTRIM(RTRIM(@LastName)))
				BEGIN
				SET @UserName=LTRIM(RTRIM(@Firstname))+LTRIM(RTRIM(@LastName))
				PRINT 'UserName:'+LEFT(LTRIM(@Firstname),1)+LTRIM(RTRIM(@LastName))+' exists, has to Change as '+LTRIM(RTRIM(@Firstname))+LTRIM(RTRIM(@LastName))+'!'
				END
				   ELSE IF NOT EXISTS (select id from cps..tbl_upm_user where UserName=LTRIM(RTRIM(@Firstname))+LTRIM(RTRIM(@LastName))+'1')
					 BEGIN 
					   SET @UserName=LTRIM(RTRIM(@Firstname))+LTRIM(RTRIM(@LastName))+'1'
					   PRINT 'UserName:'+LTRIM(RTRIM(@Firstname))+LTRIM(RTRIM(@LastName))+' exists, have to Change as '+LTRIM(RTRIM(@Firstname))+LTRIM(RTRIM(@LastName))+'1!'
					 END
					 ELSE
					   BEGIN
						 print 'UserName exists in V4, even using Firstname:'+@Firstname+' +Lastname:'+@Lastname+'1'+' as Username!'
						 GOTO Nextuser
					   END
		  END
	    
		ELSE IF NOT EXISTS(select id from tbl_upm_user where UserName=LTRIM(RTRIM(@NewUserName)))
		     SET @UserName=@NewUserName
		     ELSE IF NOT EXISTS (select id from tbl_upm_user where UserName=LEFT(LTRIM(@Firstname),1)+LTRIM(RTRIM(@LastName)))
	            BEGIN
			    SET @UserName=LEFT(LTRIM(@Firstname),1)+LTRIM(RTRIM(@LastName))
				PRINT 'UserName:'+LTRIM(RTRIM(@NewUserName))+' exists, has to Change as '+LEFT(LTRIM(@Firstname),1)+LTRIM(RTRIM(@LastName))+'!'
				END
				ELSE IF NOT EXISTS (select id from tbl_upm_user where UserName=LTRIM(RTRIM(@Firstname))+LTRIM(RTRIM(@LastName)))
				BEGIN
				SET @UserName=LTRIM(RTRIM(@Firstname))+LTRIM(RTRIM(@LastName))
				PRINT 'UserName:'+LEFT(LTRIM(@Firstname),1)+LTRIM(RTRIM(@LastName))+' exists, has to Change as '+LTRIM(RTRIM(@Firstname))+LTRIM(RTRIM(@LastName))+'!'
				END
				   ELSE IF NOT EXISTS (select id from cps..tbl_upm_user where UserName=LTRIM(RTRIM(@Firstname))+LTRIM(RTRIM(@LastName))+'1')
					 BEGIN 
					   SET @UserName=LTRIM(RTRIM(@Firstname))+LTRIM(RTRIM(@LastName))+'1'
					   PRINT 'UserName:'+LTRIM(RTRIM(@Firstname))+LTRIM(RTRIM(@LastName))+' exists, have to Change as '+LTRIM(RTRIM(@Firstname))+LTRIM(RTRIM(@LastName))+'1!'
					 END
					 ELSE
					   BEGIN
						 print 'UserName exists in V4, even using Firstname:'+@Firstname+' +Lastname:'+@Lastname+'1'+' as Username!'
						 GOTO Nextuser
					   END
		  
        IF @UserType=1    -- cashieruser
	      BEGIN
		  exec usp_upm_InsertUser @UserId OUTPUT, @CashierUserId,2,@UserName, @FirstName, @LastName,@MiddleInitial, 'Password1',@AddressId,@IsoId,1,1,'',null 
		--  exec usp_sys_UpdateAddress @AddressId, @ReginalId, @City,@Addressline1,'',@Postalcode,'','','','','','','','',@UpdateUserId
		  exec usp_upm_InsertUserToRole @UserId,@CashierRoleId,1
		  INSERT INTO cps..tbl_upm_UserInherit
		        ( UserId, SourceType, UpdatedUserId ) VALUES (@UserId,1,1),(@userId,2,1),(@userId,4,1),(@userId,7,1)
		  END
		ELSE IF @UserType=2   -- audituser
		  BEGIN
		  exec usp_upm_InsertUser @UserId OUTPUT, @AuditUserId,2,@UserName, @FirstName, @LastName,@MiddleInitial, 'Password1',@AddressId,@IsoId,1,1,'',null
		--  exec usp_sys_UpdateAddress @AddressId, @ReginalId, @City,@Addressline1,'',@Postalcode,'','','','','','','','',@UpdateUserId
		  exec usp_upm_InsertUserToRole @UserId,@AuditRoleId,1
		  INSERT INTO cps..tbl_upm_UserInherit
		        ( UserId, SourceType, UpdatedUserId ) VALUES (@UserId,1,1),(@userId,2,1),(@userId,4,1),(@userId,7,1)
          END
		ELSE IF @UserType=3   -- superuser
		  BEGIN
		  exec usp_upm_InsertUser @UserId OUTPUT, @SupervisorUserId,2,@UserName, @FirstName, @LastName,@MiddleInitial, 'Password1',@AddressId,@IsoId,1,1,'',null
	    --  exec usp_sys_UpdateAddress @AddressId, @ReginalId, @City,@Addressline1,'',@Postalcode,'','','','','','','','',@UpdateUserId
		  exec usp_upm_InsertUserToRole @UserId,@SupervisorRoleId,1
	      INSERT INTO cps..tbl_upm_UserInherit
		        ( UserId, SourceType, UpdatedUserId ) VALUES (@UserId,1,1),(@userId,2,1),(@userId,4,1),(@userId,7,1)
	      END
	    ELSE IF @UserType=4 -- Adminuser
		  BEGIN
		  exec usp_upm_InsertUser @UserId OUTPUT, @AdminUserId,2,@UserName, @FirstName, @LastName,@MiddleInitial, 'Password1',@AddressId,@IsoId,1,1,'',null
	    --  exec usp_sys_UpdateAddress @AddressId, @ReginalId, @City,@Addressline1,'',@Postalcode,'','','','','','','','',@UpdateUserId
		  exec usp_upm_InsertUserToRole @UserId,@AdminRoleId,1 
		  INSERT INTO cps..tbl_upm_UserInherit
		        ( UserId, SourceType, UpdatedUserId ) VALUES (@UserId,1,1),(@userId,2,1),(@userId,4,1),(@userId,7,1)
		  END
		ELSE IF @UserType=5 -- superuser+Cashier+Audituser+Adminuser
		  BEGIN
		  exec usp_upm_InsertUser @UserId OUTPUT, @SupervisorUserId,2,@UserName, @FirstName, @LastName,@MiddleInitial, 'Password1',@AddressId,@IsoId,1,1,'',null
	    --  exec usp_sys_UpdateAddress @AddressId, @ReginalId, @City,@Addressline1,'',@Postalcode,'','','','','','','','',@UpdateUserId
		  exec usp_upm_InsertUserToRole @UserId,@SupervisorRoleId,1
		  EXEC usp_upm_InsertUserToRole @UserId,@CashierRoleId,1
		  EXEC usp_upm_InsertUserToRole @UserId,@AuditRoleId,1
		  EXEC usp_upm_InsertUserToRole @UserId,@AdminRoleId,1
	      INSERT INTO cps..tbl_upm_UserInherit
		        ( UserId, SourceType, UpdatedUserId ) VALUES (@UserId,1,1),(@userId,2,1),(@userId,4,1),(@userId,7,1)
		  END
        ELSE IF @UserType=6 -- Superuser+Cashier
		  BEGIN
		  exec usp_upm_InsertUser @UserId OUTPUT, @SupervisorUserId,2,@UserName, @FirstName, @LastName,@MiddleInitial, 'Password1',@AddressId,@IsoId,1,1,'',null
	    --  exec usp_sys_UpdateAddress @AddressId, @ReginalId, @City,@Addressline1,'',@Postalcode,'','','','','','','','',@UpdateUserId
		  exec usp_upm_InsertUserToRole @UserId,@SupervisorRoleId,1
		  EXEC usp_upm_InsertUserToRole @UserId,@CashierRoleId,1
	      INSERT INTO cps..tbl_upm_UserInherit
		        ( UserId, SourceType, UpdatedUserId ) VALUES (@UserId,1,1),(@userId,2,1),(@userId,4,1),(@userId,7,1)
		  END
	    ELSE IF @UserType=7 -- Superuser+Cashier+Audituser
		  BEGIN
		  exec usp_upm_InsertUser @UserId OUTPUT, @SupervisorUserId,2,@UserName, @FirstName, @LastName,@MiddleInitial, 'Password1',@AddressId,@IsoId,1,1,'',null
	    --  exec usp_sys_UpdateAddress @AddressId, @ReginalId, @City,@Addressline1,'',@Postalcode,'','','','','','','','',@UpdateUserId
		  exec usp_upm_InsertUserToRole @UserId,@SupervisorRoleId,1
		  EXEC usp_upm_InsertUserToRole @UserId,@CashierRoleId,1
		  EXEC usp_upm_InsertUserToRole @UserId,@AuditRoleId,1
	      INSERT INTO cps..tbl_upm_UserInherit
		        ( UserId, SourceType, UpdatedUserId ) VALUES (@UserId,1,1),(@userId,2,1),(@userId,4,1),(@userId,7,1)
		  END
		 ELSE IF @UserType=8 -- Superuser+Cashier+Adminuser
		  BEGIN
		  exec usp_upm_InsertUser @UserId OUTPUT, @SupervisorUserId,2,@UserName, @FirstName, @LastName,@MiddleInitial, 'Password1',@AddressId,@IsoId,1,1,'',null
	    --  exec usp_sys_UpdateAddress @AddressId, @ReginalId, @City,@Addressline1,'',@Postalcode,'','','','','','','','',@UpdateUserId
		  exec usp_upm_InsertUserToRole @UserId,@SupervisorRoleId,1
		  EXEC usp_upm_InsertUserToRole @UserId,@CashierRoleId,1
		  EXEC usp_upm_InsertUserToRole @UserId,@AdminRoleId,1
	      INSERT INTO cps..tbl_upm_UserInherit
		        ( UserId, SourceType, UpdatedUserId ) VALUES (@UserId,1,1),(@userId,2,1),(@userId,4,1),(@userId,7,1)
		  END
		 ELSE IF @UserType=9 -- Superuser+Audituser
		  BEGIN
		  exec usp_upm_InsertUser @UserId OUTPUT, @SupervisorUserId,2,@UserName, @FirstName, @LastName,@MiddleInitial, 'Password1',@AddressId,@IsoId,1,1,'',null
	    --  exec usp_sys_UpdateAddress @AddressId, @ReginalId, @City,@Addressline1,'',@Postalcode,'','','','','','','','',@UpdateUserId
		  exec usp_upm_InsertUserToRole @UserId,@SupervisorRoleId,1
		  EXEC usp_upm_InsertUserToRole @UserId,@AuditRoleId,1
	      INSERT INTO cps..tbl_upm_UserInherit
		        ( UserId, SourceType, UpdatedUserId ) VALUES (@UserId,1,1),(@userId,2,1),(@userId,4,1),(@userId,7,1)
		  END
		 ELSE IF @UserType=10 -- Superuser+AdminUser
		  BEGIN
		  exec usp_upm_InsertUser @UserId OUTPUT, @SupervisorUserId,2,@UserName, @FirstName, @LastName,@MiddleInitial, 'Password1',@AddressId,@IsoId,1,1,'',null
	    --  exec usp_sys_UpdateAddress @AddressId, @ReginalId, @City,@Addressline1,'',@Postalcode,'','','','','','','','',@UpdateUserId
		  exec usp_upm_InsertUserToRole @UserId,@SupervisorRoleId,1
		  EXEC usp_upm_InsertUserToRole @UserId,@AdminRoleId,1
	      INSERT INTO cps..tbl_upm_UserInherit
		        ( UserId, SourceType, UpdatedUserId ) VALUES (@UserId,1,1),(@userId,2,1),(@userId,4,1),(@userId,7,1)
		  END
		 ELSE IF @UserType=11 -- Superuser+AdminUser+Audituser
		  BEGIN
		  exec usp_upm_InsertUser @UserId OUTPUT, @SupervisorUserId,2,@UserName, @FirstName, @LastName,@MiddleInitial, 'Password1',@AddressId,@IsoId,1,1,'',null
	    --  exec usp_sys_UpdateAddress @AddressId, @ReginalId, @City,@Addressline1,'',@Postalcode,'','','','','','','','',@UpdateUserId
		  exec usp_upm_InsertUserToRole @UserId,@SupervisorRoleId,1
		  EXEC usp_upm_InsertUserToRole @UserId,@AdminRoleId,1
		  EXEC usp_upm_InsertUserToRole @UserId,@AuditRoleId,1
	      INSERT INTO cps..tbl_upm_UserInherit
		        ( UserId, SourceType, UpdatedUserId ) VALUES (@UserId,1,1),(@userId,2,1),(@userId,4,1),(@userId,7,1)
		  END
        Delete FROM tbl_upm_NewUserImport WHERE Id=@NewUserId
      Nextuser:
      FETCH NEXT FROM TempCursor INTO @NewUserId,@UserType,@FirstName,@LastName,@MiddleInitial,@NewUserName
      END
      CLOSE TempCursor
      DEALLOCATE TempCursor
END
GO
