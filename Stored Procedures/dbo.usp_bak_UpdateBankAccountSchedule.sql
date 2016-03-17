SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_bak_UpdateBankAccountSchedule]
@BankAccountId       bigint,
@FundsType           bigint,
@ScheduleType        bigint,
@ScheduleDay         bigint,
@SchedulePayoutDay   bigint,
@ThresholdAmount     bigint,
@AchFileId           bigint,
@UpdatedUserId       bigint
AS
BEGIN
  SET NOCOUNT ON
  
  UPDATE dbo.tbl_BankAccountSchedule SET 
  ScheduleType=@ScheduleType,ScheduleDay=@ScheduleDay,SchedulePayoutDay=@SchedulePayoutDay,
  ThresholdAmount=@ThresholdAmount,AchFileId=@AchFileId,UpdatedUserId=@UpdatedUserId
  WHERE BankAccountId=@BankAccountId AND FundsType=@FundsType
  
  RETURN 0
END
GO
GRANT EXECUTE ON  [dbo].[usp_bak_UpdateBankAccountSchedule] TO [WebV4Role]
GO
