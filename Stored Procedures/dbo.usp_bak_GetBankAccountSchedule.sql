SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_bak_GetBankAccountSchedule]
@BankAccountId       bigint,
@FundsType           bigint = 0
AS
BEGIN
  SET NOCOUNT ON

  SELECT Id, BankAccountId, FundsType,ScheduleType,ScheduleDay,SchedulePayoutDay,ThresholdAmount,AchFileId
  FROM dbo.tbl_BankAccountSchedule
  WHERE BankAccountId=@BankAccountId AND (@FundsType=0 OR FundsType=@FundsType)
END
GO
GRANT EXECUTE ON  [dbo].[usp_bak_GetBankAccountSchedule] TO [WebV4Role]
GO
