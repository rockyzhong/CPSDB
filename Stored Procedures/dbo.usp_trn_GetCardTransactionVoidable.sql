SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_trn_GetCardTransactionVoidable]
@CustomerMediaDataHash varbinary(512),
@IsoId bigint
AS
BEGIN
  DECLARE @MinReHour FLOAT 
  SELECT @MinReHour=CASE WHEN  CONVERT(FLOAT,ExtendedColumnValue)<1 THEN 1 WHEN CONVERT(FLOAT,ExtendedColumnValue)>12 THEN 12 ELSE CONVERT(FLOAT,ExtendedColumnValue) END FROM dbo.tbl_IsoExtendedValue WHERE ExtendedColumnType=34 AND IsoId=@IsoId
  IF @MinReHour IS NULL 
  SET @MinReHour=2
  SELECT t.Id TransactionId,t.SystemDate,t.CustomerMediaType,t.DeviceDate,t.DeviceSequence,t.AmountRequest,t.AmountAuthenticate,t.AmountSettlement,t.AmountSurchargeRequest AmountSurcharge,dbo.udf_GetValueName(51,t.ResponseCodeInternal) ResponseCodeInternal,
         t.PayoutCash,t.PayoutDeposit,t.PayoutChips,t.PayoutMarker,t.PayoutOther,t.PayoutStatus,t.HostMerchantID,t.HostTerminalID,
         d.Id DeviceId,d.TerminalName,
         c.Id CustomerId,c.FirstName,c.LastName,c.MiddleInitial
  FROM dbo.tbl_trn_Transaction t 
  LEFT JOIN dbo.tbl_Customer c ON t.CustomerId=c.Id 
  LEFT JOIN dbo.tbl_Device d ON t.DeviceId=d.Id
  WHERE t.CustomerMediaDataHash=@CustomerMediaDataHash 
    AND t.SystemDate>=DATEADD(MINUTE,-@MinReHour*60,GETUTCDATE())
    AND t.PayoutStatus IN (1,3) AND t.ResponseCodeInternal=0 AND t.TransactionType=8 AND t.TransactionFlags & 0x00080000=0
    AND d.IsoId=@IsoId
END
GO
GRANT EXECUTE ON  [dbo].[usp_trn_GetCardTransactionVoidable] TO [SAV4Role]
GRANT EXECUTE ON  [dbo].[usp_trn_GetCardTransactionVoidable] TO [WebV4Role]
GO
