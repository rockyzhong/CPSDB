SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[usp_rep_CageHeader]
    @UserID bigint,
    @TimeZone varchar(50)
AS
BEGIN
    SET NOCOUNT ON
    SELECT Convert(datetime, SWITCHOFFSET(CONVERT(VARCHAR,getutcdate(), 20) + ' +00:00',@TimeZone))  NowLocal,(u.FirstName + ',' +u.LastName) as uname,  iso.RegisteredName
    FROM dbo.tbl_upm_User u INNER JOIN dbo.tbl_Iso iso on u.isoID=iso.ID
    WHERE u.ID = @UserID
END
GO
GRANT EXECUTE ON  [dbo].[usp_rep_CageHeader] TO [WebV4Role]
GO
