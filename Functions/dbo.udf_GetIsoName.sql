SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE FUNCTION [dbo].[udf_GetIsoName] (@SourceType bigint,@SourceId bigint)
RETURNS nvarchar(50)
AS
BEGIN
  DECLARE @IsoName nvarchar(50) = ''
  IF @SourceType=1      SELECT @IsoName=b.RegisteredName FROM dbo.tbl_Device      a JOIN dbo.tbl_Iso b ON a.IsoId=b.Id WHERE a.Id=@SourceId
  ELSE IF @SourceType=2 SELECT @IsoName=b.RegisteredName FROM dbo.tbl_upm_User    a JOIN dbo.tbl_Iso b ON a.IsoId=b.Id WHERE a.Id=@SourceId
  ELSE IF @SourceType=3 SELECT @IsoName=b.RegisteredName FROM dbo.tbl_BankAccount a JOIN dbo.tbl_Iso b ON a.IsoId=b.Id WHERE a.Id=@SourceId
  ELSE IF @SourceType=4 SELECT @IsoName=RegisteredName   FROM dbo.tbl_Iso WHERE Id=@SourceId
  RETURN @IsoName
END
GO
