SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[usp_trn_UpdateTransactionReconciliationStatus]
@TransactionId           bigint,
@TransactionDate         datetime,
@ReconciliationStatus    bigint,
@ReconciliationComment   nvarchar(200)
AS
BEGIN
  SET NOCOUNT ON

  UPDATE dbo.tbl_trn_Transactionreconandtrace  SET ReconciliationStatus=@ReconciliationStatus,ReconciliationComment=@ReconciliationComment WHERE TranId=@TransactionId
  UPDATE dbo.tbl_trn_TransactionReconciliation SET ReconciliationStatus=@ReconciliationStatus,ReconciliationComment=@ReconciliationComment WHERE TransactionId=@TransactionId

  RETURN 0
END
GO
GRANT EXECUTE ON  [dbo].[usp_trn_UpdateTransactionReconciliationStatus] TO [WebV4Role]
GO
