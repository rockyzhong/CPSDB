SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE PROCEDURE [dbo].[usp_trn_GetTransactionCount]
@PAN                        nvarchar(50) = NULL,
@NetworkId                  bigint       = NULL,
@IsoId                      bigint       = NULL,
@DeviceId                   bigint       = NULL,
@BeginDate                  datetime,
@EndDate                    datetime,
@SystemSettlementBeginDate  datetime     = NULL,
@SystemSettlementEndDate    datetime     = NULL,
@ReconciliationStatus       bigint       = NULL,
@TraceInitiator             bigint       = NULL,
@TraceDueDate               datetime     = NULL,
@TraceBankNo                nvarchar(50) = NULL,
@TraceStatus                bigint       = NULL,
@TraceDispensedStatus       bigint       = NULL,
@HasTrace                   bigint       = NULL,
@Sort                       bigint       = NULL,
@Count                      bigint       OUTPUT
WITH EXECUTE AS 'dbo'
AS
BEGIN
  SET NOCOUNT ON
  DECLARE @SQL nvarchar(max)
  SET @SQL='
  SELECT @Count=COUNT(*)
  FROM dbo.tbl_trn_Transaction t
  LEFT JOIN tbl_trn_Transactionreconandtrace trt ON t.Id=trt.TranId
  LEFT JOIN dbo.tbl_Device d ON t.DeviceId=d.Id LEFT JOIN dbo.tbl_Iso i ON d.IsoId=i.Id
  WHERE t.SystemTime>=@BeginDate AND t.SystemTime<@EndDate'
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
  EXEC sp_executesql @SQL,N'@PAN nvarchar(50),@NetworkId bigint,@IsoId bigint,@DeviceId bigint,@BeginDate datetime,@EndDate datetime,@SystemSettlementBeginDate datetime,@SystemSettlementEndDate datetime,@ReconciliationStatus 
bigint,@TraceInitiator bigint,@TraceDueDate datetime,@TraceBankNo nvarchar(50),@TraceStatus bigint,@TraceDispensedStatus bigint,@Count bigint 
OUTPUT',@PAN,@NetworkId,@IsoId,@DeviceId,@BeginDate,@EndDate,@SystemSettlementBeginDate,@SystemSettlementEndDate,@ReconciliationStatus,@TraceInitiator,@TraceDueDate,@TraceBankNo,@TraceStatus,@TraceDispensedStatus,@Count 
OUTPUT
  RETURN 0
END

GO
GRANT EXECUTE ON  [dbo].[usp_trn_GetTransactionCount] TO [WebV4Role]
GO
