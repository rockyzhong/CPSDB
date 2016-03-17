SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE PROCEDURE [dbo].[usp_trn_UpdateTransactionTrace]
@TransactionId           bigint,
@TransactionDate         datetime,
@TraceInitiator          bigint,
@TraceOpenedDate         datetime,
@TraceOpenedUserId       bigint,
@TraceReopenedDate       datetime,
@TraceReopenedUserId     bigint,
@TraceDueDate            datetime,
@TraceClosedDate         datetime,
@TraceClosedUserId       bigint,
@TraceStatus             bigint,
@TraceDispensedStatus    bigint,
@TraceBankNo             nvarchar(50),
@TraceBankClaimNo        nvarchar(50),
@TraceCreditDate         datetime,
@TraceCreditAmount       money,
@TraceTranmissionType    bigint,
@TraceMailAddress        nvarchar(50), 
@TraceLetterComment      nvarchar(50),
@TraceInternalComment    nvarchar(50)
AS
BEGIN
  SET NOCOUNT ON
  IF EXISTS (SELECT TranId FROM dbo.tbl_trn_Transactionreconandtrace WHERE TranId = @TransactionId) 
  UPDATE dbo.tbl_trn_Transactionreconandtrace SET 
  TraceInitiator=@TraceInitiator,TraceOpenedDate=@TraceOpenedDate,TraceOpenedUserId=@TraceOpenedUserId,TraceReopenedDate=@TraceReopenedDate,
  TraceReopenedUserId=@TraceReopenedUserId,TraceDueDate=@TraceDueDate,TraceClosedDate=@TraceClosedDate,TraceClosedUserId=@TraceClosedUserId,
  TraceStatus=@TraceStatus,TraceDispensedStatus=@TraceDispensedStatus,TraceBankNo=@TraceBankNo,TraceBankClaimNo=@TraceBankClaimNo,
  TraceCreditDate=@TraceCreditDate,TraceCreditAmount=@TraceCreditAmount,TraceTranmissionType=@TraceTranmissionType,
  TraceMailAddress=@TraceMailAddress,TraceLetterComment=@TraceLetterComment,TraceInternalComment=@TraceInternalComment
  WHERE TranId=@TransactionId
  ElSE
  INSERT INTO dbo.tbl_trn_Transactionreconandtrace  values(
  @TransactionId,
  null,null,null,
  @TraceInitiator,
  @TraceOpenedDate,
  @TraceOpenedUserId,
  @TraceReopenedDate,
  @TraceReopenedUserId,
  @TraceDueDate,
  @TraceClosedDate,
  @TraceClosedUserId,
  @TraceStatus,
  @TraceDispensedStatus,
  @TraceBankNo,
  @TraceBankClaimNo,
  @TraceCreditDate,
  @TraceCreditAmount,
  @TraceTranmissionType,
  @TraceMailAddress, 
  @TraceLetterComment,
  @TraceInternalComment)
  RETURN 0
END

GO
GRANT EXECUTE ON  [dbo].[usp_trn_UpdateTransactionTrace] TO [WebV4Role]
GO
