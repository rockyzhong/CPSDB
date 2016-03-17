SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create PROCEDURE [dbo].[usp_trn_DeleteTransactionReversal]
@TransactionReversalId bigint
AS
BEGIN
  SET NOCOUNT ON
  DELETE FROM dbo.tbl_trn_TransactionReversal WHERE Id=@TransactionReversalId
  RETURN 0
END
GO
