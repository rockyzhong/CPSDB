SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_bak_InsertBankAccountSchedule]
@BankAccountScheduleId bigint OUT,
@BankAccountId         bigint,
@FundsType             bigint,
@ScheduleType          bigint,
@ScheduleDay           bigint,
@SchedulePayoutDay     bigint,
@ThresholdAmount       bigint,
@AchFileId             bigint,
@UpdatedUserId         bigint
AS
BEGIN
  SET NOCOUNT ON
  
  INSERT INTO dbo.tbl_BankAccountSchedule(BankAccountId,FundsType,ScheduleType,ScheduleDay,SchedulePayoutDay,ThresholdAmount,AchFileId,UpdatedUserId)
  VALUES(@BankAccountId,@FundsType,@ScheduleType,@ScheduleDay,@SchedulePayoutDay,@ThresholdAmount,@AchFileId,@UpdatedUserId)

  SELECT @BankAccountScheduleId=IDENT_CURRENT('tbl_BankAccountSchedule')
  
  RETURN 0
END
GO
GRANT EXECUTE ON  [dbo].[usp_bak_InsertBankAccountSchedule] TO [WebV4Role]
GO
