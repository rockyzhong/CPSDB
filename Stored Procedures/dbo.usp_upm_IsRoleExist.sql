SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_upm_IsRoleExist] 
@RoleName nvarchar(50),
@IsExist bigint OUT
AS
BEGIN
  SET NOCOUNT ON
  IF EXISTS(SELECT * FROM dbo.tbl_upm_Role WHERE RoleName=@RoleName)
    SET @IsExist=1
  ELSE
    SET @IsExist=0
  RETURN 0
END
GO
GRANT EXECUTE ON  [dbo].[usp_upm_IsRoleExist] TO [WebV4Role]
GO
