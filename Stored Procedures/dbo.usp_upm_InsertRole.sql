SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_upm_InsertRole] 
@RoleId bigint OUTPUT,
@RoleName nvarchar(50),
@Description nvarchar(50),
@UpdatedUserId bigint
AS
BEGIN
  SET NOCOUNT ON
  INSERT INTO dbo.tbl_upm_Role(RoleName,Description,CreatedUserId,UpdatedUserId) VALUES(@RoleName,@Description,@UpdatedUserId,@UpdatedUserId)
  SELECT @RoleId=IDENT_CURRENT('tbl_upm_Role')
  RETURN 0
END
GO
GRANT EXECUTE ON  [dbo].[usp_upm_InsertRole] TO [WebV4Role]
GO
