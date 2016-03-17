SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_iso_GetReport]
@ReportId          bigint
AS
BEGIN
  SELECT * FROM dbo.tbl_Report WHERE Id=@ReportId
END
GO
GRANT EXECUTE ON  [dbo].[usp_iso_GetReport] TO [WebV4Role]
GO
