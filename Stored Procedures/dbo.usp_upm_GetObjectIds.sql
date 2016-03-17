SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_upm_GetObjectIds]
--User can view objects which are created by it and its children or are directly assigned or are inherited from its parent    
@UserId     bigint,
@SourceType bigint,
@IsGranted  bigint = 1
AS
BEGIN
  SET NOCOUNT ON

  IF @UserId=1
  BEGIN
    IF @IsGranted=1
      SELECT SourceId FROM dbo.tbl_upm_Object WHERE SourceType=@SourceType
    ELSE
      SELECT SourceId FROM dbo.tbl_upm_Object WHERE Id=-1
  END
  ELSE
  IF @SourceType =2 and @UserId<>1
  BEGIN
     -- Get parent's userid
	 DECLARE @Origid bigint
	  EXEC usp_upm_GetInheritParentId @Userid,2,@Origid output
      IF @Origid is not null
	  BEGIN
	  -- Get parent's all subusers
      with mysublists as
		(select id, username, ParentId from tbl_upm_user
		 where id=@Origid
		 union all
		 select m.id,m.UserName,m.ParentId
		 from tbl_upm_user m inner join mysublists s
		 on m.ParentId=s.id
		 )
      Select id from mysublists where id<>@Origid
	  END
	  ELSE    
	  BEGIN
	  -- Get self and all subusers
	  with myselfsubs as
	   (select id, username, ParentId from tbl_upm_user
		 where id=@UserId
		 union all
		 select m.id,m.UserName,m.ParentId
		 from tbl_upm_user m inner join myselfsubs s
		 on m.ParentId=s.id
		 )
      Select id from myselfsubs
	  END
  END  
  ELSE    
  BEGIN  
    -- Get inherited parent user ids
    DECLARE @ParentId bigint
    SET @ParentId=@UserId
  
    DECLARE @ParentIds TABLE(UserId bigint)
    WHILE EXISTS (SELECT * FROM dbo.tbl_upm_User u JOIN dbo.tbl_upm_UserInherit i ON u.Id=i.UserId WHERE u.ParentId IS NOT NULL AND i.UserId=@ParentId AND i.SourceType=@SourceType)
    BEGIN
      SELECT @ParentId=ParentId FROM dbo.tbl_upm_User u JOIN dbo.tbl_upm_UserInherit i ON u.Id=i.UserId WHERE u.ParentId IS NOT NULL AND i.UserId=@ParentId AND i.SourceType=@SourceType
      INSERT INTO @ParentIds(UserId) VALUES(@ParentId)
    END
 
    -- Get inherited parent, self and sub user ids
    DECLARE @UserIds TABLE(UserId bigint);
    INSERT INTO @UserIds(UserId) SELECT UserId FROM @ParentIds
    INSERT INTO @UserIds(UserId) VALUES(@UserId)   
    
    DECLARE @Count1 bigint = 0,@Count2 bigint = 1;               
    WHILE (@Count2>@Count1)
    BEGIN
      SELECT @Count1=COUNT(*) FROM @UserIds
      INSERT INTO @UserIds(UserId) SELECT Id FROM dbo.tbl_upm_User WHERE ParentId IN (SELECT UserId FROM @UserIds) AND Id NOT IN (SELECT UserId FROM @UserIds)
      SELECT @Count2=COUNT(*) FROM @UserIds
    END

    -- Select object id
    SELECT DISTINCT SourceId
    FROM (
      -- Get objects from parent role
      SELECT DISTINCT a.SourceId,1 IsGranted FROM dbo.tbl_upm_Object a, dbo.tbl_upm_ObjectToRole b 
      WHERE a.Id=b.ObjectId AND a.SourceType=@SourceType AND b.RoleId IN (SELECT DISTINCT RoleId FROM dbo.tbl_upm_UserToRole WHERE UserId IN (SELECT UserId FROM @ParentIds)) AND b.IsGranted=1
      UNION
      -- Get objects from user role
      SELECT DISTINCT a.SourceId,b.IsGranted FROM dbo.tbl_upm_Object a, dbo.tbl_upm_ObjectToRole b 
      WHERE a.Id=b.ObjectId AND a.SourceType=@SourceType AND b.RoleId IN (SELECT DISTINCT RoleId FROM dbo.tbl_upm_UserToRole WHERE UserId=@UserId)
      UNION
      -- Get objects from parent 
      SELECT DISTINCT a.SourceId,1 IsGranted FROM dbo.tbl_upm_Object a, dbo.tbl_upm_ObjectToUser b 
      WHERE a.Id=b.ObjectId AND a.SourceType=@SourceType AND b.UserId IN (SELECT UserId FROM @ParentIds) AND b.IsGranted=1
      UNION
      -- Get objects from user 
      SELECT DISTINCT a.SourceId,b.IsGranted FROM dbo.tbl_upm_Object a, dbo.tbl_upm_ObjectToUser b 
      WHERE a.Id=b.ObjectId AND a.SourceType=@SourceType AND b.UserId=@UserId
      UNION
      -- Get objects from children
      SELECT DISTINCT a.SourceId,1 IsGranted FROM dbo.tbl_upm_Object a,@UserIds b
      WHERE a.CreatedUserId=b.UserId AND a.SourceType=@SourceType
    ) UO
    GROUP BY SourceId
    HAVING MIN(CONVERT(bigint,IsGranted))=@IsGranted;
  END
END
GO
GRANT EXECUTE ON  [dbo].[usp_upm_GetObjectIds] TO [WebV4Role]
GO
