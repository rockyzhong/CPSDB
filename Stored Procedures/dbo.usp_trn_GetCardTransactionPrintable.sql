SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_trn_GetCardTransactionPrintable]
@CustomerMediaDataHash varbinary(512),
@IsoId                 bigint
AS
BEGIN
  SELECT t.Id TransactionId,t.TransactionType,t.TransactionFlags,t.SystemDate,t.CustomerMediaType,t.DeviceDate,t.AmountRequest,t.AmountSettlement,t.AmountSurcharge,dbo.udf_GetValueName(51,t.ResponseCodeInternal) ResponseCodeInternal,
         t.PayoutCash,t.PayoutDeposit,t.PayoutChips,t.PayoutMarker,t.PayoutOther,t.PayoutStatus,
         d.Id DeviceId,d.TerminalName,
         c.Id CustomerId,c.FirstName,c.LastName,c.MiddleInitial
  FROM dbo.tbl_trn_Transaction t 
  LEFT JOIN dbo.tbl_Customer c ON t.CustomerId=c.Id 
  LEFT JOIN dbo.tbl_Device d ON t.DeviceId=d.Id
  WHERE t.CustomerMediaDataHash=@CustomerMediaDataHash 
    AND t.SystemDate>=DATEADD(hh,-2,GETUTCDATE())
    AND ((t.PayoutStatus IN (4,5)and TransactionType in (7,9)) OR (t.PayoutStatus in (4,5) and TransactionType =108 and TransactionFlags & 0x00080000=0)) AND t.ResponseCodeInternal=0  
    AND d.IsoId=@IsoId
END
GO
GRANT EXECUTE ON  [dbo].[usp_trn_GetCardTransactionPrintable] TO [SAV4Role]
GRANT EXECUTE ON  [dbo].[usp_trn_GetCardTransactionPrintable] TO [WebV4Role]
GO
