SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Terence Xie
-- Create date: 2011-08-22
-- Description:	delete user session from table
-- =============================================
CREATE PROCEDURE [dbo].[usp_upm_DeleteLoginSessionByUserId] 
	@userId bigint
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	-- only allow user login once at any moment.
	delete tbl_upm_UserSession where UserId=@userId 
	
END
GO
GRANT EXECUTE ON  [dbo].[usp_upm_DeleteLoginSessionByUserId] TO [WebV4Role]
GO
