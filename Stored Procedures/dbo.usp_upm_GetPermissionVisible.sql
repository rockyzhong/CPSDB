SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_upm_GetPermissionVisible]
@UserId       bigint,
@PermissionId bigint
AS
BEGIN
  SET NOCOUNT ON
  
  DECLARE @IsVisible bigint
  DECLARE @Permission TABLE (Id bigint)
  INSERT INTO @Permission EXEC dbo.usp_upm_GetPermissionIds @UserId,1

  IF EXISTS(SELECT * FROM @Permission WHERE Id=@PermissionId)
    SET @IsVisible=0
  ELSE
    SET @IsVisible=-1
    
  SELECT @IsVisible HasPermission
END
GO
GRANT EXECUTE ON  [dbo].[usp_upm_GetPermissionVisible] TO [WebV4Role]
GO
