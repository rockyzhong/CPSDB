SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE FUNCTION [dbo].[udf_GetSettlementDate] (@TransactionId bigint,@BankAccountId bigint,@FundsType bigint)
RETURNS datetime
AS
BEGIN
  DECLARE @SystemDate datetime,@SettlementDate datetime
  SELECT @SystemDate=SystemDate FROM dbo.tbl_trn_Transaction WHERE Id=@TransactionId
  SELECT @SettlementDate=MIN(SettlementDate) FROM dbo.tbl_AchTransaction WHERE BankAccountId=@BankAccountId AND FundsType=@FundsType AND SettlementTime>@SystemDate
  RETURN @SettlementDate
END
GO
