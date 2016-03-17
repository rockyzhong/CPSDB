SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_upm_Createnewusers]

---Make sure isoadmin has been created before running scripts below:
---First import excel into table report tbl_upm_newuserimport
---Column
---Fullname, Firstname, Lastname,MiddleInitial,importUsertype   (1,2,3,4 )     
--- 1. means cashieruser, 2. means audituser,3. means superuser,4. means adminuser
--- 5.superuser+Cashier+Audituser+Adminuser 6. Superuser+Cashier 7. superuser+Cashier+Audituser
---Added new column username for certain requirement   20151026
---Added merchant admin 20151027 and 4 roles and related users 20151028
---Devived into two SP (createnewadmin and createnewusers) 20151030
 @IsoId bigint,
 @ISOName NVARCHAR(50),
 @SuperAdminId BIGINT
AS BEGIN
SET NOCOUNT ON
DECLARE  --@SuperAdminFirstName NVARCHAR(50),@SuperAdminId BIGINT,
         @AuditRoleId bigint,
         @CashierRoleId bigint,
         @SupervisorRoleId BIGINT,
         @AdminRoleId BIGINT,
         @CashierUserId BIGINT,@CashierName NVARCHAR(50),@CashierFirstName NVARCHAR(50),
		 @SupervisorUserId BIGINT, @SupervisorName NVARCHAR(50),@SupervisorFirstName NVARCHAR(50),
		 @AuditUserId BIGINT,@AuditName NVARCHAR(50),@AuditFirstName NVARCHAR(50),
		 @AdminUserId BIGINT,@AdminName NVARCHAR(50),@AdminFirstName NVARCHAR(50),
         @UserId  bigint,@AddressId  bigint 
--set @ReportRoleId=15 -- need to find out reporter supervisor  cashier role and Admin Role
--set @CashierRoleId=13
--set @SupervisorRoleId=11
--SET @AdminRoleId=35

--------------create merchant admin user  ----------------

--SET @SuperAdminFirstName=@ISOName+'admin'
--EXEC usp_upm_InsertUser @SuperAdminId OUTPUT,1,2,@SuperAdminFirstName, @ISOName, 'Admin','','Password0',@AddressId,@IsoId,1,1,'',null 


----------------assign role for merchant admin  ----------------

--  INSERT INTO cps..tbl_upm_UserToRole
--          ( UserId, RoleId, UpdatedUserId )
--  VALUES  ( @SuperAdminId,  
--            11,
--            1)
--  INSERT INTO cps..tbl_upm_UserToRole
--          ( UserId, RoleId, UpdatedUserId )
--  VALUES  ( @SuperAdminId,  
--            13,
--            1)
--  INSERT INTO cps..tbl_upm_UserToRole
--          ( UserId, RoleId, UpdatedUserId )
--  VALUES  ( @SuperAdminId,  
--            15,
--            1)
--  INSERT INTO cps..tbl_upm_UserToRole
--          ( UserId, RoleId, UpdatedUserId )
--  VALUES  ( @SuperAdminId,  
--            35,
--            1)
--  INSERT INTO cps..tbl_upm_UserToRole
--          ( UserId, RoleId, UpdatedUserId )
--  VALUES  ( @SuperAdminId,  
--            37,
--            1)
--  INSERT INTO cps..tbl_upm_UserToRole
--          ( UserId, RoleId, UpdatedUserId )
--  VALUES  ( @SuperAdminId,  
--            39,
--            1)
--  INSERT INTO cps..tbl_upm_UserToRole
--          ( UserId, RoleId, UpdatedUserId )
--  VALUES  ( @SuperAdminId,  
--            41,
--            1)

------------assign object to merchant admin -------

--INSERT INTO cps..tbl_upm_ObjectToUser
--        ( UserId ,
--          ObjectId ,
--          IsGranted ,
--          UpdatedUserId
--        )
--SELECT @SuperAdminId,obj.id,1,null FROM cps..tbl_upm_Object obj JOIN cps..tbl_Device De ON  obj.SourceType=1 AND de.Id=obj.SourceId  WHERE de.IsoId=@IsoID

--INSERT INTO cps..tbl_upm_ObjectToUser
--        ( UserId ,
--          ObjectId ,
--          IsGranted ,
--          UpdatedUserId
--        )
--SELECT @SuperAdminId,obj.id,1,null FROM cps..tbl_upm_Object obj JOIN CPS.dbo.tbl_BankAccount ac ON obj.SourceType=3 AND ac.Id=obj.SourceId WHERE ac.IsoId=@IsoID
--INSERT INTO cps..tbl_upm_ObjectToUser
--        ( UserId ,
--          ObjectId ,
--          IsGranted ,
--          UpdatedUserId
--        )
--SELECT @SuperAdminId,obj.id,1,null FROM cps..tbl_upm_Object obj JOIN CPS.dbo.tbl_Iso iso ON obj.SourceType=4 AND iso.Id=obj.SourceId WHERE iso.id=@IsoID
--INSERT INTO cps..tbl_upm_ObjectToUser
--        ( UserId ,
--          ObjectId ,
--          IsGranted ,
--          UpdatedUserId
--        )
--SELECT @SuperAdminId,Id,1,1 FROM cps..tbl_upm_Object WHERE SourceType=7 AND Sourceid IN (51,53,55,57,2008,35,37,39,41,43,45,47,49,63,2001,65,67,69)

-------------------  Create 4 basic Roles and Role users for merchant -------------------



  INSERT INTO cps..tbl_upm_Role
          ( RoleName ,
            Description ,
            CreatedUserId ,
            UpdatedUserId
          )
  VALUES(@ISOName+' Cashier Role','',@SuperAdminId,'')

  SET @CashierRoleId=IDENT_CURRENT('cps..tbl_upm_Role')

  INSERT INTO cps..tbl_upm_PermissionToRole
          ( RoleId ,
            PermissionId ,
            IsGranted ,
            UpdatedUserId
          )
  SELECT @CashierRoleId,PermissionId,IsGranted,1 FROM tbl_upm_PermissionToRole WHERE RoleId=13
 
  SET @CashierName=@ISOName+'CashierParent'
  SET @CashierFirstName=@ISOName+' Cashier'
  EXEC usp_upm_InsertUser @CashierUserId OUTPUT,@SuperAdminId,2,@CashierName,@CashierFirstName, 'Parent','','Password0',@AddressId,@IsoId,1,1,'',null 

  INSERT INTO cps..tbl_upm_UserToRole
			( UserId, RoleId, UpdatedUserId )
			VALUES  ( @CashierUserID,@CashierRoleId,1)
  INSERT INTO cps..tbl_upm_UserInherit
		        ( UserId, SourceType, UpdatedUserId ) VALUES (@CashierUserId,1,1),(@CashierUserId,2,1),(@CashierUserId,4,1)
  
 
  INSERT INTO cps..tbl_upm_Role
          ( RoleName ,
            Description ,
            CreatedUserId ,
            UpdatedUserId
          )
  VALUES(@ISOName+' Supervisor Role','',@SuperAdminId,'')

  SET @SupervisorRoleId=IDENT_CURRENT('cps..tbl_upm_Role')

  INSERT INTO cps..tbl_upm_PermissionToRole
          ( RoleId ,
            PermissionId ,
            IsGranted ,
            UpdatedUserId
          )
  SELECT @SupervisorRoleId,PermissionId,IsGranted,1 FROM tbl_upm_PermissionToRole WHERE RoleId=11
 
  SET @SupervisorName=@ISOName+'SupervisorParent'
  SET @SupervisorFirstName=@ISOName+' Supervisor'
  EXEC usp_upm_InsertUser @SupervisorUserId OUTPUT,@SuperAdminId,2,@SupervisorName,@SupervisorFirstName,'Parent','','Password0',@AddressId,@IsoId,1,1,'',null 

  INSERT INTO cps..tbl_upm_UserToRole
			( UserId, RoleId, UpdatedUserId )
			VALUES  ( @SupervisorUserId,@SupervisorRoleId,1)
  INSERT INTO cps..tbl_upm_UserInherit
		        ( UserId, SourceType, UpdatedUserId ) VALUES (@SupervisorUserId,1,1),(@SupervisorUserId,2,1),(@SupervisorUserId,4,1)
  
  INSERT INTO cps..tbl_upm_Role
          ( RoleName ,
            Description ,
            CreatedUserId ,
            UpdatedUserId
          )
  VALUES(@ISOName+' Audit Role','',@SuperAdminId,'')

  SET @AuditRoleId=IDENT_CURRENT('cps..tbl_upm_Role')

  INSERT INTO cps..tbl_upm_PermissionToRole
          ( RoleId ,
            PermissionId ,
            IsGranted ,
            UpdatedUserId
          )
  SELECT @AuditRoleId,PermissionId,IsGranted,1 FROM tbl_upm_PermissionToRole WHERE RoleId=15
 
  SET @AuditName=@ISOName+'AuditParent'
  SET @AuditFirstName=@ISOName+' Audit'
  EXEC usp_upm_InsertUser @AuditUserId OUTPUT,@SuperAdminId,2,@AuditName,@AuditFirstName,'Parent','','Password0',@AddressId,@IsoId,1,1,'',null 

  INSERT INTO cps..tbl_upm_UserToRole
			( UserId, RoleId, UpdatedUserId )
			VALUES  ( @AuditUserId,@AuditRoleId,1)
  INSERT INTO cps..tbl_upm_UserInherit
		        ( UserId, SourceType, UpdatedUserId ) VALUES (@AuditUserId,1,1),(@AuditUserId,2,1),(@AuditUserId,4,1)

  INSERT INTO cps..tbl_upm_Role
          ( RoleName ,
            Description ,
            CreatedUserId ,
            UpdatedUserId
          )
  VALUES(@ISOName+' Admin Role','',@SuperAdminId,'')

  SET @AdminRoleId=IDENT_CURRENT('cps..tbl_upm_Role')

  INSERT INTO cps..tbl_upm_PermissionToRole
          ( RoleId ,
            PermissionId ,
            IsGranted ,
            UpdatedUserId
          )
  SELECT @AdminRoleId,PermissionId,IsGranted,1 FROM tbl_upm_PermissionToRole WHERE RoleId=35
 
  SET @AdminName=@ISOName+'AdminParent'
  SET @AdminFirstName=@ISOName+' Admin'
  EXEC usp_upm_InsertUser @AdminUserId OUTPUT,@SuperAdminId,2,@AdminName,@AdminFirstName,'Parent','','Password0',@AddressId,@IsoId,1,1,'',null 

  INSERT INTO cps..tbl_upm_UserToRole
			( UserId, RoleId, UpdatedUserId )
			VALUES  ( @AdminUserId,@AdminRoleId,1)
  INSERT INTO cps..tbl_upm_UserInherit
		        ( UserId, SourceType, UpdatedUserId ) VALUES (@AdminUserId,1,1),(@AdminUserId,2,1),(@AdminUserId,4,1)




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
				PRINT 'UserName:'+LEFT(LTRIM(@Firstname),1)+LTRIM(RTRIM(@LastName))+' exists, has to Change as '+LTRIM(RTRIM(@Firstname))+LTRIM(RTRIM(@LastName))+' !'
				END
				   ELSE IF NOT EXISTS (select id from cps..tbl_upm_user where UserName=LTRIM(RTRIM(@Firstname))+LTRIM(RTRIM(@LastName))+'1')
					 BEGIN 
					   SET @UserName=LTRIM(RTRIM(@Firstname))+LTRIM(RTRIM(@LastName))+'1'
					   PRINT 'UserName:'+LTRIM(RTRIM(@Firstname))+LTRIM(RTRIM(@LastName))+' exists, have to Change as '+LTRIM(RTRIM(@Firstname))+LTRIM(RTRIM(@LastName))+'1 !'
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
				PRINT 'UserName:'+LTRIM(RTRIM(@NewUserName))+' exists, has to Change as '+LEFT(LTRIM(@Firstname),1)+LTRIM(RTRIM(@LastName))+' !'
				END
				ELSE IF NOT EXISTS (select id from tbl_upm_user where UserName=LTRIM(RTRIM(@Firstname))+LTRIM(RTRIM(@LastName)))
				BEGIN
				SET @UserName=LTRIM(RTRIM(@Firstname))+LTRIM(RTRIM(@LastName))
				PRINT 'UserName:'+LEFT(LTRIM(@Firstname),1)+LTRIM(RTRIM(@LastName))+' exists, has to Change as '+LTRIM(RTRIM(@Firstname))+LTRIM(RTRIM(@LastName))+' !'
				END
				   ELSE IF NOT EXISTS (select id from cps..tbl_upm_user where UserName=LTRIM(RTRIM(@Firstname))+LTRIM(RTRIM(@LastName))+'1')
					 BEGIN 
					   SET @UserName=LTRIM(RTRIM(@Firstname))+LTRIM(RTRIM(@LastName))+'1'
					   PRINT 'UserName:'+LTRIM(RTRIM(@Firstname))+LTRIM(RTRIM(@LastName))+' exists, have to Change as '+LTRIM(RTRIM(@Firstname))+LTRIM(RTRIM(@LastName))+'1 !'
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
        Delete FROM tbl_upm_NewUserImport WHERE Id=@NewUserId
      Nextuser:
      FETCH NEXT FROM TempCursor INTO @NewUserId,@UserType,@FirstName,@LastName,@MiddleInitial,@NewUserName
      END
      CLOSE TempCursor
      DEALLOCATE TempCursor
END
GO
