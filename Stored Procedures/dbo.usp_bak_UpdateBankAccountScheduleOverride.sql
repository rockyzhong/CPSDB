SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_bak_UpdateBankAccountScheduleOverride]
@BankAccountId       bigint,
@DeviceId            bigint,
@FundsType           bigint,
@ScheduleType        bigint,
@ScheduleDay         bigint,
@SchedulePayoutDay   bigint,
@ThresholdAmount     bigint,
@UpdatedUserId       bigint
AS
BEGIN
  SET NOCOUNT ON
  
  UPDATE dbo.tbl_BankAccountScheduleOverride SET 
  ScheduleType=@ScheduleType,ScheduleDay=@ScheduleDay,SchedulePayoutDay=@SchedulePayoutDay,ThresholdAmount=@ThresholdAmount,UpdatedUserId=@UpdatedUserId
  WHERE BankAccountId=@BankAccountId AND DeviceId=@DeviceId AND FundsType=@FundsType
  
  RETURN 0
END
GO
GRANT EXECUTE ON  [dbo].[usp_bak_UpdateBankAccountScheduleOverride] TO [WebV4Role]
GO
