SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_rep_GetReportParameters]
    @ReportID bigint
AS
BEGIN
    SET NOCOUNT ON
    select * from tbl_report_parameter where reportId = @ReportID order by displaySequence
END
GO
GRANT EXECUTE ON  [dbo].[usp_rep_GetReportParameters] TO [WebV4Role]
GO
