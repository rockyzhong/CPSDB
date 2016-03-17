SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_upm_Createnewadminusers]
 @ISOId bigint,
 @ISOName NVARCHAR(50)
AS BEGIN
SET NOCOUNT ON
DECLARE  @SuperAdminFirstName NVARCHAR(50),@SuperAdminId BIGINT,@AddressId  bigint 
        
--set @ReportRoleId=15 -- need to find out reporter supervisor  cashier role and Admin Role
--set @CashierRoleId=13
--set @SupervisorRoleId=11
--SET @AdminRoleId=35

--------------create merchant admin user  ----------------

SET @SuperAdminFirstName=@ISOName+'admin'
IF NOT EXISTS( SELECT TOP 1 id FROM tbl_upm_user WHERE UserName=@SuperAdminFirstName)
BEGIN
EXEC usp_upm_InsertUser @SuperAdminId OUTPUT,1,2,@SuperAdminFirstName, @ISOName, 'Admin','','Password0',@AddressId,@ISOId,1,1,'',null 


--------------assign role for merchant admin  ----------------

  INSERT INTO cps..tbl_upm_UserToRole
          ( UserId, RoleId, UpdatedUserId )
  VALUES  ( @SuperAdminId,  
            11,
            1)
  INSERT INTO cps..tbl_upm_UserToRole
          ( UserId, RoleId, UpdatedUserId )
  VALUES  ( @SuperAdminId,  
            13,
            1)
  INSERT INTO cps..tbl_upm_UserToRole
          ( UserId, RoleId, UpdatedUserId )
  VALUES  ( @SuperAdminId,  
            15,
            1)
  INSERT INTO cps..tbl_upm_UserToRole
          ( UserId, RoleId, UpdatedUserId )
  VALUES  ( @SuperAdminId,  
            35,
            1)
  INSERT INTO cps..tbl_upm_UserToRole
          ( UserId, RoleId, UpdatedUserId )
  VALUES  ( @SuperAdminId,  
            37,
            1)
  INSERT INTO cps..tbl_upm_UserToRole
          ( UserId, RoleId, UpdatedUserId )
  VALUES  ( @SuperAdminId,  
            39,
            1)
  INSERT INTO cps..tbl_upm_UserToRole
          ( UserId, RoleId, UpdatedUserId )
  VALUES  ( @SuperAdminId,  
            41,
            1)

------------assign object to merchant admin -------

INSERT INTO cps..tbl_upm_ObjectToUser
        ( UserId ,
          ObjectId ,
          IsGranted ,
          UpdatedUserId
        )
SELECT @SuperAdminId,obj.id,1,null FROM cps..tbl_upm_Object obj JOIN cps..tbl_Device De ON  obj.SourceType=1 AND de.Id=obj.SourceId  WHERE de.IsoId=@ISOID

INSERT INTO cps..tbl_upm_ObjectToUser
        ( UserId ,
          ObjectId ,
          IsGranted ,
          UpdatedUserId
        )
SELECT @SuperAdminId,obj.id,1,null FROM cps..tbl_upm_Object obj JOIN CPS.dbo.tbl_BankAccount ac ON obj.SourceType=3 AND ac.Id=obj.SourceId WHERE ac.IsoId=@ISOID
INSERT INTO cps..tbl_upm_ObjectToUser
        ( UserId ,
          ObjectId ,
          IsGranted ,
          UpdatedUserId
        )
SELECT @SuperAdminId,obj.id,1,null FROM cps..tbl_upm_Object obj JOIN CPS.dbo.tbl_Iso iso ON obj.SourceType=4 AND iso.Id=obj.SourceId WHERE iso.id=@ISOID
INSERT INTO cps..tbl_upm_ObjectToUser
        ( UserId ,
          ObjectId ,
          IsGranted ,
          UpdatedUserId
        )
SELECT @SuperAdminId,Id,1,1 FROM cps..tbl_upm_Object WHERE SourceType=7 AND Sourceid IN (51,53,55,57,2008,35,37,39,41,43,45,47,49,63,2001,65,67,69)
PRINT 'AdminId is '+CONVERT(NVARCHAR(50),@SuperAdminId)
END
ELSE 
PRINT 'Admin UserName exists in tbl_upm_user!'
END
GO
