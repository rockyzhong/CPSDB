SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_trn_GetCardTransactionReferral]
@CustomerMediaDataHash varbinary(512)
--@IsoId bigint
AS
BEGIN
  SELECT t.Id TransactionId,t.SystemDate,t.CustomerMediaType,t.DeviceDate,t.AmountRequest,t.AmountAuthenticate,t.AmountSettlement,t.AmountSurchargeRequest AmountSurcharge,dbo.udf_GetValueName(51,t.ResponseCodeInternal) ResponseCodeInternal,
         t.PayoutCash,t.PayoutDeposit,t.PayoutChips,t.PayoutMarker,t.PayoutOther,t.PayoutStatus,
         d.Id DeviceId,d.TerminalName
  FROM dbo.tbl_trn_Transaction t 
  LEFT JOIN dbo.tbl_Device d ON t.DeviceId=d.Id
  WHERE t.CustomerMediaDataHash=@CustomerMediaDataHash 
    AND t.SystemDate>=DATEADD(dd,-1,GETUTCDATE()) 
    AND t.PayoutStatus IN (1,3) AND t.ResponseCodeInternal=37 AND t.TransactionType IN (7,8) AND (t.ApprovalCode IS NULL OR t.ApprovalCode = '') AND t.TransactionFlags & 0x00080000=0x00080000
    --AND d.IsoId=@IsoId
END
GO
GRANT EXECUTE ON  [dbo].[usp_trn_GetCardTransactionReferral] TO [SAV4Role]
GRANT EXECUTE ON  [dbo].[usp_trn_GetCardTransactionReferral] TO [WebV4Role]
GO
