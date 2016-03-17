SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_log_GetErrorLogs]
@StartDate     datetime,
@EndDate       datetime,
@UpdatedUserId bigint
AS
BEGIN
  SELECT e.Id,e.Source,e.Type,e.Message,e.Trace,e.CreatedDate,e.UpdatedUserId,u.UserName UpdatedUserName
  FROM dbo.tbl_ErrorLog e
  LEFT JOIN dbo.tbl_upm_User u ON e.UpdatedUserId=u.Id
  WHERE e.CreatedDate>=@StartDate AND e.CreatedDate<=@EndDate AND (@UpdatedUserId IS NULL OR e.UpdatedUserId=@UpdatedUserId)
  ORDER BY e.CreatedDate
END
GO
GRANT EXECUTE ON  [dbo].[usp_log_GetErrorLogs] TO [WebV4Role]
GO
