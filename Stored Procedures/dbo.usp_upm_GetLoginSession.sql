SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE  [dbo].[usp_upm_GetLoginSession]
	@sid nvarchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	select s.Id,s.SessionId,s.SessionTimeout,s.UpdatedDate,s.UserId,u.UserName,s.TerminalId,DATEDIFF(second,UpdatedDate,GETUTCDATE())as TimeDiff from tbl_upm_UserSession s,tbl_upm_User u where SessionId=@sid and u.Id=s.UserId
END
GO
GRANT EXECUTE ON  [dbo].[usp_upm_GetLoginSession] TO [WebV4Role]
GO
