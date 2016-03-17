SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_upm_DeleteObjectToRole]
@RoleId        bigint,
@SourceId      nvarchar(max),
@SourceType    bigint,
@IsGranted     bigint,
@UpdatedUserId bigint
AS
BEGIN
  SET NOCOUNT ON

  DECLARE @Source TABLE (Id bigint)
  INSERT INTO @Source EXEC dbo.usp_sys_Split @SourceId

  UPDATE dbo.tbl_upm_ObjectToRole SET UpdatedUserId=@UpdatedUserId WHERE RoleId=@RoleId AND ObjectId IN (SELECT Id FROM dbo.tbl_upm_Object WHERE SourceId IN (SELECT Id FROM @Source) AND SourceType=@SourceType) AND IsGranted=@IsGranted
  DELETE FROM dbo.tbl_upm_ObjectToRole WHERE RoleId=@RoleId AND ObjectId IN (SELECT Id FROM dbo.tbl_upm_Object WHERE SourceId IN (SELECT Id FROM @Source) AND SourceType=@SourceType) AND IsGranted=@IsGranted

  RETURN 0
END
GO
GRANT EXECUTE ON  [dbo].[usp_upm_DeleteObjectToRole] TO [WebV4Role]
GO
