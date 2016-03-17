SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_upm_InsertPermissionToUser]
@UserId        bigint,
@PermissionId  nvarchar(max),
@IsGranted     bigint,
@UpdatedUserId bigint
AS
BEGIN
  SET NOCOUNT ON
  
  DECLARE @Permission TABLE (Id bigint)
  INSERT INTO @Permission EXEC dbo.usp_sys_Split @PermissionId

  INSERT INTO dbo.tbl_upm_PermissionToUser(UserId,PermissionId,IsGranted,UpdatedUserId) 
  SELECT @UserId,Id,@IsGranted,@UpdatedUserId FROM @Permission 
  WHERE Id NOT IN (SELECT PermissionId FROM dbo.tbl_upm_PermissionToUser WHERE UserId=@UserId AND IsGranted=@IsGranted)
  
  RETURN 0
END
GO
GRANT EXECUTE ON  [dbo].[usp_upm_InsertPermissionToUser] TO [WebV4Role]
GO
