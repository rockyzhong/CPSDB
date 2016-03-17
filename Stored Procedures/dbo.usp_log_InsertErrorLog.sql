SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_log_InsertErrorLog]
@ErrorLogId     bigint  OUTPUT,
@Source         nvarchar(200),
@Type           nvarchar(200),
@Message        nvarchar(1000),
@Trace          nvarchar(max),
@CreatedDate    datetime,
@UpdatedUserId  bigint
AS
BEGIN
  SET NOCOUNT ON

  INSERT INTO dbo.tbl_ErrorLog(Source,Type,Message,Trace,CreatedDate,UpdatedUserId) VALUES(@Source,@Type,@Message,@Trace,@CreatedDate,@UpdatedUserId)
  SELECT @ErrorLogId=IDENT_CURRENT('tbl_ErrorLog')

  RETURN 0
END
GO
GRANT EXECUTE ON  [dbo].[usp_log_InsertErrorLog] TO [WebV4Role]
GO
