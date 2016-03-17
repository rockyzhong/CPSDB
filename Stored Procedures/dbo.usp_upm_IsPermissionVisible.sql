SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_upm_IsPermissionVisible]
@UserId       bigint,
@PermissionId bigint,
@IsVisible    bigint OUT
AS
BEGIN
  SET NOCOUNT ON
  
  DECLARE @Permission TABLE (Id bigint)
  INSERT INTO @Permission EXEC dbo.usp_upm_GetPermissionIds @UserId,1

  IF EXISTS(SELECT * FROM @Permission WHERE Id=@PermissionId)
    SET @IsVisible=0
  ELSE
    SET @IsVisible=-1
    
  RETURN 0
END
GO
GRANT EXECUTE ON  [dbo].[usp_upm_IsPermissionVisible] TO [WebV4Role]
GO
