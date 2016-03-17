SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_bak_DeleteBankAccountScheduleOverride]
@BankAccountId       bigint,
@DeviceId            bigint,
@UpdatedUserId       bigint
AS
BEGIN
  SET NOCOUNT ON
  
  UPDATE dbo.tbl_BankAccountScheduleOverride SET UpdatedUserId=@UpdatedUserId WHERE BankAccountId=@BankAccountId AND DeviceId=@DeviceId
  DELETE FROM dbo.tbl_BankAccountScheduleOverride WHERE BankAccountId=@BankAccountId AND DeviceId=@DeviceId
  
  RETURN 0
END
GO
GRANT EXECUTE ON  [dbo].[usp_bak_DeleteBankAccountScheduleOverride] TO [WebV4Role]
GO
