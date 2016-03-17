SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_rep_GetUserByIsoId] 
@IsoId BIGINT,
@Userstatus BIGINT=0
WITH EXECUTE AS 'dbo'
AS
BEGIN
  IF @Userstatus=0
  SELECT u.Id UserId,UserType,u.UserName,u.FirstName,u.LastName,u.MiddleInitial
  FROM dbo.tbl_upm_User u
  WHERE u.IsoId=@IsoId
  ELSE
  SELECT u.Id UserId,UserType,u.UserName,u.FirstName,u.LastName,u.MiddleInitial
  FROM dbo.tbl_upm_User u
  WHERE u.IsoId=@IsoId AND u.UserStatus IN (1,3)
END 
GO
