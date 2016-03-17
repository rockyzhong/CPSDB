SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[udf_GetSubUserCount](@UserId bigint)
RETURNS bigint
AS
BEGIN
  DECLARE @Count bigint
  SELECT @Count=COUNT(*) FROM dbo.tbl_upm_User WHERE ParentId=@UserId
  RETURN @Count
END
GO
