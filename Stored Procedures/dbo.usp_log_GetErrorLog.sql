SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_log_GetErrorLog]
@ErrorLogId     bigint
AS
BEGIN
  SELECT e.Id,e.Source,e.Type,e.Message,e.Trace,e.CreatedDate,e.UpdatedUserId,u.UserName UpdatedUserName
  FROM dbo.tbl_ErrorLog e
  LEFT JOIN dbo.tbl_upm_User u ON e.UpdatedUserId=u.Id
  WHERE e.Id=@ErrorLogId
END
GO
GRANT EXECUTE ON  [dbo].[usp_log_GetErrorLog] TO [WebV4Role]
GO
