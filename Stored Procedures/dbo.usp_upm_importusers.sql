SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_upm_importusers]
@UserName                 nvarchar(50)  ,
@Olddbname                nvarchar(50)
--@PasswordMD5              varbinary(20)  =Null ,
--@PasswordEncrypt          varchar(512)   =NULL

AS
BEGIN
  SET NOCOUNT ON
  Declare @PasswordMD5  varbinary(20),
          @PasswordEncrypt   varchar(512)
  DECLARE @Source TABLE (Oldusername nvarchar(50))
  INSERT INTO @Source EXEC dbo.usp_sys_Split  @UserName
   

	IF @Olddbname='SPS'
	BEGIN
    insert into  tbl_upm_User_Old   (UserName,PasswordType,PasswordEncrypt,PasswordMD5)
	select UserID,1,NULL,Password  from SPS.dbo.tbluser where UserID in (select Oldusername from @Source) 
	and UserID not in (select UserName from tbl_upm_User_Old)
    END
	ELSE 
	IF @Olddbname='SPS_SPN'
	BEGIN
	insert into  tbl_upm_User_Old   (UserName,PasswordType,PasswordEncrypt,PasswordMD5)
	select UserID,1,NULL,Password  from SPS_SPN.dbo.tbluser where UserID in (select Oldusername from @Source)
	and UserID not in (select UserName from tbl_upm_User_Old) 
    END
    ELSE 
	IF @Olddbname='ECAGE'
    BEGIN
	insert into  tbl_upm_User_Old   (UserName,PasswordType,PasswordEncrypt,PasswordMD5)
	select USERNAME,2,Password,null  from ecage.dbo.SYSUSERPNT where USERNAME in (select Oldusername from @Source)
    and USERNAME not in (select UserName from tbl_upm_User_Old) 
    END
  
END
GO
