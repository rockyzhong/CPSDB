SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[usp_trn_GetTransactionByTransId]
  @TransactionId           bigint 
AS
-- Revision 1.1.0 2015.12.04 by Adam Glover
--   Append One-step flag to output.
BEGIN
  SELECT 
    t.OriginalTransactionId,t.Id TransactionId,
    CONVERT(nvarchar,t.SystemDate,121) SystemDate,
    CONVERT(nvarchar,t.SystemTime,121) SystemTime,
    CONVERT(nvarchar,t.SystemSettlementDate,121) SystemSettlementDate,
    t.TransactionType,t.TransactionFlags,t.TransactionReason,
    t.DeviceId,t.DeviceDate,t.DeviceSequence,t.NetworkId,
    t.NetworkSequence,t.NetworkSettlementDate1,
    t.NetworkSettlementDate2,t.RoutingCode,
    t.AmountRequest,t.AmountAuthenticate,
    t.AmountSettlement,t.AmountSettlementDestination,
    t.AmountSurchargeRequest,
    t.AmountSurchargeWaived+t.AmountSurcharge AS AmountSurchargeProc,
    t.AmountSurchargeWaived,t.AmountSurcharge,
    t.AmountCashBack,t.AmountConvinience,
    t.CurrencyRequest,t.CurrencySource,t.CurrencyDestination,
    t.CurrencyDeviceRate,t.CurrencyNetworkRate,
    t.AuthenticationNumber,t.ReferenceNumber,t.ApprovalCode,
    t.BatchId,t.PAN,t.BINRange,t.BINGroup,
    t.SourceAccountType,t.DestinationAccountType,
    t.ResponseCodeInternal,t.ResponseCodeExternal,
    t.CustomerMediaExpiryDate,t.CreatedUserId,
    t.SmartAcquierId,t.PayoutStatus,t.CustomerMediaDataPart1 AS OneStepFlag
  FROM dbo.tbl_trn_Transaction t 
  WHERE id=@TransactionId
END

GO
