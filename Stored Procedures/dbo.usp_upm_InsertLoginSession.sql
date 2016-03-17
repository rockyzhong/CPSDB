SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE  [dbo].[usp_upm_InsertLoginSession]
	@userId bigint,
	@sid nvarchar(50),
	@timeout bigint
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	insert into dbo.tbl_upm_UserSession (UserId,SessionId,SessionTimeout,UpdatedDate,UpdatedUserId) values(@userId,@sid,@timeout,GETUTCDATE(),@userId)
END
GO
GRANT EXECUTE ON  [dbo].[usp_upm_InsertLoginSession] TO [WebV4Role]
GO
