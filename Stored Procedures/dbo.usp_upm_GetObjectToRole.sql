SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_upm_GetObjectToRole]
@RoleId     bigint,
@SourceType bigint,
@IsGranted  bigint=1
AS
BEGIN
  SET NOCOUNT ON

  DECLARE @Object TABLE (Id bigint) 
  INSERT INTO @Object SELECT ObjectId FROM dbo.tbl_upm_ObjectToRole
  WHERE RoleId=@RoleId GROUP BY ObjectId HAVING MIN(CONVERT(bigint,IsGranted))=@IsGranted;

  DECLARE @Source SourceTABLE
  INSERT INTO @Source SELECT SourceId FROM dbo.tbl_upm_Object WHERE Id IN (SELECT Id FROM @Object) AND SourceType=@SourceType
  
  EXEC dbo.usp_upm_GetObjectsDetail @Source,@SourceType

END
GO
GRANT EXECUTE ON  [dbo].[usp_upm_GetObjectToRole] TO [WebV4Role]
GO
