SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/**/
/**/
/**/
CREATE PROCEDURE [dbo].[usp_sys_CreateJobs]
@Add nvarchar(10) = N'Y',
@Delete nvarchar(10) = N'N'
AS
BEGIN
EXEC [dbo].[usp_sys_CreateMaintainRecordsJob] @Add=@Add,@Delete=@Delete
EXEC [dbo].[usp_sys_CreateReconciliationSettlementJob] @Add=@Add,@Delete=@Delete
EXEC [dbo].[usp_sys_CreateImportBinRangeFileJob] @Add=@Add,@Delete=@Delete
END
GO
GRANT EXECUTE ON  [dbo].[usp_sys_CreateJobs] TO [WebV4Role]
GO
