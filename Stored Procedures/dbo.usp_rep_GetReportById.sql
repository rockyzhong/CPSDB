SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_rep_GetReportById]
    @ReportID bigint,
    @UserID bigint
AS
-- Revision 1.0.0 2012.02.21 by Eason Xiao
-- Initial Revision

SET NOCOUNT ON
DECLARE @Object TABLE (SourceId bigint)
-- INSERT INTO @Object EXEC dbo.usp_upm_GetObjectIds @UserID, 7, 1

SELECT rep.Id ReportId, rep.ReportGroup, rep.ReportName, rep.ReportSchemas, rep.GeneratorId, rep.ReportSequence, rep.OutputFormats,
    rep.IsBatchReport, rep.IsOnlineReport, rep.UpdatedUserId, rep.Description,rep.RequireTime, repg.ClassName
FROM [dbo].[tbl_Report] rep
-- inner join @Object ol on rep.Id = ol.SourceId
inner join [dbo].[tbl_report_generator] repg on rep.GeneratorId = repg.Id
where rep.id = @reportId
GO
GRANT EXECUTE ON  [dbo].[usp_rep_GetReportById] TO [WebV4Role]
GO
