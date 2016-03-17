SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- Hash procedure
CREATE PROCEDURE [dbo].[usp_sys_Hash](@Data nvarchar(max),@Value varbinary(max) OUTPUT)
AS
BEGIN
  SET @Value = HASHBYTES('SHA1', @Data);
END
GO
GRANT EXECUTE ON  [dbo].[usp_sys_Hash] TO [WebV4Role]
GO
