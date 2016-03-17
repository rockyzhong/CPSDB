SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_upm_InsertObjectToUser]
@UserId        bigint,
@SourceId      nvarchar(max),
@SourceType    bigint,
@IsGranted     bigint,
@UpdatedUserId bigint
AS
BEGIN
  SET NOCOUNT ON
  
  DECLARE @Source TABLE (Id bigint)
  INSERT INTO @Source EXEC dbo.usp_sys_Split @SourceId
  
  INSERT INTO dbo.tbl_upm_ObjectToUser(UserId,ObjectId,IsGranted,UpdatedUserId) 
  SELECT @UserId,Id,@IsGranted,@UpdatedUserId FROM dbo.tbl_upm_Object 
  WHERE SourceId IN (SELECT Id FROM @Source) AND SourceType=@SourceType
  AND Id NOT IN (SELECT ObjectId FROM dbo.tbl_upm_ObjectToUser WHERE UserId=@UserId AND IsGranted=@IsGranted)
  
  RETURN 0
END
GO
GRANT EXECUTE ON  [dbo].[usp_upm_InsertObjectToUser] TO [WebV4Role]
GO
