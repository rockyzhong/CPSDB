SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_log_GetEJHistoryFileDate]
@DeviceId bigint
AS
  SELECT DATEADD(dd,0,DATEDIFF(dd,0,FileDate))
  FROM dbo.tbl_EJHistory
  WHERE DeviceId = @DeviceId
  GROUP BY DATEADD(dd,0,DATEDIFF(dd,0,FileDate))
  ORDER BY DATEADD(dd,0,DATEDIFF(dd,0,FileDate)) DESC
GO
GRANT EXECUTE ON  [dbo].[usp_log_GetEJHistoryFileDate] TO [WebV4Role]
GO
