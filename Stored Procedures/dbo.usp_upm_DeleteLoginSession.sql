SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE  [dbo].[usp_upm_DeleteLoginSession]
	@sid nvarchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	delete tbl_upm_UserSession where SessionId=@sid
END
GO
GRANT EXECUTE ON  [dbo].[usp_upm_DeleteLoginSession] TO [WebV4Role]
GO
