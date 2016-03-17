SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[usp_trn_GetOriginalTransaction]
  @DeviceName             nvarchar(50)
 ,@DeviceSequence         bigint
 ,@DeviceDate             datetime
 ,@CustomerMediaData      nvarchar(200)
 ,@ResponseCodeInternal   bigint = 0
 ,@TransactionFlags       bigint = 0

AS
-- Revision 1.1.0 2015.06.11 by Adam Glover
--   Add Time Filter
BEGIN
  DECLARE @DeviceId bigint,@CustomerMediaDataHash varbinary(512)
  SELECT @DeviceId=Id FROM dbo.tbl_Device WHERE TerminalName=@DeviceName
  EXEC dbo.usp_sys_Hash @CustomerMediaData,@CustomerMediaDataHash OUT
  SELECT TOP 1 
    t.OriginalTransactionId,t.Id TransactionId,CONVERT(nvarchar,t.SystemDate,121) SystemDate,CONVERT(nvarchar,t.SystemTime,121) SystemTime,CONVERT(nvarchar,t.SystemSettlementDate,121) SystemSettlementDate,
    t.TransactionType,t.TransactionFlags,t.TransactionReason,t.DeviceId,t.DeviceDate,t.DeviceSequence,t.NetworkId,t.NetworkSequence,t.NetworkSettlementDate1,t.NetworkSettlementDate2,t.RoutingCode,
    t.AmountRequest,t.AmountAuthenticate,t.AmountSettlement,t.AmountSettlementDestination,
    t.AmountSurchargeRequest,t.AmountSurchargeWaived+t.AmountSurcharge,t.AmountSurchargeWaived,t.AmountSurcharge,t.AmountCashBack,t.AmountConvinience,
    t.CurrencyRequest,t.CurrencySource,t.CurrencyDestination,t.CurrencyDeviceRate,t.CurrencyNetworkRate,
    t.AuthenticationNumber,t.ReferenceNumber,t.ApprovalCode,t.BatchId,t.PAN,t.BINRange,t.BINGroup,t.SourceAccountType,t.DestinationAccountType,
    t.ResponseCodeInternal,t.ResponseCodeExternal,t.CustomerMediaExpiryDate,t.CreatedUserId,t.SmartAcquierId
  FROM dbo.tbl_trn_Transaction t 
  WHERE CustomerMediaDataHash=@CustomerMediaDataHash AND DeviceId=@DeviceId AND DeviceSequence=@DeviceSequence 
    AND (@ResponseCodeInternal<0 OR ResponseCodeInternal=@ResponseCodeInternal) AND (TransactionFlags & @TransactionFlags)=@TransactionFlags
    AND t.SystemDate >= dateadd(day, -1, getutcdate())
  ORDER BY SystemTime DESC
END
GO
GRANT EXECUTE ON  [dbo].[usp_trn_GetOriginalTransaction] TO [SAV4Role]
GRANT EXECUTE ON  [dbo].[usp_trn_GetOriginalTransaction] TO [WebV4Role]
GO
