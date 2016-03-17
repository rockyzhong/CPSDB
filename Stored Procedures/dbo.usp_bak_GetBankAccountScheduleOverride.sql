SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_bak_GetBankAccountScheduleOverride]
@BankAccountId       bigint,
@DeviceId            bigint
AS
BEGIN
  SELECT a.BankAccountId,a.DeviceId,d.TerminalName,
         a.ScheduleType SettlementScheduleType, a.ScheduleDay SettlementScheduleDay, a.SchedulePayoutDay SettlementSchedulePayoutDay, a.ThresholdAmount SettlementThresholdAmount,
         b.ScheduleType SurchargeScheduleType,  b.ScheduleDay SurchargeScheduleDay,  b.SchedulePayoutDay SurchargeSchedulePayoutDay,  b.ThresholdAmount SurchargeThresholdAmount,
         c.ScheduleType InterchangeScheduleType,c.ScheduleDay InterchangeScheduleDay,c.SchedulePayoutDay InterchangeSchedulePayoutDay,c.ThresholdAmount InterchangeThresholdAmount
         FROM dbo.tbl_BankAccountScheduleOverride a 
         JOIN dbo.tbl_BankAccountScheduleOverride b ON a.BankAccountId=b.BankAccountId AND a.DeviceId=b.DeviceId AND b.FundsType=2
         JOIN dbo.tbl_BankAccountScheduleOverride c ON a.BankAccountId=c.BankAccountId AND a.DeviceId=c.DeviceId AND c.FundsType=3
         JOIN dbo.tbl_Device d ON a.DeviceId=d.Id
         WHERE a.BankAccountId=@BankAccountId AND a.DeviceId=@DeviceId AND a.FundsType=1
END
GO
GRANT EXECUTE ON  [dbo].[usp_bak_GetBankAccountScheduleOverride] TO [WebV4Role]
GO
