SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_bak_InsertBankAccountScheduleOverride]
@BankAccountScheduleOverrideId bigint OUTPUT,
@BankAccountId                 bigint,
@DeviceId                      bigint,
@FundsType                     bigint,
@ScheduleType                  bigint,
@ScheduleDay                   bigint,
@SchedulePayoutDay             bigint,
@ThresholdAmount               bigint,
@UpdatedUserId                 bigint
AS
BEGIN
  SET NOCOUNT ON
  
  INSERT INTO dbo.tbl_BankAccountScheduleOverride(BankAccountId,DeviceId,FundsType,ScheduleType,ScheduleDay,SchedulePayoutDay,ThresholdAmount,UpdatedUserId)
  VALUES(@BankAccountId,@DeviceId,@FundsType,@ScheduleType,@ScheduleDay,@SchedulePayoutDay,@ThresholdAmount,@UpdatedUserId)

  SELECT @BankAccountScheduleOverrideId=IDENT_CURRENT('tbl_BankAccountScheduleOverride')
  
  RETURN 0
END
GO
GRANT EXECUTE ON  [dbo].[usp_bak_InsertBankAccountScheduleOverride] TO [WebV4Role]
GO
