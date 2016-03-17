SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_upm_GetObjects]
@UserId     bigint,
@SourceType bigint,
@IsGranted  bigint = 1
AS
BEGIN
  SET NOCOUNT ON

  DECLARE @Source SourceTABLE
  INSERT INTO @Source EXEC dbo.usp_upm_GetObjectIds @UserId,@SourceType,@IsGranted
  
  EXEC dbo.usp_upm_GetObjectsDetail @Source,@SourceType
END
GO
GRANT EXECUTE ON  [dbo].[usp_upm_GetObjects] TO [WebV4Role]
GO
