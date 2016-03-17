SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_upm_IsObjectVisible]
@UserId     bigint,
@SourceType bigint,
@SourceId   bigint,
@IsVisible  bigint OUT
AS
BEGIN
  SET NOCOUNT ON
  
  DECLARE @Source SourceTABLE
  INSERT INTO @Source EXEC dbo.usp_upm_GetObjectIds @UserId,@SourceType,1

  IF EXISTS(SELECT * FROM @Source WHERE Id=@SourceId)
    SET @IsVisible=0
  ELSE
    SET @IsVisible=-1
    
  RETURN 0
END
GO
GRANT EXECUTE ON  [dbo].[usp_upm_IsObjectVisible] TO [WebV4Role]
GO
