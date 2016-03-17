SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_sys_UpdateContact] (
@ContactId        bigint,
@FirstName        nvarchar(50),
@LastName         nvarchar(50),
@MiddleInitial    nvarchar(50),
@Title            nvarchar(50),
@UpdatedUserId    bigint)
AS
BEGIN
  SET NOCOUNT ON

  UPDATE dbo.tbl_Contact SET FirstName=@FirstName,LastName=@LastName,MiddleInitial=@MiddleInitial,Title=@Title,UpdatedUserId=@UpdatedUserId WHERE Id=@ContactId
  
  RETURN 0
END
GO
GRANT EXECUTE ON  [dbo].[usp_sys_UpdateContact] TO [WebV4Role]
GO
