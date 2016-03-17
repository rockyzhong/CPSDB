SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/***** Get Bank account payout date *****/
CREATE FUNCTION [dbo].[udf_GetPayoutDays](@BankAccountId bigint,@SourceType bigint,@SourceId bigint,@FundsType bigint)
RETURNS bigint
AS
BEGIN
  DECLARE @PayoutDays bigint
  SELECT @PayoutDays=SchedulePayoutDay FROM dbo.tbl_BankAccountSchedule WHERE BankAccountId=@BankAccountId AND FundsType=@FundsType
  IF @SourceType=1
    SELECT @PayoutDays=SchedulePayoutDay FROM dbo.tbl_BankAccountScheduleOverride WHERE BankAccountId=@BankAccountId AND DeviceId=@SourceId AND FundsType=@FundsType AND ScheduleType IN (1,2,3)
  IF @PayoutDays IS NULL  SET @PayoutDays=0
  RETURN @PayoutDays
END
GO
