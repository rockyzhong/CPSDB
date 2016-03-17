SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[udf_GetValueName](@TypeId bigint,@Value bigint)
RETURNS nvarchar(200)
AS
BEGIN
  DECLARE @Name nvarchar(200)
  SELECT @Name=Name FROM dbo.tbl_TypeValue WHERE TypeId=@TypeId AND Value=@Value
  RETURN @Name
END
GO
