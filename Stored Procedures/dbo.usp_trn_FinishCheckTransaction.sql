SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[usp_trn_FinishCheckTransaction]
  @TransactionId           bigint
 ,@TransactionDate         datetime
 ,@PayoutCash              bigint
 ,@PayoutDeposit           bigint
 ,@PayoutChips             bigint
 ,@PayoutMarker            bigint
 ,@PayoutOther             bigint
 ,@PayoutStatus            bigint
 ,@Imagedata               varbinary(MAX)
 ,@Title31Posted           bit
 ,@ACHEcheckAck			   nvarchar(1)
 ,@CreatedUserId           bigint        
AS
BEGIN
  SET NOCOUNT ON

  UPDATE dbo.tbl_trn_Transaction SET 
  PayoutCash=@PayoutCash,PayoutDeposit=@PayoutDeposit,PayoutChips=@PayoutChips,
  PayoutMarker=@PayoutMarker,PayoutOther=@PayoutOther,PayoutStatus=@PayoutStatus,
  Title31Posted=@Title31Posted,ACHECheckAck=@ACHEcheckAck,
  CreatedUserId=@CreatedUserId
  WHERE Id=@TransactionId
  IF not exists (select tranid from tbl_trn_TransactionreExtendedColumn where TranId=@TransactionId)
  Insert into  dbo.tbl_trn_TransactionreExtendedColumn ([TranId],[ImageData]) values (@TransactionId,@Imagedata)
  ELSE
  UPDATE dbo.tbl_trn_TransactionreExtendedColumn SET
  ImageData=@Imagedata
  WHERE TranId=@TransactionId
  RETURN 0
END

GO
GRANT EXECUTE ON  [dbo].[usp_trn_FinishCheckTransaction] TO [SAV4Role]
GRANT EXECUTE ON  [dbo].[usp_trn_FinishCheckTransaction] TO [WebV4Role]
GO
