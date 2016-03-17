SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
--Encryption extend procedure
CREATE PROCEDURE [dbo].[usp_sys_EncryptExt] (@Data nvarchar(max),@DataHash varbinary(max) OUTPUT, @DataEncrypted varbinary(max) OUTPUT)
AS
BEGIN
  SET NOCOUNT ON
  EXEC dbo.usp_sys_Hash    @Data,@DataHash      OUTPUT
  EXEC dbo.usp_sys_Encrypt @Data,@DataEncrypted OUTPUT
  RETURN 0
END
GO
GRANT EXECUTE ON  [dbo].[usp_sys_EncryptExt] TO [WebV4Role]
GO
