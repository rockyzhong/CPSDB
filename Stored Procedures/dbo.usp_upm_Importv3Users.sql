SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_upm_Importv3Users]
-- make sure the mid roleid addressid have already created on v4
-- after migration check the username list and backup oldusertable 
@Mid                 nvarchar(50),
@IsoId               BIGINT,
@ParentId            BIGINT,
@MigaddId            BIGINT

AS
BEGIN
  SET NOCOUNT ON
    -----------   create roles and admin users for new import subusers ----------

   DECLARE @AgentRoleId BIGINT,@SupervisorRoleId BIGINT,@LeadRoleId BIGINT,@ReportRoleId BIGINT,@AdminRoleId BIGINT,@MG1 BIGINT,@MG2 BIGINT,
   @MG3 BIGINT,@MG4 BIGINT,@MG5 BIGINT,@MG6 BIGINT,@AgentRoleAdminId BIGINT, @SupervisorRoleAdminId BIGINT, @LeadRoleAdminId BIGINT,
   @ReportViewerRoleAdminId BIGINT,@AdminRoleAdminId BIGINT,@MG1RoleAdminId BIGINT,@MG2RoleAdminId BIGINT,@MG3RoleAdminId BIGINT,
   @MG4RoleAdminId BIGINT,@MG5RoleAdminId BIGINT,@MG6RoleAdminId BIGINT,@NewaddId BIGINT

   IF EXISTS(SELECT USERID FROM ecage..USERROLE WHERE Mid=@mid AND ROLEID=8 )
   BEGIN
   INSERT INTO cps..tbl_upm_Role
          ( RoleName ,
            Description ,
            CreatedUserId ,
            UpdatedUserId
          )
  SELECT  REPLACE(TradeName1,' ','')+' Cashier Role','',@ParentId,'' FROM CPS..tbl_iso WHERE id=@IsoID

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
	  select 2, REPLACE(TradeName1,' ','')+' Cashier Role Admin',REPLACE(TradeName1,' ',''),' Cashier Role Admin','','Password0',DATEADD(dd,60,GETUTCDATE()),GETUTCDATE(),null,null,@ParentId,@NewaddId,@IsoId,1,1,'' from CPS..tbl_iso
	  where id=@IsoId
  SET @AgentRoleAdminId=IDENT_CURRENT('cps..tbl_upm_User')

  INSERT dbo.tbl_upm_Object(SourceId,SourceType,CreatedUserId) VALUES(@AgentRoleAdminId,2,1)
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
  IF EXISTS(SELECT USERID FROM ecage..USERROLE WHERE Mid=@mid AND ROLEID=6 )
  BEGIN
  INSERT INTO cps..tbl_upm_Role
          ( RoleName ,
            Description ,
            CreatedUserId ,
            UpdatedUserId
          )
  SELECT  REPLACE(TradeName1,' ','')+' Supervisor Role','',@ParentId,'' FROM CPS..tbl_iso WHERE id=@IsoID

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
	  select 2, REPLACE(TradeName1,' ','')+' Supervisor Role Admin',REPLACE(TradeName1,' ',''),' Supervisor Role Admin','','Password0',DATEADD(dd,60,GETUTCDATE()),GETUTCDATE(),null,null,@ParentId,@NewaddId,@IsoId,1,1,'' from CPS..tbl_iso
	  where id=@IsoId
  SET @SupervisorRoleAdminId=IDENT_CURRENT('cps..tbl_upm_User')

  INSERT dbo.tbl_upm_Object(SourceId,SourceType,CreatedUserId) VALUES(@SupervisorRoleAdminId,2,1)
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

  IF EXISTS(SELECT USERID FROM ecage..USERROLE WHERE Mid=@mid AND ROLEID=7 )
  BEGIN
  INSERT INTO cps..tbl_upm_Role
          ( RoleName ,
            Description ,
            CreatedUserId ,
            UpdatedUserId
          )
  SELECT  REPLACE(TradeName1,' ','')+' Lead Role','',@ParentId,'' FROM CPS..tbl_iso WHERE id=@IsoID

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
	  select 2, REPLACE(TradeName1,' ','')+' LeadRole Admin',REPLACE(TradeName1,' ',''),' LeadRole Admin','','Password0',DATEADD(dd,60,GETUTCDATE()),GETUTCDATE(),null,null,@ParentId,@NewaddId,@IsoId,1,1,'' from CPS..tbl_iso
	  where id=@IsoId
  SET @LeadRoleAdminId=IDENT_CURRENT('cps..tbl_upm_User')

  INSERT dbo.tbl_upm_Object(SourceId,SourceType,CreatedUserId) VALUES(@LeadRoleAdminId,2,1)
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

  IF EXISTS(SELECT USERID FROM ecage..USERROLE WHERE Mid=@mid AND ROLEID=14 )
  BEGIN
  INSERT INTO cps..tbl_upm_Role
          ( RoleName ,
            Description ,
            CreatedUserId ,
            UpdatedUserId
          )
  SELECT  REPLACE(TradeName1,' ','')+' ReportViewer Role','',@ParentId,'' FROM CPS..tbl_iso WHERE id=@IsoID

  SET @ReportRoleId=IDENT_CURRENT('cps..tbl_upm_Role')
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
	  select 2, REPLACE(TradeName1,' ','')+' ReportViewerRole Admin',REPLACE(TradeName1,' ',''),' ReportViewerRole Admin','','Password0',DATEADD(dd,60,GETUTCDATE()),GETUTCDATE(),null,null,@ParentId,@NewaddId,@IsoId,1,1,'' from CPS..tbl_iso
	  where id=@IsoId
  SET @ReportViewerRoleAdminId=IDENT_CURRENT('cps..tbl_upm_User')

  INSERT dbo.tbl_upm_Object(SourceId,SourceType,CreatedUserId) VALUES(@ReportViewerRoleAdminId,2,1)
  INSERT INTO cps..tbl_upm_UserToRole
			( UserId, RoleId, UpdatedUserId )
			VALUES  ( @ReportViewerRoleAdminId,  
			@ReportRoleId,
			1)
  INSERT INTO cps..tbl_upm_UserInherit
		        ( UserId, SourceType, UpdatedUserId ) VALUES (@ReportViewerRoleAdminId,1,1),(@ReportViewerRoleAdminId,2,1),(@ReportViewerRoleAdminId,4,1)
  INSERT INTO cps..tbl_upm_PermissionToUser
          ( UserId ,
            PermissionId ,
            IsGranted ,
            UpdatedUserId
          )
  VALUES  ( @ReportViewerRoleAdminId,1001,1,1), ( @ReportViewerRoleAdminId,1002,1,1), ( @ReportViewerRoleAdminId,1003,1,1)
  END
  
  IF EXISTS(SELECT USERID FROM ecage..USERROLE WHERE Mid=@mid AND ROLEID=5 )
  BEGIN
  INSERT INTO cps..tbl_upm_Role
          ( RoleName ,
            Description ,
            CreatedUserId ,
            UpdatedUserId
          )
  SELECT  REPLACE(TradeName1,' ','')+' Admin Role','',@ParentId,'' FROM CPS..tbl_iso WHERE id=@IsoID

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
	  select 2, REPLACE(TradeName1,' ','')+' AdminRole Admin',REPLACE(TradeName1,' ',''),' AdminRole Admin','','Password0',DATEADD(dd,60,GETUTCDATE()),GETUTCDATE(),null,null,@ParentId,@NewaddId,@IsoId,1,1,'' from CPS..tbl_iso
	  where id=@IsoId
  SET @AdminRoleAdminId=IDENT_CURRENT('cps..tbl_upm_User')

  INSERT dbo.tbl_upm_Object(SourceId,SourceType,CreatedUserId) VALUES(@AdminRoleAdminId,2,1)
  INSERT INTO cps..tbl_upm_UserToRole
			( UserId, RoleId, UpdatedUserId )
			VALUES  ( @AdminRoleAdminId,  
			@AdminRoleId,
			1)
  INSERT INTO cps..tbl_upm_UserInherit
		        ( UserId, SourceType, UpdatedUserId ) VALUES (@AdminRoleAdminId,1,1),(@AdminRoleAdminId,2,1),(@AdminRoleAdminId,4,1)
  END
  IF @Mid='0000380353'
  BEGIN
  INSERT INTO cps..tbl_upm_Role
          ( RoleName ,
            Description ,
            CreatedUserId ,
            UpdatedUserId
          )
  SELECT  REPLACE(TradeName1,' ','')+' Group1 Role','',@ParentId,'' FROM CPS..tbl_iso WHERE id=@IsoID
  SET @MG1=IDENT_CURRENT('cps..tbl_upm_Role')
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
	  select 2, REPLACE(TradeName1,' ','')+' Group1Role Admin',REPLACE(TradeName1,' ',''),' Group1Role Admin','','Password0',DATEADD(dd,60,GETUTCDATE()),GETUTCDATE(),null,null,@ParentId,@NewaddId,@IsoId,1,1,'' from CPS..tbl_iso
	  where id=@IsoId
  SET @MG1RoleAdminId=IDENT_CURRENT('cps..tbl_upm_User')

  INSERT dbo.tbl_upm_Object(SourceId,SourceType,CreatedUserId) VALUES(@MG1RoleAdminId,2,1)
  INSERT INTO cps..tbl_upm_UserToRole
			( UserId, RoleId, UpdatedUserId )
			VALUES  ( @MG1RoleAdminId,  
			@MG1,
			1)
  INSERT INTO cps..tbl_upm_UserInherit
		        ( UserId, SourceType, UpdatedUserId ) VALUES (@MG1RoleAdminId,1,1),(@MG1RoleAdminId,2,1),(@MG1RoleAdminId,4,1)

  INSERT INTO cps..tbl_upm_Role
          ( RoleName ,
            Description ,
            CreatedUserId ,
            UpdatedUserId
          )
  SELECT  REPLACE(TradeName1,' ','')+' Group2 Role','',@ParentId,'' FROM CPS..tbl_iso WHERE id=@IsoID
  SET @MG2=IDENT_CURRENT('cps..tbl_upm_Role')
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
	  select 2, REPLACE(TradeName1,' ','')+' Group2Role Admin',REPLACE(TradeName1,' ',''),' Group2Role Admin','','Password0',DATEADD(dd,60,GETUTCDATE()),GETUTCDATE(),null,null,@ParentId,@NewaddId,@IsoId,1,1,'' from CPS..tbl_iso
	  where id=@IsoId
  SET @MG2RoleAdminId=IDENT_CURRENT('cps..tbl_upm_User')

  INSERT dbo.tbl_upm_Object(SourceId,SourceType,CreatedUserId) VALUES(@MG2RoleAdminId,2,1)
  INSERT INTO cps..tbl_upm_UserToRole
			( UserId, RoleId, UpdatedUserId )
			VALUES  ( @MG2RoleAdminId,  
			@MG2,
			1)
  INSERT INTO cps..tbl_upm_UserInherit
		        ( UserId, SourceType, UpdatedUserId ) VALUES (@MG2RoleAdminId,1,1),(@MG2RoleAdminId,2,1),(@MG2RoleAdminId,4,1)


  INSERT INTO cps..tbl_upm_Role
          ( RoleName ,
            Description ,
            CreatedUserId ,
            UpdatedUserId
          )
  SELECT  REPLACE(TradeName1,' ','')+' Group3 Role','',@ParentId,'' FROM CPS..tbl_iso WHERE id=@IsoID
  SET @MG3=IDENT_CURRENT('cps..tbl_upm_Role')
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
	  select 2, REPLACE(TradeName1,' ','')+' Group3Role Admin',REPLACE(TradeName1,' ',''),' Group3Role Admin','','Password0',DATEADD(dd,60,GETUTCDATE()),GETUTCDATE(),null,null,@ParentId,@NewaddId,@IsoId,1,1,'' from CPS..tbl_iso
	  where id=@IsoId
  SET @MG3RoleAdminId=IDENT_CURRENT('cps..tbl_upm_User')

  INSERT dbo.tbl_upm_Object(SourceId,SourceType,CreatedUserId) VALUES(@MG3RoleAdminId,2,1)
  INSERT INTO cps..tbl_upm_UserToRole
			( UserId, RoleId, UpdatedUserId )
			VALUES  ( @MG3RoleAdminId,  
			@MG3,
			1)
  INSERT INTO cps..tbl_upm_UserInherit
		        ( UserId, SourceType, UpdatedUserId ) VALUES (@MG3RoleAdminId,1,1),(@MG3RoleAdminId,2,1),(@MG3RoleAdminId,4,1)

  INSERT INTO cps..tbl_upm_Role
          ( RoleName ,
            Description ,
            CreatedUserId ,
            UpdatedUserId
          )
  SELECT  REPLACE(TradeName1,' ','')+' Group4 Role','',@ParentId,'' FROM CPS..tbl_iso WHERE id=@IsoID
  SET @MG4=IDENT_CURRENT('cps..tbl_upm_Role')
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
	  select 2, REPLACE(TradeName1,' ','')+' Group4Role Admin',REPLACE(TradeName1,' ',''),' Group4Role Admin','','Password0',DATEADD(dd,60,GETUTCDATE()),GETUTCDATE(),null,null,@ParentId,@NewaddId,@IsoId,1,1,'' from CPS..tbl_iso
	  where id=@IsoId
  SET @MG4RoleAdminId=IDENT_CURRENT('cps..tbl_upm_User')

  INSERT dbo.tbl_upm_Object(SourceId,SourceType,CreatedUserId) VALUES(@MG4RoleAdminId,2,1)
  INSERT INTO cps..tbl_upm_UserToRole
			( UserId, RoleId, UpdatedUserId )
			VALUES  ( @MG4RoleAdminId,  
			@MG4,
			1)
  INSERT INTO cps..tbl_upm_UserInherit
		        ( UserId, SourceType, UpdatedUserId ) VALUES (@MG4RoleAdminId,1,1),(@MG4RoleAdminId,2,1),(@MG4RoleAdminId,4,1)

  INSERT INTO cps..tbl_upm_Role
          ( RoleName ,
            Description ,
            CreatedUserId ,
            UpdatedUserId
          )
  SELECT  REPLACE(TradeName1,' ','')+' Group5 Role','',@ParentId,'' FROM CPS..tbl_iso WHERE id=@IsoID
  SET @MG5=IDENT_CURRENT('cps..tbl_upm_Role')
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
	  select 2, REPLACE(TradeName1,' ','')+' Group5Role Admin',REPLACE(TradeName1,' ',''),' Group5Role Admin','','Password0',DATEADD(dd,60,GETUTCDATE()),GETUTCDATE(),null,null,@ParentId,@NewaddId,@IsoId,1,1,'' from CPS..tbl_iso
	  where id=@IsoId
  SET @MG5RoleAdminId=IDENT_CURRENT('cps..tbl_upm_User')

  INSERT dbo.tbl_upm_Object(SourceId,SourceType,CreatedUserId) VALUES(@MG5RoleAdminId,2,1)
  INSERT INTO cps..tbl_upm_UserToRole
			( UserId, RoleId, UpdatedUserId )
			VALUES  ( @MG5RoleAdminId,  
			@MG5,
			1)
  INSERT INTO cps..tbl_upm_UserInherit
		        ( UserId, SourceType, UpdatedUserId ) VALUES (@MG5RoleAdminId,1,1),(@MG5RoleAdminId,2,1),(@MG5RoleAdminId,4,1)

  INSERT INTO cps..tbl_upm_Role
          ( RoleName ,
            Description ,
            CreatedUserId ,
            UpdatedUserId
          )
  SELECT  REPLACE(TradeName1,' ','')+' Group6 Role','',@ParentId,'' FROM CPS..tbl_iso WHERE id=@IsoID
  SET @MG6=IDENT_CURRENT('cps..tbl_upm_Role')
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
	  select 2, REPLACE(TradeName1,' ','')+' Group6Role Admin',REPLACE(TradeName1,' ',''),' Group6Role Admin','','Password0',DATEADD(dd,60,GETUTCDATE()),GETUTCDATE(),null,null,@ParentId,@NewaddId,@IsoId,1,1,'' from CPS..tbl_iso
	  where id=@IsoId
  SET @MG6RoleAdminId=IDENT_CURRENT('cps..tbl_upm_User')

  INSERT dbo.tbl_upm_Object(SourceId,SourceType,CreatedUserId) VALUES(@MG6RoleAdminId,2,1)
  INSERT INTO cps..tbl_upm_UserToRole
			( UserId, RoleId, UpdatedUserId )
			VALUES  ( @MG6RoleAdminId,  
			@MG6,
			1)
  INSERT INTO cps..tbl_upm_UserInherit
		        ( UserId, SourceType, UpdatedUserId ) VALUES (@MG6RoleAdminId,1,1),(@MG6RoleAdminId,2,1),(@MG6RoleAdminId,4,1)

  END
  IF @Mid='0000388753'
  BEGIN
  INSERT INTO cps..tbl_upm_Role
          ( RoleName ,
            Description ,
            CreatedUserId ,
            UpdatedUserId
          )
  SELECT  REPLACE(TradeName1,' ','')+' Group1 Role','',@ParentId,'' FROM CPS..tbl_iso WHERE id=@IsoID
  SET @MG1=IDENT_CURRENT('cps..tbl_upm_Role')
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
	  select 2, REPLACE(TradeName1,' ','')+' Group1Role Admin',REPLACE(TradeName1,' ',''),' Group1Role Admin','','Password0',DATEADD(dd,60,GETUTCDATE()),GETUTCDATE(),null,null,@ParentId,@NewaddId,@IsoId,1,1,'' from CPS..tbl_iso
	  where id=@IsoId
  SET @MG1RoleAdminId=IDENT_CURRENT('cps..tbl_upm_User')

  INSERT dbo.tbl_upm_Object(SourceId,SourceType,CreatedUserId) VALUES(@MG1RoleAdminId,2,1)
  INSERT INTO cps..tbl_upm_UserToRole
			( UserId, RoleId, UpdatedUserId )
			VALUES  ( @MG1RoleAdminId,  
			@MG1,
			1)
  INSERT INTO cps..tbl_upm_UserInherit
		        ( UserId, SourceType, UpdatedUserId ) VALUES (@MG1RoleAdminId,1,1),(@MG1RoleAdminId,2,1),(@MG1RoleAdminId,4,1)

  INSERT INTO cps..tbl_upm_Role
          ( RoleName ,
            Description ,
            CreatedUserId ,
            UpdatedUserId
          )
  SELECT  REPLACE(TradeName1,' ','')+' Group5 Role','',@ParentId,'' FROM CPS..tbl_iso WHERE id=@IsoID
  SET @MG5=IDENT_CURRENT('cps..tbl_upm_Role')
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
	  select 2, REPLACE(TradeName1,' ','')+' Group5Role Admin',REPLACE(TradeName1,' ',''),' Group5Role Admin','','Password0',DATEADD(dd,60,GETUTCDATE()),GETUTCDATE(),null,null,@ParentId,@NewaddId,@IsoId,1,1,'' from CPS..tbl_iso
	  where id=@IsoId
  SET @MG5RoleAdminId=IDENT_CURRENT('cps..tbl_upm_User')

  INSERT dbo.tbl_upm_Object(SourceId,SourceType,CreatedUserId) VALUES(@MG5RoleAdminId,2,1)
  INSERT INTO cps..tbl_upm_UserToRole
			( UserId, RoleId, UpdatedUserId )
			VALUES  ( @MG5RoleAdminId,  
			@MG5,
			1)
  INSERT INTO cps..tbl_upm_UserInherit
		        ( UserId, SourceType, UpdatedUserId ) VALUES (@MG5RoleAdminId,1,1),(@MG5RoleAdminId,2,1),(@MG5RoleAdminId,4,1)

  INSERT INTO cps..tbl_upm_Role
          ( RoleName ,
            Description ,
            CreatedUserId ,
            UpdatedUserId
          )
  SELECT  REPLACE(TradeName1,' ','')+' Group6 Role','',@ParentId,'' FROM CPS..tbl_iso WHERE id=@IsoID
  SET @MG6=IDENT_CURRENT('cps..tbl_upm_Role')
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
	  select 2, REPLACE(TradeName1,' ','')+' Group6Role Admin',REPLACE(TradeName1,' ',''),' Group6Role Admin','','Password0',DATEADD(dd,60,GETUTCDATE()),GETUTCDATE(),null,null,@ParentId,@NewaddId,@IsoId,1,1,'' from CPS..tbl_iso
	  where id=@IsoId
  SET @MG6RoleAdminId=IDENT_CURRENT('cps..tbl_upm_User')

  INSERT dbo.tbl_upm_Object(SourceId,SourceType,CreatedUserId) VALUES(@MG6RoleAdminId,2,1)
  INSERT INTO cps..tbl_upm_UserToRole
			( UserId, RoleId, UpdatedUserId )
			VALUES  ( @MG6RoleAdminId,  
			@MG6,
			1)
  INSERT INTO cps..tbl_upm_UserInherit
		        ( UserId, SourceType, UpdatedUserId ) VALUES (@MG6RoleAdminId,1,1),(@MG6RoleAdminId,2,1),(@MG6RoleAdminId,4,1)

  END
  IF @Mid='0000380753'
  BEGIN
  INSERT INTO cps..tbl_upm_Role
          ( RoleName ,
            Description ,
            CreatedUserId ,
            UpdatedUserId
          )
  SELECT  REPLACE(TradeName1,' ','')+' Group1 Role','',@ParentId,'' FROM CPS..tbl_iso WHERE id=@IsoID
  SET @MG1=IDENT_CURRENT('cps..tbl_upm_Role')
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
	  SELECT 2, REPLACE(TradeName1,' ','')+' Group1Role Admin',REPLACE(TradeName1,' ',''),' Group1Role Admin','','Password0',DATEADD(dd,60,GETUTCDATE()),GETUTCDATE(),null,null,@ParentId,@NewaddId,@IsoId,1,1,'' from CPS..tbl_iso
	  where id=@IsoId
  SET @MG1RoleAdminId=IDENT_CURRENT('cps..tbl_upm_User')

  INSERT dbo.tbl_upm_Object(SourceId,SourceType,CreatedUserId) VALUES(@MG1RoleAdminId,2,1)
  INSERT INTO cps..tbl_upm_UserToRole
			( UserId, RoleId, UpdatedUserId )
			VALUES  ( @MG1RoleAdminId,  
			@MG1,
			1)
  INSERT INTO cps..tbl_upm_UserInherit
		        ( UserId, SourceType, UpdatedUserId ) VALUES (@MG1RoleAdminId,1,1),(@MG1RoleAdminId,2,1),(@MG1RoleAdminId,4,1)

  END
  IF @Mid IN ('0000395953','0000447953')
  BEGIN
  INSERT INTO cps..tbl_upm_Role
          ( RoleName ,
            Description ,
            CreatedUserId ,
            UpdatedUserId
          )
  SELECT  REPLACE(TradeName1,' ','')+' Group6 Role','',@ParentId,'' FROM CPS..tbl_iso WHERE id=@IsoID
  SET @MG6=IDENT_CURRENT('cps..tbl_upm_Role')
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
	  select 2, REPLACE(TradeName1,' ','')+' Group6Role Admin',REPLACE(TradeName1,' ',''),' Group6Role Admin','','Password0',DATEADD(dd,60,GETUTCDATE()),GETUTCDATE(),null,null,@ParentId,@NewaddId,@IsoId,1,1,'' from CPS..tbl_iso
	  where id=@IsoId
  SET @MG6RoleAdminId=IDENT_CURRENT('cps..tbl_upm_User')

  INSERT dbo.tbl_upm_Object(SourceId,SourceType,CreatedUserId) VALUES(@MG6RoleAdminId,2,1)
  INSERT INTO cps..tbl_upm_UserToRole
			( UserId, RoleId, UpdatedUserId )
			VALUES  ( @MG6RoleAdminId,  
			@MG6,
			1)
  INSERT INTO cps..tbl_upm_UserInherit
		        ( UserId, SourceType, UpdatedUserId ) VALUES (@MG6RoleAdminId,1,1),(@MG6RoleAdminId,2,1),(@MG6RoleAdminId,4,1)

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
  THEN 59 WHEN 623 THEN 61 WHEN 622 THEN 63 WHEN 620 THEN 65 WHEN 621 THEN 67 END),@AgentRoleId FROM ecage..MERCHANTROLEPERM WHERE Mid=@Mid AND RoleId=8
  
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
  THEN 59 WHEN 623 THEN 61 WHEN 622 THEN 63 WHEN 620 THEN 65 WHEN 621 THEN 67 END),@SupervisorRoleId FROM ecage..MERCHANTROLEPERM WHERE Mid=@Mid AND RoleId=6
  
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
  THEN 59 WHEN 623 THEN 61 WHEN 622 THEN 63 WHEN 620 THEN 65 WHEN 621 THEN 67 END),@LeadRoleId FROM ecage..MERCHANTROLEPERM WHERE Mid=@Mid AND RoleId=7
  
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
  IF @ReportRoleId IS NOT NULL
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
  THEN 59 WHEN 623 THEN 61 WHEN 622 THEN 63 WHEN 620 THEN 65 WHEN 621 THEN 67 END),@ReportRoleId FROM ecage..MERCHANTROLEPERM WHERE Mid=@Mid AND RoleId=14
  
  IF EXISTS (SELECT * FROM @temprole WHERE PermissionId=231 AND RoleId=@ReportRoleId)
  INSERT INTO @temprole VALUES (@ReportRoleId,188)
  			INSERT INTO cps..tbl_upm_PermissionToRole
			( RoleId ,
			PermissionId ,
			IsGranted ,
			UpdatedUserId
			)
			SELECT @ReportRoleId,PermissionId,1,1 FROM @temprole WHERE RoleId=@ReportRoleId AND PermissionId IS NOT NULL AND PermissionId NOT IN (35,37,39,41,43,45,47,49,51,53,55,57,59,61,63,65,67)
	        INSERT INTO cps..tbl_upm_ObjectToUser
            ( UserId ,
            ObjectId ,
            IsGranted ,
            UpdatedUserId
            )
            SELECT @ReportViewerRoleAdminId,Id,1,1 FROM cps..tbl_upm_Object WHERE SourceType=7  AND SourceId IN (SELECT PermissionId FROM @temprole WHERE RoleId=@ReportRoleId AND PermissionId IS NOT NULL 
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
  THEN 59 WHEN 623 THEN 61 WHEN 622 THEN 63 WHEN 620 THEN 65 WHEN 621 THEN 67 END),@AdminRoleId FROM ecage..MERCHANTROLEPERM WHERE Mid=@Mid AND RoleId=5
  
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
  IF @Mid='0000380353'
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
  THEN 59 WHEN 623 THEN 61 WHEN 622 THEN 63 WHEN 620 THEN 65 WHEN 621 THEN 67 END),@MG1 FROM ecage..MERCHANTROLEPERM WHERE Mid=@Mid AND RoleId=1001
  
  IF EXISTS (SELECT * FROM @temprole WHERE PermissionId=231 AND RoleId=@MG1)
  INSERT INTO @temprole VALUES (@MG1,188)
  			INSERT INTO cps..tbl_upm_PermissionToRole
			( RoleId ,
			PermissionId ,
			IsGranted ,
			UpdatedUserId
			)
			SELECT @MG1,PermissionId,1,1 FROM @temprole WHERE RoleId=@MG1 AND PermissionId IS NOT NULL AND PermissionId NOT IN (35,37,39,41,43,45,47,49,51,53,55,57,59,61,63,65,67)
	        INSERT INTO cps..tbl_upm_ObjectToUser
            ( UserId ,
            ObjectId ,
            IsGranted ,
            UpdatedUserId
            )
            SELECT @MG1RoleAdminId,Id,1,1 FROM cps..tbl_upm_Object WHERE SourceType=7  AND SourceId IN (SELECT PermissionId FROM @temprole WHERE RoleId=@MG1 AND PermissionId IS NOT NULL 
			AND PermissionId IN (35,37,39,41,43,45,47,49,51,53,55,57,59,61,63,65,67))
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
  THEN 59 WHEN 623 THEN 61 WHEN 622 THEN 63 WHEN 620 THEN 65 WHEN 621 THEN 67 END),@MG2 FROM ecage..MERCHANTROLEPERM WHERE Mid=@Mid AND RoleId=1002
  
  IF EXISTS (SELECT * FROM @temprole WHERE PermissionId=231 AND RoleId=@MG2)
  INSERT INTO @temprole VALUES (@MG2,188)
  			INSERT INTO cps..tbl_upm_PermissionToRole
			( RoleId ,
			PermissionId ,
			IsGranted ,
			UpdatedUserId
			)
			SELECT @MG2,PermissionId,1,1 FROM @temprole WHERE RoleId=@MG2 AND PermissionId IS NOT NULL AND PermissionId NOT IN (35,37,39,41,43,45,47,49,51,53,55,57,59,61,63,65,67)
	        INSERT INTO cps..tbl_upm_ObjectToUser
            ( UserId ,
            ObjectId ,
            IsGranted ,
            UpdatedUserId
            )
            SELECT @MG2RoleAdminId,Id,1,1 FROM cps..tbl_upm_Object WHERE SourceType=7  AND SourceId IN (SELECT PermissionId FROM @temprole WHERE RoleId=@MG2 AND PermissionId IS NOT NULL 
			AND PermissionId IN (35,37,39,41,43,45,47,49,51,53,55,57,59,61,63,65,67))
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
  THEN 59 WHEN 623 THEN 61 WHEN 622 THEN 63 WHEN 620 THEN 65 WHEN 621 THEN 67 END),@MG3 FROM ecage..MERCHANTROLEPERM WHERE Mid=@Mid AND RoleId=1003
  
  IF EXISTS (SELECT * FROM @temprole WHERE PermissionId=231 AND RoleId=@MG3)
  INSERT INTO @temprole VALUES (@MG3,188)
  			INSERT INTO cps..tbl_upm_PermissionToRole
			( RoleId ,
			PermissionId ,
			IsGranted ,
			UpdatedUserId
			)
			SELECT @MG3,PermissionId,1,1 FROM @temprole WHERE RoleId=@MG3 AND PermissionId IS NOT NULL AND PermissionId NOT IN (35,37,39,41,43,45,47,49,51,53,55,57,59,61,63,65,67)
	        INSERT INTO cps..tbl_upm_ObjectToUser
            ( UserId ,
            ObjectId ,
            IsGranted ,
            UpdatedUserId
            )
            SELECT @MG3RoleAdminId,Id,1,1 FROM cps..tbl_upm_Object WHERE SourceType=7  AND SourceId IN (SELECT PermissionId FROM @temprole WHERE RoleId=@MG3 AND PermissionId IS NOT NULL 
			AND PermissionId IN (35,37,39,41,43,45,47,49,51,53,55,57,59,61,63,65,67))
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
  THEN 59 WHEN 623 THEN 61 WHEN 622 THEN 63 WHEN 620 THEN 65 WHEN 621 THEN 67 END),@MG4 FROM ecage..MERCHANTROLEPERM WHERE Mid=@Mid AND RoleId=1004
  
  IF EXISTS (SELECT * FROM @temprole WHERE PermissionId=231 AND RoleId=@MG4)
  INSERT INTO @temprole VALUES (@MG4,188)
  			INSERT INTO cps..tbl_upm_PermissionToRole
			( RoleId ,
			PermissionId ,
			IsGranted ,
			UpdatedUserId
			)
			SELECT @MG4,PermissionId,1,1 FROM @temprole WHERE RoleId=@MG4 AND PermissionId IS NOT NULL AND PermissionId NOT IN (35,37,39,41,43,45,47,49,51,53,55,57,59,61,63,65,67)
	        INSERT INTO cps..tbl_upm_ObjectToUser
            ( UserId ,
            ObjectId ,
            IsGranted ,
            UpdatedUserId
            )
            SELECT @MG4RoleAdminId,Id,1,1 FROM cps..tbl_upm_Object WHERE SourceType=7  AND SourceId IN (SELECT PermissionId FROM @temprole WHERE RoleId=@MG4 AND PermissionId IS NOT NULL 
			AND PermissionId IN (35,37,39,41,43,45,47,49,51,53,55,57,59,61,63,65,67))
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
  THEN 59 WHEN 623 THEN 61 WHEN 622 THEN 63 WHEN 620 THEN 65 WHEN 621 THEN 67 END),@MG5 FROM ecage..MERCHANTROLEPERM WHERE Mid=@Mid AND RoleId=1005
  
  IF EXISTS (SELECT * FROM @temprole WHERE PermissionId=231 AND RoleId=@MG5)
  INSERT INTO @temprole VALUES (@MG5,188)
  			INSERT INTO cps..tbl_upm_PermissionToRole
			( RoleId ,
			PermissionId ,
			IsGranted ,
			UpdatedUserId
			)
			SELECT @MG5,PermissionId,1,1 FROM @temprole WHERE RoleId=@MG5 AND PermissionId IS NOT NULL AND PermissionId NOT IN (35,37,39,41,43,45,47,49,51,53,55,57,59,61,63,65,67)
	        INSERT INTO cps..tbl_upm_ObjectToUser
            ( UserId ,
            ObjectId ,
            IsGranted ,
            UpdatedUserId
            )
            SELECT @MG5RoleAdminId,Id,1,1 FROM cps..tbl_upm_Object WHERE SourceType=7  AND SourceId IN (SELECT PermissionId FROM @temprole WHERE RoleId=@MG5 AND PermissionId IS NOT NULL 
			AND PermissionId IN (35,37,39,41,43,45,47,49,51,53,55,57,59,61,63,65,67))
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
  THEN 59 WHEN 623 THEN 61 WHEN 622 THEN 63 WHEN 620 THEN 65 WHEN 621 THEN 67 END),@MG6 FROM ecage..MERCHANTROLEPERM WHERE Mid=@Mid AND RoleId=1006
  
  IF EXISTS (SELECT * FROM @temprole WHERE PermissionId=231 AND RoleId=@MG6)
  INSERT INTO @temprole VALUES (@MG6,188)
  			INSERT INTO cps..tbl_upm_PermissionToRole
			( RoleId ,
			PermissionId ,
			IsGranted ,
			UpdatedUserId
			)
			SELECT @MG6,PermissionId,1,1 FROM @temprole WHERE RoleId=@MG6 AND PermissionId IS NOT NULL AND PermissionId NOT IN (35,37,39,41,43,45,47,49,51,53,55,57,59,61,63,65,67)
	        INSERT INTO cps..tbl_upm_ObjectToUser
            ( UserId ,
            ObjectId ,
            IsGranted ,
            UpdatedUserId
            )
            SELECT @MG6RoleAdminId,Id,1,1 FROM cps..tbl_upm_Object WHERE SourceType=7  AND SourceId IN (SELECT PermissionId FROM @temprole WHERE RoleId=@MG6 AND PermissionId IS NOT NULL 
			AND PermissionId IN (35,37,39,41,43,45,47,49,51,53,55,57,59,61,63,65,67))
  END
  IF @Mid='0000388753'
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
  THEN 59 WHEN 623 THEN 61 WHEN 622 THEN 63 WHEN 620 THEN 65 WHEN 621 THEN 67 END),@MG1 FROM ecage..MERCHANTROLEPERM WHERE Mid=@Mid AND RoleId=1001
  
  IF EXISTS (SELECT * FROM @temprole WHERE PermissionId=231 AND RoleId=@MG1)
  INSERT INTO @temprole VALUES (@MG1,188)
  			INSERT INTO cps..tbl_upm_PermissionToRole
			( RoleId ,
			PermissionId ,
			IsGranted ,
			UpdatedUserId
			)
			SELECT @MG1,PermissionId,1,1 FROM @temprole WHERE RoleId=@MG1 AND PermissionId IS NOT NULL AND PermissionId NOT IN (35,37,39,41,43,45,47,49,51,53,55,57,59,61,63,65,67)
	        INSERT INTO cps..tbl_upm_ObjectToUser
            ( UserId ,
            ObjectId ,
            IsGranted ,
            UpdatedUserId
            )
            SELECT @MG1RoleAdminId,Id,1,1 FROM cps..tbl_upm_Object WHERE SourceType=7  AND SourceId IN (SELECT PermissionId FROM @temprole WHERE RoleId=@MG1 AND PermissionId IS NOT NULL 
			AND PermissionId IN (35,37,39,41,43,45,47,49,51,53,55,57,59,61,63,65,67))
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
  THEN 59 WHEN 623 THEN 61 WHEN 622 THEN 63 WHEN 620 THEN 65 WHEN 621 THEN 67 END),@MG5 FROM ecage..MERCHANTROLEPERM WHERE Mid=@Mid AND RoleId=1005
  
  IF EXISTS (SELECT * FROM @temprole WHERE PermissionId=231 AND RoleId=@MG5)
  INSERT INTO @temprole VALUES (@MG5,188)
  			INSERT INTO cps..tbl_upm_PermissionToRole
			( RoleId ,
			PermissionId ,
			IsGranted ,
			UpdatedUserId
			)
			SELECT @MG5,PermissionId,1,1 FROM @temprole WHERE RoleId=@MG5 AND PermissionId IS NOT NULL AND PermissionId NOT IN (35,37,39,41,43,45,47,49,51,53,55,57,59,61,63,65,67)
	        INSERT INTO cps..tbl_upm_ObjectToUser
            ( UserId ,
            ObjectId ,
            IsGranted ,
            UpdatedUserId
            )
            SELECT @MG5RoleAdminId,Id,1,1 FROM cps..tbl_upm_Object WHERE SourceType=7  AND SourceId IN (SELECT PermissionId FROM @temprole WHERE RoleId=@MG5 AND PermissionId IS NOT NULL 
			AND PermissionId IN (35,37,39,41,43,45,47,49,51,53,55,57,59,61,63,65,67))
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
  THEN 59 WHEN 623 THEN 61 WHEN 622 THEN 63 WHEN 620 THEN 65 WHEN 621 THEN 67 END),@MG6 FROM ecage..MERCHANTROLEPERM WHERE Mid=@Mid AND RoleId=1006
  
  IF EXISTS (SELECT * FROM @temprole WHERE PermissionId=231 AND RoleId=@MG6)
  INSERT INTO @temprole VALUES (@MG6,188)
  			INSERT INTO cps..tbl_upm_PermissionToRole
			( RoleId ,
			PermissionId ,
			IsGranted ,
			UpdatedUserId
			)
			SELECT @MG6,PermissionId,1,1 FROM @temprole WHERE RoleId=@MG6 AND PermissionId IS NOT NULL AND PermissionId NOT IN (35,37,39,41,43,45,47,49,51,53,55,57,59,61,63,65,67)
	        INSERT INTO cps..tbl_upm_ObjectToUser
            ( UserId ,
            ObjectId ,
            IsGranted ,
            UpdatedUserId
            )
            SELECT @MG6RoleAdminId,Id,1,1 FROM cps..tbl_upm_Object WHERE SourceType=7  AND SourceId IN (SELECT PermissionId FROM @temprole WHERE RoleId=@MG6 AND PermissionId IS NOT NULL 
			AND PermissionId IN (35,37,39,41,43,45,47,49,51,53,55,57,59,61,63,65,67))
  END
  IF @Mid='0000380753'
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
  THEN 59 WHEN 623 THEN 61 WHEN 622 THEN 63 WHEN 620 THEN 65 WHEN 621 THEN 67 END),@MG1 FROM ecage..MERCHANTROLEPERM WHERE Mid=@Mid AND RoleId=1001
  
  IF EXISTS (SELECT * FROM @temprole WHERE PermissionId=231 AND RoleId=@MG1)
  INSERT INTO @temprole VALUES (@MG1,188)
  			INSERT INTO cps..tbl_upm_PermissionToRole
			( RoleId ,
			PermissionId ,
			IsGranted ,
			UpdatedUserId
			)
			SELECT @MG1,PermissionId,1,1 FROM @temprole WHERE RoleId=@MG1 AND PermissionId IS NOT NULL AND PermissionId NOT IN (35,37,39,41,43,45,47,49,51,53,55,57,59,61,63,65,67)
	        INSERT INTO cps..tbl_upm_ObjectToUser
            ( UserId ,
            ObjectId ,
            IsGranted ,
            UpdatedUserId
            )
            SELECT @MG1RoleAdminId,Id,1,1 FROM cps..tbl_upm_Object WHERE SourceType=7  AND SourceId IN (SELECT PermissionId FROM @temprole WHERE RoleId=@MG1 AND PermissionId IS NOT NULL 
			AND PermissionId IN (35,37,39,41,43,45,47,49,51,53,55,57,59,61,63,65,67))
  END
  IF @Mid IN ('0000395953','0000447953')
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
  THEN 59 WHEN 623 THEN 61 WHEN 622 THEN 63 WHEN 620 THEN 65 WHEN 621 THEN 67 END),@MG6 FROM ecage..MERCHANTROLEPERM WHERE Mid=@Mid AND RoleId=1006
  
  IF EXISTS (SELECT * FROM @temprole WHERE PermissionId=231 AND RoleId=@MG6)
  INSERT INTO @temprole VALUES (@MG6,188)
  			INSERT INTO cps..tbl_upm_PermissionToRole
			( RoleId ,
			PermissionId ,
			IsGranted ,
			UpdatedUserId
			)
			SELECT @MG6,PermissionId,1,1 FROM @temprole WHERE RoleId=@MG6 AND PermissionId IS NOT NULL AND PermissionId NOT IN (35,37,39,41,43,45,47,49,51,53,55,57,59,61,63,65,67)
	        INSERT INTO cps..tbl_upm_ObjectToUser
            ( UserId ,
            ObjectId ,
            IsGranted ,
            UpdatedUserId
            )
            SELECT @MG6RoleAdminId,Id,1,1 FROM cps..tbl_upm_Object WHERE SourceType=7  AND SourceId IN (SELECT PermissionId FROM @temprole WHERE RoleId=@MG6 AND PermissionId IS NOT NULL 
			AND PermissionId IN (35,37,39,41,43,45,47,49,51,53,55,57,59,61,63,65,67))
  END



------------------------  insert new users from ecagev3 ----------------------
	 
	insert into  cps..tbl_upm_User_Old   (UserName,PasswordType,PasswordEncrypt,PasswordMD5,OldUserId,OldRoleId,FirstName,LastName,Mid)
	select sy.USERNAME,2,sy.Password,NULL,sy.USERID,eu.ROLEID,sy.FIRSTNAME,sy.LASTNAME,sy.MID from ecage.dbo.SYSUSERPNT sy LEFT JOIN ecage.dbo.userrole eu ON eu.USERID = sy.USERID
	WHERE sy.MID =@Mid

	DECLARE @OldRoleId BIGINT,@NewUserName nvarchar(50), @NewuserId BIGINT,@OlduserId BIGINT,@FirstName NVARCHAR(30),@LastName NVARCHAR(30),@Oldusername NVARCHAR(50) 
    DECLARE TempCursor CURSOR LOCAL FOR SELECT olduserid,oldroleid,FirstName,LastName,UserName  FROM  cps..tbl_upm_User_Old  WHERE Mid=@Mid  ORDER BY  olduserid 
    OPEN TempCursor
    FETCH NEXT FROM TempCursor INTO @OlduserId,@OldRoleId,@FirstName,@LastName,@Oldusername
      WHILE @@Fetch_Status=0
      BEGIN 
	    IF NOT EXISTS (SELECT id from cps..tbl_upm_user where UserName=@Oldusername)
		SET @NewUserName=@Oldusername
	    ELSE IF NOT EXISTS (select id from cps..tbl_upm_user where UserName=LEFT(LTRIM(@Firstname),1)+LTRIM(RTRIM(@LastName)))
	      BEGIN 
		   SET @NewUserName=LEFT(LTRIM(@Firstname),1)+LTRIM(RTRIM(@LastName))
		   UPDATE cps.dbo.tbl_upm_User_Old SET UserName=@NewUserName WHERE olduserid=@OlduserId
		   PRINT 'UserName:'+@Oldusername+' exists, have to Change as '+LEFT(LTRIM(@Firstname),1)+LTRIM(RTRIM(@LastName))+' !'
          END
		   ELSE IF NOT EXISTS (select id from cps..tbl_upm_user where UserName=LTRIM(RTRIM(@Firstname))+LTRIM(RTRIM(@LastName)))
		   BEGIN 
		    SET @NewUserName=LTRIM(RTRIM(@Firstname))+LTRIM(RTRIM(@LastName))
		    UPDATE cps.dbo.tbl_upm_User_Old SET UserName=@NewUserName WHERE olduserid=@OlduserId
            PRINT 'UserName:'+LEFT(LTRIM(@Firstname),1)+LTRIM(RTRIM(@LastName))+' exists, have to Change as '+LTRIM(RTRIM(@Firstname))+LTRIM(RTRIM(@LastName))+' !'
		   END 
		     ELSE IF NOT EXISTS (select id from cps..tbl_upm_user where UserName=LTRIM(RTRIM(@Firstname))+LTRIM(RTRIM(@LastName))+'1')
			 BEGIN 
		       SET @NewUserName=LTRIM(RTRIM(@Firstname))+LTRIM(RTRIM(@LastName))+'1'
		       UPDATE cps.dbo.tbl_upm_User_Old SET UserName=@NewUserName WHERE olduserid=@OlduserId
               PRINT 'UserName:'+LTRIM(RTRIM(@Firstname))+LTRIM(RTRIM(@LastName))+' exists, have to Change as '+LTRIM(RTRIM(@Firstname))+LTRIM(RTRIM(@LastName))+'1 !'
			 END
			   ELSE
 		         BEGIN
		         print 'UserName:'+LTRIM(RTRIM(@Firstname))+LTRIM(RTRIM(@LastName))+' exists in V4!'
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
	  select 2, @NewUserName,FIRSTNAME,LASTNAME,MIDDLEINITIAL,'',expdate,'',LOCKOUTDATE,LOCKCOUNT,@ParentId,@NewaddId,@IsoId,STATUSID,1,'' from ecage.dbo.SYSUSERPNT 
	  where userid=@OlduserId
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
      IF @OldRoleId=1001
	 	BEGIN
			INSERT INTO cps..tbl_upm_UserToRole
			( UserId, RoleId, UpdatedUserId )
			VALUES  ( @NewuserId,  
			@MG1,
			1)
			UPDATE cps..tbl_upm_User SET ParentId=@MG1RoleAdminId WHERE Id=@NewuserId
		END 
	  IF @OldRoleId=1002
	 	BEGIN
			INSERT INTO cps..tbl_upm_UserToRole
			( UserId, RoleId, UpdatedUserId )
			VALUES  ( @NewuserId,  
			@MG2,
			1)
			UPDATE cps..tbl_upm_User SET ParentId=@MG2RoleAdminId WHERE Id=@NewuserId
		END 
	  IF @OldRoleId=1003
	 	BEGIN
			INSERT INTO cps..tbl_upm_UserToRole
			( UserId, RoleId, UpdatedUserId )
			VALUES  ( @NewuserId,  
			@MG3,
			1)
			UPDATE cps..tbl_upm_User SET ParentId=@MG3RoleAdminId WHERE Id=@NewuserId
		END 
	 IF @OldRoleId=1004
	 	BEGIN
			INSERT INTO cps..tbl_upm_UserToRole
			( UserId, RoleId, UpdatedUserId )
			VALUES  ( @NewuserId,  
			@MG4,
			1)
			UPDATE cps..tbl_upm_User SET ParentId=@MG4RoleAdminId WHERE Id=@NewuserId
		END 
	  IF @OldRoleId=1005
	 	BEGIN
			INSERT INTO cps..tbl_upm_UserToRole
			( UserId, RoleId, UpdatedUserId )
			VALUES  ( @NewuserId,  
			@MG5,
			1)
			UPDATE cps..tbl_upm_User SET ParentId=@MG5RoleAdminId WHERE Id=@NewuserId
		END 
	  IF @OldRoleId=1006
	 	BEGIN
			INSERT INTO cps..tbl_upm_UserToRole
			( UserId, RoleId, UpdatedUserId )
			VALUES  ( @NewuserId,  
			@MG6,
			1)
			UPDATE cps..tbl_upm_User SET ParentId=@MG6RoleAdminId WHERE Id=@NewuserId
		END 
  ----------------------   inherit setting ------------------------
		INSERT INTO cps..tbl_upm_UserInherit
		        ( UserId, SourceType, UpdatedUserId ) VALUES (@NewuserId,1,1),(@NewuserId,2,1),(@NewuserId,4,1),(@NewuserId,7,1)
		 
      Nextuser:
	   FETCH NEXT FROM TempCursor INTO @OlduserId,@OldRoleId,@FirstName,@LastName,@Oldusername
      END
      CLOSE TempCursor
      DEALLOCATE TempCursor 
   
END

 
GO
