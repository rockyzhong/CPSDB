SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE FUNCTION [dbo].[udf_GetSourceName] (@SourceType bigint,@SourceId bigint)
RETURNS nvarchar(50)
AS
BEGIN
  DECLARE @SourceName nvarchar(50) = ''

  IF @SourceType=1      SELECT @SourceName=TerminalName          FROM dbo.tbl_Device            WHERE Id=@SourceId
  ELSE IF @SourceType=2 SELECT @SourceName=UserName              FROM dbo.tbl_upm_User          WHERE Id=@SourceId
  ELSE IF @SourceType=3 SELECT @SourceName=Rta                   FROM dbo.tbl_BankAccount       WHERE Id=@SourceId
  ELSE IF @SourceType=4 SELECT @SourceName=RegisteredName        FROM dbo.tbl_Iso               WHERE Id=@SourceId
  ELSE IF @SourceType=5 SELECT @SourceName=InterchangeSchemeName FROM dbo.tbl_InterchangeScheme WHERE Id=@SourceId
  ELSE IF @SourceType=6 SELECT @SourceName=NetworkName           FROM dbo.tbl_Network           WHERE Id=@SourceId
  ELSE IF @SourceType=7 SELECT @SourceName=ReportName            FROM dbo.tbl_Report            WHERE Id=@SourceId
  ELSE IF @SourceType=8 SELECT @SourceName=RoleName              FROM dbo.tbl_upm_Role          WHERE Id=@SourceId

  RETURN @SourceName
END
GO
