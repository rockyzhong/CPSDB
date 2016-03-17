SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[usp_upm_Importv3SlightlineUsers]
-- make sure the mid roleid addressid have already created on v4
-- after migration check the username list and backup oldusertable 
@Mid                 nvarchar(50),
@IsoId               BIGINT,
@ParentId            BIGINT,
@MigaddId            BIGINT,
@ISOName             nvarchar(50)
AS
BEGIN
  SET NOCOUNT ON
    -----------   create roles and admin users for new import subusers ----------

   DECLARE @AgentRoleId BIGINT,@SupervisorRoleId BIGINT,@LeadRoleId BIGINT,@ReportRoleId BIGINT,@AdminRoleId BIGINT,@MG1 BIGINT,@MG2 BIGINT,
   @MG3 BIGINT,@MG4 BIGINT,@MG5 BIGINT,@MG6 BIGINT,@AgentRoleAdminId BIGINT, @SupervisorRoleAdminId BIGINT, @LeadRoleAdminId BIGINT,
   @ReportViewerRoleAdminId BIGINT,@AdminRoleAdminId BIGINT,@MG1RoleAdminId BIGINT,@MG2RoleAdminId BIGINT,@MG3RoleAdminId BIGINT,
   @MG4RoleAdminId BIGINT,@MG5RoleAdminId BIGINT,@MG6RoleAdminId BIGINT,@NewaddId BIGINT

   IF EXISTS(SELECT sy.Username FROM ecage.dbo.SightlineUserList sy  WHERE Mid=@mid AND ROLE='Merchant Agent' )
   BEGIN
   INSERT INTO cps..tbl_upm_Role
          ( RoleName ,
            Description ,
            CreatedUserId ,
            UpdatedUserId
          )
  SELECT  @ISOName+' Cashier Role','',@ParentId,'' FROM CPS..tbl_iso WHERE id=@IsoID

  SET @AgentRoleId=IDENT_CURRENT('cps..tbl_upm_Role')

  INSERT INTO [CPS].[dbo].[tbl_Address]
           (
			[RegionId]			
		   ,[City]
           ,[AddressLine1]
           ,[AddressLine2]
           ,[PostalCode]
           ,[Telephone1]
           ,[Extension1]
           ,[Telephone2]
           ,[Extension2]
           ,[Telephone3]
           ,[Extension3]
           ,[Fax]
           ,[Email]
           ,[UpdatedUserId]
           )
	  SELECT RegionId,City,AddressLine1,AddressLine2,PostalCode,Telephone1,Extension1,Telephone2,Extension2,Telephone3,Extension3,Fax,Email,1 FROM cps.dbo.tbl_Address
	  WHERE Id=@MigaddId
	  SET @NewaddId=IDENT_CURRENT('cps..tbl_Address')
  INSERT INTO cps.dbo.tbl_upm_user([UserType]
      ,[UserName]
      ,[FirstName]
      ,[LastName]
      ,[MiddleInitial]
      ,[Password]
      ,[PasswordExpiryDate]
      ,[PasswordChangeDate]
      ,[LockoutDate]
      ,[LockCount]
      ,[ParentId]
      ,[AddressId]
      ,[IsoId]
      ,[UserStatus]
      ,[UpdatedUserId]
	  ,[BADGENAME])  
	  select 2, @ISOName+'CashierParent',@ISOName+'Cashier','Parent','','Password0',DATEADD(dd,60,GETUTCDATE()),GETUTCDATE(),null,null,@ParentId,@NewaddId,@IsoId,1,1,'' from CPS..tbl_iso
	  where id=@IsoId
  SET @AgentRoleAdminId=IDENT_CURRENT('cps..tbl_upm_User')

  INSERT INTO cps..tbl_upm_UserToRole
			( UserId, RoleId, UpdatedUserId )
			VALUES  ( @AgentRoleAdminId,  
			@AgentRoleId,
			1)
  INSERT INTO cps..tbl_upm_UserInherit
		        ( UserId, SourceType, UpdatedUserId ) VALUES (@AgentRoleAdminId,1,1),(@AgentRoleAdminId,2,1),(@AgentRoleAdminId,4,1)
  INSERT INTO cps..tbl_upm_PermissionToUser
          ( UserId ,
            PermissionId ,
            IsGranted ,
            UpdatedUserId
          )
  VALUES  ( @AgentRoleAdminId,1001,1,1), ( @AgentRoleAdminId,1002,1,1), ( @AgentRoleAdminId,1003,1,1)
  END
  IF EXISTS(SELECT sy.Username FROM ecage.dbo.SightlineUserList sy  WHERE Mid=@mid AND ROLE='Merchant Supervisor' )
  BEGIN
  INSERT INTO cps..tbl_upm_Role
          ( RoleName ,
            Description ,
            CreatedUserId ,
            UpdatedUserId
          )
  SELECT  @ISOName+' Supervisor Role','',@ParentId,'' FROM CPS..tbl_iso WHERE id=@IsoID

  SET @SupervisorRoleId=IDENT_CURRENT('cps..tbl_upm_Role')

  INSERT INTO [CPS].[dbo].[tbl_Address]
           (
			[RegionId]			
		   ,[City]
           ,[AddressLine1]
           ,[AddressLine2]
           ,[PostalCode]
           ,[Telephone1]
           ,[Extension1]
           ,[Telephone2]
           ,[Extension2]
           ,[Telephone3]
           ,[Extension3]
           ,[Fax]
           ,[Email]
           ,[UpdatedUserId]
           )
	  SELECT RegionId,City,AddressLine1,AddressLine2,PostalCode,Telephone1,Extension1,Telephone2,Extension2,Telephone3,Extension3,Fax,Email,1 FROM cps.dbo.tbl_Address
	  WHERE Id=@MigaddId
	  SET @NewaddId=IDENT_CURRENT('cps..tbl_Address')
  INSERT INTO cps.dbo.tbl_upm_user([UserType]
      ,[UserName]
      ,[FirstName]
      ,[LastName]
      ,[MiddleInitial]
      ,[Password]
      ,[PasswordExpiryDate]
      ,[PasswordChangeDate]
      ,[LockoutDate]
      ,[LockCount]
      ,[ParentId]
      ,[AddressId]
      ,[IsoId]
      ,[UserStatus]
      ,[UpdatedUserId]
	  ,[BADGENAME])  
	  select 2, @ISOName+'SupervisorParent',@ISOName+'Supervisor','Parent','','Password0',DATEADD(dd,60,GETUTCDATE()),GETUTCDATE(),null,null,@ParentId,@NewaddId,@IsoId,1,1,'' from CPS..tbl_iso
	  where id=@IsoId
  SET @SupervisorRoleAdminId=IDENT_CURRENT('cps..tbl_upm_User')

  INSERT INTO cps..tbl_upm_UserToRole
			( UserId, RoleId, UpdatedUserId )
			VALUES  ( @SupervisorRoleAdminId,  
			@SupervisorRoleId,
			1)
  INSERT INTO cps..tbl_upm_UserInherit
		        ( UserId, SourceType, UpdatedUserId ) VALUES (@SupervisorRoleAdminId,1,1),(@SupervisorRoleAdminId,2,1),(@SupervisorRoleAdminId,4,1)
  INSERT INTO cps..tbl_upm_PermissionToUser
          ( UserId ,
            PermissionId ,
            IsGranted ,
            UpdatedUserId
          )
  VALUES  ( @SupervisorRoleAdminId,1001,1,1), ( @SupervisorRoleAdminId,1002,1,1), ( @SupervisorRoleAdminId,1003,1,1)
  END
  IF EXISTS(SELECT sy.Username FROM ecage.dbo.SightlineUserList sy  WHERE Mid=@mid AND ROLE='Merchant Lead' )
  BEGIN
  INSERT INTO cps..tbl_upm_Role
          ( RoleName ,
            Description ,
            CreatedUserId ,
            UpdatedUserId
          )
  SELECT  @ISOName+' Lead Role','',@ParentId,'' FROM CPS..tbl_iso WHERE id=@IsoID

  SET @LeadRoleId=IDENT_CURRENT('cps..tbl_upm_Role')
  INSERT INTO [CPS].[dbo].[tbl_Address]
           (
			[RegionId]			
		   ,[City]
           ,[AddressLine1]
           ,[AddressLine2]
           ,[PostalCode]
           ,[Telephone1]
           ,[Extension1]
           ,[Telephone2]
           ,[Extension2]
           ,[Telephone3]
           ,[Extension3]
           ,[Fax]
           ,[Email]
           ,[UpdatedUserId]
           )
	  SELECT RegionId,City,AddressLine1,AddressLine2,PostalCode,Telephone1,Extension1,Telephone2,Extension2,Telephone3,Extension3,Fax,Email,1 FROM cps.dbo.tbl_Address
	  WHERE Id=@MigaddId
	  SET @NewaddId=IDENT_CURRENT('cps..tbl_Address')
  INSERT INTO cps.dbo.tbl_upm_user([UserType]
      ,[UserName]
      ,[FirstName]
      ,[LastName]
      ,[MiddleInitial]
      ,[Password]
      ,[PasswordExpiryDate]
      ,[PasswordChangeDate]
      ,[LockoutDate]
      ,[LockCount]
      ,[ParentId]
      ,[AddressId]
      ,[IsoId]
      ,[UserStatus]
      ,[UpdatedUserId]
	  ,[BADGENAME])  
	  select 2, @ISOName+'LeadParent',@ISOName+'Lead','Parent','','Password0',DATEADD(dd,60,GETUTCDATE()),GETUTCDATE(),null,null,@ParentId,@NewaddId,@IsoId,1,1,'' from CPS..tbl_iso
	  where id=@IsoId
  SET @LeadRoleAdminId=IDENT_CURRENT('cps..tbl_upm_User')

  INSERT INTO cps..tbl_upm_UserToRole
			( UserId, RoleId, UpdatedUserId )
			VALUES  ( @LeadRoleAdminId,  
			@LeadRoleId,
			1)
  INSERT INTO cps..tbl_upm_UserInherit
		        ( UserId, SourceType, UpdatedUserId ) VALUES (@LeadRoleAdminId,1,1),(@LeadRoleAdminId,2,1),(@LeadRoleAdminId,4,1)
  INSERT INTO cps..tbl_upm_PermissionToUser
          ( UserId ,
            PermissionId ,
            IsGranted ,
            UpdatedUserId
          )
  VALUES  ( @LeadRoleAdminId,1001,1,1), ( @LeadRoleAdminId,1002,1,1), ( @LeadRoleAdminId,1003,1,1)
  END
  IF EXISTS(SELECT sy.Username FROM ecage.dbo.SightlineUserList sy  WHERE Mid=@mid AND ROLE='Merchant Administrator' )
  BEGIN
  INSERT INTO cps..tbl_upm_Role
          ( RoleName ,
            Description ,
            CreatedUserId ,
            UpdatedUserId
          )
  SELECT  @ISOName+' Admin Role','',@ParentId,'' FROM CPS..tbl_iso WHERE id=@IsoID

  SET @AdminRoleId=IDENT_CURRENT('cps..tbl_upm_Role')

  INSERT INTO [CPS].[dbo].[tbl_Address]
           (
			[RegionId]			
		   ,[City]
           ,[AddressLine1]
           ,[AddressLine2]
           ,[PostalCode]
           ,[Telephone1]
           ,[Extension1]
           ,[Telephone2]
           ,[Extension2]
           ,[Telephone3]
           ,[Extension3]
           ,[Fax]
           ,[Email]
           ,[UpdatedUserId]
           )
	  SELECT RegionId,City,AddressLine1,AddressLine2,PostalCode,Telephone1,Extension1,Telephone2,Extension2,Telephone3,Extension3,Fax,Email,1 FROM cps.dbo.tbl_Address
	  WHERE Id=@MigaddId
	  SET @NewaddId=IDENT_CURRENT('cps..tbl_Address')
    INSERT INTO cps.dbo.tbl_upm_user([UserType]
      ,[UserName]
      ,[FirstName]
      ,[LastName]
      ,[MiddleInitial]
      ,[Password]
      ,[PasswordExpiryDate]
      ,[PasswordChangeDate]
      ,[LockoutDate]
      ,[LockCount]
      ,[ParentId]
      ,[AddressId]
      ,[IsoId]
      ,[UserStatus]
      ,[UpdatedUserId]
	  ,[BADGENAME])  
	  select 2, @ISOName+'AdminParent',@ISOName+'Admin','Parent','','Password0',DATEADD(dd,60,GETUTCDATE()),GETUTCDATE(),null,null,@ParentId,@NewaddId,@IsoId,1,1,'' from CPS..tbl_iso
	  where id=@IsoId
  SET @AdminRoleAdminId=IDENT_CURRENT('cps..tbl_upm_User')

  INSERT INTO cps..tbl_upm_UserToRole
			( UserId, RoleId, UpdatedUserId )
			VALUES  ( @AdminRoleAdminId,  
			@AdminRoleId,
			1)
  INSERT INTO cps..tbl_upm_UserInherit
		        ( UserId, SourceType, UpdatedUserId ) VALUES (@AdminRoleAdminId,1,1),(@AdminRoleAdminId,2,1),(@AdminRoleAdminId,4,1)
  END

  


  DECLARE @temprole TABLE (RoleId BIGINT,PermissionId BIGINT)
  IF @AgentRoleId IS NOT NULL
  BEGIN   
  INSERT INTO @temprole
	        (PermissionId, RoleId)
  SELECT DISTINCT(CASE PERMISSIONID WHEN 74 THEN 74 
  WHEN  75 THEN 114 WHEN 140 THEN 1002 WHEN 142 THEN 1001 WHEN 144 THEN 1003 WHEN 182
  THEN 182 WHEN 183 THEN 183 WHEN 185 THEN 185 WHEN 187 THEN 115 WHEN 190 THEN 190 WHEN 204
  THEN 114 WHEN 230 THEN 230 WHEN 231 THEN 231 WHEN 232 THEN 232 WHEN 252 THEN 252 WHEN 305
  THEN 305 WHEN 309 THEN 309 WHEN 311 THEN 311 WHEN 312 THEN 312 WHEN 320 THEN 320 WHEN 239
  THEN 114 WHEN 624 THEN 779 WHEN 626 THEN 253 WHEN 611 THEN 35 WHEN 612 THEN 37 WHEN 613 
  THEN 39 WHEN 614 THEN 41 WHEN 615 THEN 43 WHEN 616 THEN 45 WHEN 617 THEN 47 WHEN 618 
  THEN 49 WHEN 603 THEN 51 WHEN 601 THEN 53 WHEN 604 THEN 55 WHEN 602 THEN 57 WHEN 619
  THEN 59 WHEN 623 THEN 61 WHEN 622 THEN 63 WHEN 620 THEN 65 WHEN 621 THEN 67 END),@AgentRoleId FROM ecage..MERCHANTROLEPERMslightline WHERE Mid=@Mid AND RoleId=8

  IF EXISTS (SELECT * FROM @temprole WHERE PermissionId=231 AND RoleId=@AgentRoleId)
  INSERT INTO @temprole VALUES (@AgentRoleId,188)
  			INSERT INTO cps..tbl_upm_PermissionToRole
			( RoleId ,
			PermissionId ,
			IsGranted ,
			UpdatedUserId
			)
			SELECT @AgentRoleId,PermissionId,1,1 FROM @temprole WHERE RoleId=@AgentRoleId AND PermissionId IS NOT NULL AND PermissionId NOT IN (35,37,39,41,43,45,47,49,51,53,55,57,59,61,63,65,67)
	        INSERT INTO cps..tbl_upm_ObjectToUser
            ( UserId ,
            ObjectId ,
            IsGranted ,
            UpdatedUserId
            )
            SELECT @AgentRoleAdminId,Id,1,1 FROM cps..tbl_upm_Object WHERE SourceType=7  AND SourceId IN (SELECT PermissionId FROM @temprole WHERE RoleId=@AgentRoleId AND PermissionId IS NOT NULL 
			AND PermissionId IN (35,37,39,41,43,45,47,49,51,53,55,57,59,61,63,65,67))
  END
  IF @SupervisorRoleId IS NOT NULL
  BEGIN
  INSERT INTO @temprole
	        (PermissionId,RoleId)
  SELECT  DISTINCT(CASE PERMISSIONID WHEN 74 THEN 74 
  WHEN  75 THEN 114 WHEN 140 THEN 1002 WHEN 142 THEN 1001 WHEN 144 THEN 1003 WHEN 182
  THEN 182 WHEN 183 THEN 183 WHEN 185 THEN 185 WHEN 187 THEN 115 WHEN 190 THEN 190 WHEN 204
  THEN 114 WHEN 230 THEN 230 WHEN 231 THEN 231 WHEN 232 THEN 232 WHEN 252 THEN 252 WHEN 305
  THEN 305 WHEN 309 THEN 309 WHEN 311 THEN 311 WHEN 312 THEN 312 WHEN 320 THEN 320 WHEN 239
  THEN 114 WHEN 624 THEN 779 WHEN 626 THEN 253 WHEN 611 THEN 35 WHEN 612 THEN 37 WHEN 613 
  THEN 39 WHEN 614 THEN 41 WHEN 615 THEN 43 WHEN 616 THEN 45 WHEN 617 THEN 47 WHEN 618 
  THEN 49 WHEN 603 THEN 51 WHEN 601 THEN 53 WHEN 604 THEN 55 WHEN 602 THEN 57 WHEN 619
  THEN 59 WHEN 623 THEN 61 WHEN 622 THEN 63 WHEN 620 THEN 65 WHEN 621 THEN 67 END),@SupervisorRoleId FROM ecage..MERCHANTROLEPERMslightline WHERE Mid=@Mid AND RoleId=6
  
  IF EXISTS (SELECT * FROM @temprole WHERE PermissionId=231 AND RoleId=@SupervisorRoleId)
  INSERT INTO @temprole VALUES (@SupervisorRoleId,188)

  			INSERT INTO cps..tbl_upm_PermissionToRole
			( RoleId ,
			PermissionId ,
			IsGranted ,
			UpdatedUserId
			)
			SELECT @SupervisorRoleId,PermissionId,1,1 FROM @temprole WHERE RoleId=@SupervisorRoleId AND PermissionId IS NOT NULL AND PermissionId NOT IN (35,37,39,41,43,45,47,49,51,53,55,57,59,61,63,65,67)
            INSERT INTO cps..tbl_upm_ObjectToUser
            ( UserId ,
            ObjectId ,
            IsGranted ,
            UpdatedUserId
            )
            SELECT @SupervisorRoleAdminId,Id,1,1 FROM cps..tbl_upm_Object WHERE SourceType=7  AND SourceId IN (SELECT PermissionId FROM @temprole WHERE RoleId=@SupervisorRoleId AND PermissionId IS NOT NULL 
			AND PermissionId IN (35,37,39,41,43,45,47,49,51,53,55,57,59,61,63,65,67))
  END
  IF @LeadRoleId IS NOT NULL
  BEGIN
  INSERT INTO @temprole
	        (PermissionId,RoleId)
  SELECT  DISTINCT(CASE PERMISSIONID WHEN 74 THEN 74 
  WHEN  75 THEN 114 WHEN 140 THEN 1002 WHEN 142 THEN 1001 WHEN 144 THEN 1003 WHEN 182
  THEN 182 WHEN 183 THEN 183 WHEN 185 THEN 185 WHEN 187 THEN 115 WHEN 190 THEN 190 WHEN 204
  THEN 114 WHEN 230 THEN 230 WHEN 231 THEN 231 WHEN 232 THEN 232 WHEN 252 THEN 252 WHEN 305
  THEN 305 WHEN 309 THEN 309 WHEN 311 THEN 311 WHEN 312 THEN 312 WHEN 320 THEN 320 WHEN 239
  THEN 114 WHEN 624 THEN 779 WHEN 626 THEN 253 WHEN 611 THEN 35 WHEN 612 THEN 37 WHEN 613 
  THEN 39 WHEN 614 THEN 41 WHEN 615 THEN 43 WHEN 616 THEN 45 WHEN 617 THEN 47 WHEN 618 
  THEN 49 WHEN 603 THEN 51 WHEN 601 THEN 53 WHEN 604 THEN 55 WHEN 602 THEN 57 WHEN 619
  THEN 59 WHEN 623 THEN 61 WHEN 622 THEN 63 WHEN 620 THEN 65 WHEN 621 THEN 67 END),@LeadRoleId FROM ecage..MERCHANTROLEPERMslightline WHERE Mid=@Mid AND RoleId=7
  
  IF EXISTS (SELECT * FROM @temprole WHERE PermissionId=231 AND RoleId=@LeadRoleId)
  
  INSERT INTO @temprole VALUES (@LeadRoleId,188)
  			INSERT INTO cps..tbl_upm_PermissionToRole
			( RoleId ,
			PermissionId ,
			IsGranted ,
			UpdatedUserId
			)
			SELECT @LeadRoleId,PermissionId,1,1 FROM @temprole WHERE RoleId=@LeadRoleId AND PermissionId IS NOT NULL AND PermissionId NOT IN (35,37,39,41,43,45,47,49,51,53,55,57,59,61,63,65,67)
            INSERT INTO cps..tbl_upm_ObjectToUser
            ( UserId ,
            ObjectId ,
            IsGranted ,
            UpdatedUserId
            )
            SELECT @LeadRoleAdminId,Id,1,1 FROM cps..tbl_upm_Object WHERE SourceType=7  AND SourceId IN (SELECT PermissionId FROM @temprole WHERE RoleId=@LeadRoleId AND PermissionId IS NOT NULL 
			AND PermissionId IN (35,37,39,41,43,45,47,49,51,53,55,57,59,61,63,65,67))
  END
  IF @AdminRoleId IS NOT NULL
  BEGIN
  INSERT INTO @temprole
	        (PermissionId,RoleId)
  SELECT  DISTINCT(CASE PERMISSIONID WHEN 74 THEN 74 
  WHEN  75 THEN 114 WHEN 140 THEN 1002 WHEN 142 THEN 1001 WHEN 144 THEN 1003 WHEN 182
  THEN 182 WHEN 183 THEN 183 WHEN 185 THEN 185 WHEN 187 THEN 115 WHEN 190 THEN 190 WHEN 204
  THEN 114 WHEN 230 THEN 230 WHEN 231 THEN 231 WHEN 232 THEN 232 WHEN 252 THEN 252 WHEN 305
  THEN 305 WHEN 309 THEN 309 WHEN 311 THEN 311 WHEN 312 THEN 312 WHEN 320 THEN 320 WHEN 239
  THEN 114 WHEN 624 THEN 779 WHEN 626 THEN 253 WHEN 611 THEN 35 WHEN 612 THEN 37 WHEN 613 
  THEN 39 WHEN 614 THEN 41 WHEN 615 THEN 43 WHEN 616 THEN 45 WHEN 617 THEN 47 WHEN 618 
  THEN 49 WHEN 603 THEN 51 WHEN 601 THEN 53 WHEN 604 THEN 55 WHEN 602 THEN 57 WHEN 619
  THEN 59 WHEN 623 THEN 61 WHEN 622 THEN 63 WHEN 620 THEN 65 WHEN 621 THEN 67 END),@AdminRoleId FROM ecage..MERCHANTROLEPERMslightline WHERE Mid=@Mid AND RoleId=5
  
  IF EXISTS (SELECT * FROM @temprole WHERE PermissionId=231 AND RoleId=@AdminRoleId)
  INSERT INTO @temprole VALUES (@AdminRoleId,188)

	INSERT INTO cps..tbl_upm_PermissionToRole
	( RoleId ,
	PermissionId ,
	IsGranted ,
	UpdatedUserId
	)
	SELECT @AdminRoleId,PermissionId,1,1 FROM @temprole WHERE RoleId=@AdminRoleId AND PermissionId IS NOT NULL AND PermissionId NOT IN (35,37,39,41,43,45,47,49,51,53,55,57,59,61,63,65,67)
    IF NOT EXISTS (SELECT id FROM cps..tbl_upm_PermissionToRole WHERE RoleId=@AdminRoleId AND PermissionId=1001)
	INSERT INTO cps..tbl_upm_PermissionToRole VALUES (@AdminRoleId,1001,1,1)
	IF NOT EXISTS (SELECT id FROM cps..tbl_upm_PermissionToRole WHERE RoleId=@AdminRoleId AND PermissionId=1002)
	INSERT INTO cps..tbl_upm_PermissionToRole VALUES (@AdminRoleId,1002,1,1)
	IF NOT EXISTS (SELECT id FROM cps..tbl_upm_PermissionToRole WHERE RoleId=@AdminRoleId AND PermissionId=1003)
	INSERT INTO cps..tbl_upm_PermissionToRole VALUES (@AdminRoleId,1003,1,1)
	IF NOT EXISTS (SELECT id FROM cps..tbl_upm_PermissionToRole WHERE RoleId=@AdminRoleId AND PermissionId=1004)
	INSERT INTO cps..tbl_upm_PermissionToRole VALUES (@AdminRoleId,1004,1,1)
	IF NOT EXISTS (SELECT id FROM cps..tbl_upm_PermissionToRole WHERE RoleId=@AdminRoleId AND PermissionId=1005)
	INSERT INTO cps..tbl_upm_PermissionToRole VALUES (@AdminRoleId,1005,1,1)
	IF NOT EXISTS (SELECT id FROM cps..tbl_upm_PermissionToRole WHERE RoleId=@AdminRoleId AND PermissionId=1006)
	INSERT INTO cps..tbl_upm_PermissionToRole VALUES (@AdminRoleId,1006,1,1)

	INSERT INTO cps..tbl_upm_ObjectToUser
	( UserId ,
	ObjectId ,
	IsGranted ,
	UpdatedUserId
	)
	SELECT @AdminRoleAdminId,Id,1,1 FROM cps..tbl_upm_Object WHERE SourceType=7  AND SourceId IN (SELECT PermissionId FROM @temprole WHERE RoleId=@AdminRoleId AND PermissionId IS NOT NULL 
	AND PermissionId IN (35,37,39,41,43,45,47,49,51,53,55,57,59,61,63,65,67))
   END 


------------------------  insert new users from ecagev3 ----------------------
------------------  if they need to user original username or not --------------	 
	insert into  cps..tbl_upm_User_OldSlightline   (UserName,OldUserId,OldRoleId,FirstName,LastName,Mid,MiddleInitial)
	select sy.USERNAME,sy.RowId,CASE sy.ROLE WHEN 'Merchant Administrator'THEN 5 WHEN 'Merchant Supervisor'THEN 6 WHEN 'Merchant Lead'THEN 7 WHEN 'Merchant Agent'THEN 8 END,sy.UserFirstName,sy.UserLastName,sy.MID,sy.UserMiddleInitial from ecage.dbo.SightlineUserList sy 
	WHERE sy.MID =@Mid

	DECLARE @OldRoleId BIGINT,@NewUserName nvarchar(50), @OldUserName NVARCHAR(30),@NewuserId BIGINT,@OlduserId BIGINT,@FirstName NVARCHAR(30),@LastName NVARCHAR(30),@Midini NVARCHAR(1)
    DECLARE TempCursor CURSOR LOCAL FOR SELECT olduserid,oldroleid,FirstName,LastName,UserName,MiddleInitial  FROM  cps..tbl_upm_User_OldSlightline  WHERE Mid=@Mid  ORDER BY  olduserid 
    OPEN TempCursor
    FETCH NEXT FROM TempCursor INTO @OlduserId,@OldRoleId,@FirstName,@LastName,@OldUserName,@Midini
      WHILE @@Fetch_Status=0
      BEGIN
	    IF NOT EXISTS (SELECT id FROM cps..tbl_upm_user where UserName=LTRIM(RTRIM(@OldUserName)))
		SET @NewUserName=@OldUserName
	    ELSE IF NOT EXISTS (select id from cps..tbl_upm_user where UserName=LEFT(LTRIM(@Firstname),1)+LTRIM(RTRIM(@LastName)))
	    BEGIN
		SET @NewUserName=LEFT(LTRIM(@Firstname),1)+LTRIM(RTRIM(@LastName))
		PRINT 'UserName:'+LTRIM(RTRIM(@OldUserName))+' exists, have to Change as '+LEFT(LTRIM(@Firstname),1)+LTRIM(RTRIM(@LastName))
		END
		ELSE IF NOT EXISTS (select id from cps..tbl_upm_user where UserName=LTRIM(RTRIM(@Firstname))+LTRIM(RTRIM(@LastName)))
		BEGIN 
		  SET @NewUserName=LTRIM(RTRIM(@Firstname))+LTRIM(RTRIM(@LastName))
	--	  UPDATE cps.dbo.tbl_upm_User_oldslightline SET UserName=@NewUserName WHERE olduserid=@OlduserId
          PRINT 'UserName:'+LEFT(LTRIM(@Firstname),1)+LTRIM(RTRIM(@LastName))+' exists, have to Change as '+LTRIM(RTRIM(@Firstname))+LTRIM(RTRIM(@LastName))+' !'
		END 
		     ELSE IF NOT EXISTS (select id from cps..tbl_upm_user where UserName=LTRIM(RTRIM(@Firstname))+LTRIM(RTRIM(@LastName))+'1')
			 BEGIN 
		       SET @NewUserName=LTRIM(RTRIM(@Firstname))+LTRIM(RTRIM(@LastName))+'1'
	--	       UPDATE cps.dbo.tbl_upm_User_Old SET UserName=@NewUserName WHERE olduserid=@OlduserId
               PRINT 'UserName:'+LTRIM(RTRIM(@Firstname))+LTRIM(RTRIM(@LastName))+' exists, have to Change as '+LTRIM(RTRIM(@Firstname))+LTRIM(RTRIM(@LastName))+'1 !'
			 END
			   ELSE
 		         BEGIN
		         print 'UserName exists in V4!'
		         GOTO Nextuser
	             END
      
	  INSERT INTO [CPS].[dbo].[tbl_Address]
           (
			[RegionId]			
		   ,[City]
           ,[AddressLine1]
           ,[AddressLine2]
           ,[PostalCode]
           ,[Telephone1]
           ,[Extension1]
           ,[Telephone2]
           ,[Extension2]
           ,[Telephone3]
           ,[Extension3]
           ,[Fax]
           ,[Email]
           ,[UpdatedUserId]
           )
	  SELECT RegionId,City,AddressLine1,AddressLine2,PostalCode,Telephone1,Extension1,Telephone2,Extension2,Telephone3,Extension3,Fax,Email,1 FROM cps.dbo.tbl_Address
	  WHERE Id=@MigaddId
	  SET @NewaddId=IDENT_CURRENT('cps..tbl_Address')
      
	  INSERT into cps..tbl_upm_User ([UserType]
      ,[UserName]
      ,[FirstName]
      ,[LastName]
      ,[MiddleInitial]
      ,[Password]
      ,[PasswordExpiryDate]
      ,[PasswordChangeDate]
      ,[LockoutDate]
      ,[LockCount]
      ,[ParentId]
      ,[AddressId]
      ,[IsoId]
      ,[UserStatus]
      ,[UpdatedUserId]
	  ,[BADGENAME])  
	  VALUES(2, UPPER(@NewUserName),@FIRSTNAME,@LastName,@Midini,'Password1',DATEADD(dd,60,GETUTCDATE()),GETUTCDATE(),null,null,@ParentId,@NewaddId,@IsoId,1,1,'')
	 
	  ----------------- assign role and report to new users -------------------
	  SELECT @NewuserId=IDENT_CURRENT('cps..tbl_upm_user')

	  INSERT dbo.tbl_upm_Object(SourceId,SourceType,CreatedUserId) VALUES(@NewuserId,2,1)
	  IF @OldRoleId=5 
	     BEGIN
			INSERT INTO cps..tbl_upm_UserToRole
			( UserId, RoleId, UpdatedUserId )
			VALUES  ( @NewuserId,  
			@AdminRoleId,
			1)
			UPDATE cps..tbl_upm_User SET ParentId=@AdminRoleAdminId WHERE Id=@NewuserId
		END
	  IF @OldRoleId =6
	    BEGIN
			INSERT INTO cps..tbl_upm_UserToRole
			( UserId, RoleId, UpdatedUserId )
			VALUES  ( @NewuserId,  
			@SupervisorRoleId,
			1)
			UPDATE cps..tbl_upm_User SET ParentId=@SupervisorRoleAdminId WHERE Id=@NewuserId
		END
	  IF @OldRoleId =7
	    BEGIN
			INSERT INTO cps..tbl_upm_UserToRole
			( UserId, RoleId, UpdatedUserId )
			VALUES  ( @NewuserId,  
			@LeadRoleId,
			1)
			UPDATE cps..tbl_upm_User SET ParentId=@LeadRoleAdminId WHERE Id=@NewuserId
		END
	  IF @OldRoleId=8
	  	BEGIN
			INSERT INTO cps..tbl_upm_UserToRole
			( UserId, RoleId, UpdatedUserId )
			VALUES  ( @NewuserId,  
			@AgentRoleId,
			1)
			UPDATE cps..tbl_upm_User SET ParentId=@AgentRoleAdminId WHERE Id=@NewuserId
	    END
     IF @OldRoleId=14
	 	BEGIN
			INSERT INTO cps..tbl_upm_UserToRole
			( UserId, RoleId, UpdatedUserId )
			VALUES  ( @NewuserId,  
			@ReportRoleId,
			1)
			UPDATE cps..tbl_upm_User SET ParentId=@ReportViewerRoleAdminId WHERE Id=@NewuserId
		END 


  ----------------------   inherit setting ------------------------
		INSERT INTO cps..tbl_upm_UserInherit
		        ( UserId, SourceType, UpdatedUserId ) VALUES (@NewuserId,1,1),(@NewuserId,2,1),(@NewuserId,4,1),(@NewuserId,7,1)
		 
      Nextuser:
	   FETCH NEXT FROM TempCursor INTO @OlduserId,@OldRoleId,@FirstName,@LastName,@OldUserName,@Midini
      END
      CLOSE TempCursor
      DEALLOCATE TempCursor 
   
END

 
GO
