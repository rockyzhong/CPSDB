SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE PROCEDURE [dbo].[usp_trn_GetTransactionById]
@TransactionId           bigint,
@TransactionDate         datetime
AS
BEGIN
  SET NOCOUNT ON

  SELECT 
    t.Id TransactionId,t.SystemDate,t.SystemTime,t.SystemSettlementDate,t.TransactionType,t.TransactionReason,
    i.Id IsoId,i.RegisteredName,d.Id DeviceId,d.TerminalName,t.DeviceDate,t.DeviceSequence,
    n.Id NetworkId,n.NetworkCode,n.NetworkName,t.NetworkSettlementDate1,t.NetworkSettlementDate2,
    t.AmountRequest,t.AmountAuthenticate,t.AmountSettlement-t.AmountSurcharge AmountDispensed,
    t.AmountSurcharge,t.AmountSettlement,t.AmountSettlementDestination,t.AmountSettlementReconciliation,tf.AmountInterchange,
    t.ResponseCodeInternal,t.ResponseCodeExternal,CASE WHEN t.NetworkId=301 THEN r1.Description ELSE r2.Description END  
ResponseTextExternal,t.PAN,t.ReferenceNumber,t.SourceAccountType,t.IssuerNetworkId,tr.ReconciliationStatus,tr.ReconciliationComment,tr.UnreconciledStatus,
tr.TraceInitiator,tr.TraceOpenedDate,tr.TraceOpenedUserId,tr.TraceReopenedDate,tr.TraceReopenedUserId,tr.TraceDueDate,tr.TraceClosedDate,tr.TraceClosedUserId,tr.TraceStatus,tr.TraceDispensedStatus,tr.TraceBankNo,tr.TraceBankClaimNo,tr.TraceCreditDate,tr.TraceCreditAmount,tr.TraceTranmissionType,tr.TraceMailAddress,tr.TraceLetterComment,tr.TraceInternalComment,u1.UserName TraceOpenedUserName,u2.UserName TraceReopenedUserName,u3.UserName TraceClosedUserName
  FROM dbo.tbl_trn_Transaction t 
  LEFT JOIN dbo.tbl_trn_TransactionAmountInter tf ON t.Id=tf.TranId
  LEFT JOIN dbo.tbl_trn_Transactionreconandtrace tr ON t.Id=tr.TranId
  LEFT JOIN dbo.tbl_Network n ON t.NetworkId=n.Id 
  LEFT JOIN dbo.tbl_Device d ON t.DeviceId=d.Id LEFT JOIN dbo.tbl_Iso i ON d.IsoId=i.Id
  LEFT JOIN dbo.tbl_ResponseCode r1 ON t.NetworkId=301 AND t.ResponseTypeId=r1.ResponseTypeId AND t.ResponseCodeExternal=r1.ResponseCodeExternal AND (t.ResponseSubCodeExternal=r1.ResponseSubCodeExternal OR  
(t.ResponseSubCodeExternal IS NULL AND r1.ResponseSubCodeExternal IS NULL))
  LEFT JOIN dbo.tbl_NetworkResponseCodeExternal r2 ON t.NetworkId=r2.NetworkId AND t.ResponseCodeExternal=r2.ResponseCodeExternal
  LEFT JOIN dbo.tbl_upm_User u1 ON tr.TraceOpenedUserId=u1.Id
  LEFT JOIN dbo.tbl_upm_User u2 ON tr.TraceReopenedUserId=u2.Id
  LEFT JOIN dbo.tbl_upm_User u3 ON tr.TraceClosedUserId=u3.Id
  WHERE t.Id=@TransactionId
END
GO
GRANT EXECUTE ON  [dbo].[usp_trn_GetTransactionById] TO [SAV4Role]
GRANT EXECUTE ON  [dbo].[usp_trn_GetTransactionById] TO [WebV4Role]
GO
