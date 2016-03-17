SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Terence Xie
-- Create date: 2011-12-01
-- Description:	update user's login session data
-- =============================================
CREATE PROCEDURE  [dbo].[usp_upm_UpdateLoginSession]
	@sid nvarchar(50),
	@userId bigint,
	@terminalId bigint,
	@timeout bigint
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	update dbo.tbl_upm_UserSession set UpdatedDate=GETUTCDATE(),UserId=@userId,TerminalId=@terminalId,SessionTimeout=@timeout where SessionId=@sid
END
GO
GRANT EXECUTE ON  [dbo].[usp_upm_UpdateLoginSession] TO [WebV4Role]
GO
