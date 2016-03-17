SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[usp_trn_GetTransactions]
@TransactionId              bigint       = NULL,
@PAN                        nvarchar(50) = NULL,
@NetworkId                  bigint       = NULL,
@IsoId                      bigint       = NULL,
@DeviceId                   bigint       = NULL,
@BeginDate                  datetime     = NULL,
@EndDate                    datetime     = NULL,
@SystemSettlementBeginDate  datetime     = NULL,
@SystemSettlementEndDate    datetime     = NULL,
@ReconciliationStatus       bigint       = NULL,
@TraceInitiator             bigint       = NULL,
@TraceDueDate               datetime     = NULL,
@TraceBankNo                nvarchar(50) = NULL,
@TraceStatus                bigint       = NULL,
@TraceDispensedStatus       bigint       = NULL,
@HasTrace                   bigint       = NULL,
@Sort                       bigint       = NULL
WITH EXECUTE AS 'dbo'
AS
BEGIN
  SET NOCOUNT ON
  DECLARE @SQL nvarchar(max)
  SET @SQL='
  SELECT 
    t.Id TransactionId,i.Id IsoId,i.RegisteredName,d.Id DeviceId,d.TerminalName,t.DeviceSequence,
    t.SystemDate,t.SystemTime,t.SystemSettlementDate,t.TransactionType,t.PAN,
    t.AmountRequest,t.AmountAuthenticate,t.AmountSettlement,t.AmountSettlementReconciliation,t.AmountSurcharge,t.AmountSettlement-t.AmountSurcharge AmountDispensed,tr.AmountInterchange,
    t.ResponseCodeInternal,t.ResponseCodeExternal,CASE WHEN t.NetworkId=301 THEN r1.Description ELSE r2.Description END ResponseTextExternal,t.SourceAccountType,t.IssuerNetworkId,trt.ReconciliationStatus,
    trt.TraceOpenedDate,trt.TraceDueDate,trt.TraceStatus,trt.TraceLetterComment
  FROM dbo.tbl_trn_Transaction t
  LEFT JOIN dbo.tbl_trn_TransactionAmountInter tr ON t.Id=tr.TranId
  LEFT JOIN dbo.tbl_trn_Transactionreconandtrace trt ON t.Id=trt.TranId
  LEFT JOIN dbo.tbl_Device d ON t.DeviceId=d.Id LEFT JOIN dbo.tbl_Iso i ON d.IsoId=i.Id
  LEFT JOIN dbo.tbl_ResponseCode r1 ON t.NetworkId=301 AND t.ResponseTypeId=r1.ResponseTypeId AND t.ResponseCodeExternal=r1.ResponseCodeExternal AND (t.ResponseSubCodeExternal=r1.ResponseSubCodeExternal OR 
(t.ResponseSubCodeExternal IS NULL AND r1.ResponseSubCodeExternal IS NULL))
  LEFT JOIN dbo.tbl_NetworkResponseCodeExternal r2 ON t.NetworkId=r2.NetworkId AND t.ResponseCodeExternal=r2.ResponseCodeExternal
  WHERE '
  IF @TransactionId IS NOT NULL
  BEGIN
    SET @SQL=@SQL+'t.Id=@TransactionId AND trt.TraceOpenedDate IS NOT NULL'
    EXEC sp_executesql @SQL,N'@TransactionId bigint',@TransactionId
  END  
  ELSE
  BEGIN  
    SET @SQL=@SQL+'t.SystemTime>=@BeginDate AND t.SystemTime<@EndDate'
    IF @PAN                       IS NOT NULL  SET @SQL=@SQL+' AND t.PAN=@PAN'
    IF @NetworkId                 IS NOT NULL  SET @SQL=@SQL+' AND t.NetworkId=@NetworkId'
    IF @IsoId                     IS NOT NULL  SET @SQL=@SQL+' AND d.IsoId IN (SELECT @IsoId AS Id UNION SELECT Id FROM dbo.tbl_Iso WHERE ParentId=@IsoId)'
    IF @DeviceId                  IS NOT NULL  SET @SQL=@SQL+' AND t.DeviceId=@DeviceId'
    IF @SystemSettlementBeginDate IS NOT NULL  SET @SQL=@SQL+' AND t.SystemSettlementDate>=@SystemSettlementBeginDate'
    IF @SystemSettlementEndDate   IS NOT NULL  SET @SQL=@SQL+' AND t.SystemSettlementDate<@SystemSettlementEndDate'
    IF @ReconciliationStatus      IS NOT NULL  SET @SQL=@SQL+' AND trt.ReconciliationStatus=@ReconciliationStatus'
    IF @TraceInitiator            IS NOT NULL  SET @SQL=@SQL+' AND trt.TraceInitiator=@TraceInitiator'
    IF @TraceDueDate              IS NOT NULL  SET @SQL=@SQL+' AND trt.TraceDueDate=@TraceDueDate'
    IF @TraceBankNo               IS NOT NULL  SET @SQL=@SQL+' AND trt.TraceBankNo=@TraceBankNo'  
    IF @TraceStatus=99                         SET @SQL=@SQL+' AND trt.TraceStatus IN (1,4)'
    ELSE IF @TraceStatus          IS NOT NULL  SET @SQL=@SQL+' AND trt.TraceStatus=@TraceStatus'
    IF @TraceDispensedStatus      IS NOT NULL  SET @SQL=@SQL+' AND trt.TraceDispensedStatus=@TraceDispensedStatus'
  
    IF @HasTrace=1  SET @SQL=@SQL+' AND trt.TraceOpenedDate IS NOT NULL'
    IF @Sort=1      SET @SQL=@SQL+' ORDER BY t.SystemDate'
    ELSE IF @Sort=2 SET @SQL=@SQL+' ORDER BY d.TerminalName'
    ELSE IF @Sort=3 SET @SQL=@SQL+' ORDER BY trt.TraceOpenedDate'
    EXEC sp_executesql @SQL,N'@PAN nvarchar(50),@NetworkId bigint,@IsoId bigint,@DeviceId bigint,@BeginDate datetime,@EndDate datetime,@SystemSettlementBeginDate datetime,@SystemSettlementEndDate datetime,@ReconciliationStatus 
bigint,@TraceInitiator bigint,@TraceDueDate datetime,@TraceBankNo nvarchar(50),@TraceStatus bigint,@TraceDispensedStatus 
bigint',@PAN,@NetworkId,@IsoId,@DeviceId,@BeginDate,@EndDate,@SystemSettlementBeginDate,@SystemSettlementEndDate,@ReconciliationStatus,@TraceInitiator,@TraceDueDate,@TraceBankNo,@TraceStatus,@TraceDispensedStatus
  END  
END

GO
GRANT EXECUTE ON  [dbo].[usp_trn_GetTransactions] TO [WebV4Role]
GO
