SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_bak_GetBankAccountAllocatedAmount]
@BankAccountId    bigint,
@Amount           money OUTPUT
AS
BEGIN
  SET NOCOUNT ON
  SELECT @Amount=SUM(Amount) FROM dbo.tbl_trn_TransactionAllocation WHERE SettlementDate IS NULL AND BankAccountId=@BankAccountId
  RETURN 0
END
GO
