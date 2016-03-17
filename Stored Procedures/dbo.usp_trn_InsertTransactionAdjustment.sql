SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_trn_InsertTransactionAdjustment]
@TransactionAdjustmentId bigint OUTPUT,
@TransactionId           bigint,
@TransactionDate         datetime,
@BatchHeader             nvarchar(50),
@AmountSettlement        bigint,
@AmountSurcharge         bigint,
@Description             nvarchar(200),
@SettlementStatus        bigint,
@UpdatedUserId           bigint
AS
BEGIN
  SET NOCOUNT ON

  -- Get transaction data
  DECLARE @DeviceId bigint,@TransactionType bigint
  SELECT @DeviceId=DeviceId,@TransactionType=TransactionType FROM dbo.tbl_trn_Transaction WHERE Id=@TransactionId

  -- Insert adjustment record
  INSERT INTO dbo.tbl_trn_TransactionAdjustment(SystemDate,TransactionId,TransactionType,DeviceId,BatchHeader,AmountSettlement,AmountSurcharge,Description,SettlementStatus,UpdatedUserId)
  VALUES(GETUTCDATE(),@TransactionId,@TransactionType,@DeviceId,@BatchHeader,@AmountSettlement,@AmountSurcharge,@Description,@SettlementStatus,@UpdatedUserId)

  SELECT @TransactionAdjustmentId=IDENT_CURRENT('tbl_trn_TransactionAdjustment')
  
  RETURN 0
END
GO
GRANT EXECUTE ON  [dbo].[usp_trn_InsertTransactionAdjustment] TO [SAV4Role]
GRANT EXECUTE ON  [dbo].[usp_trn_InsertTransactionAdjustment] TO [WebV4Role]
GO
