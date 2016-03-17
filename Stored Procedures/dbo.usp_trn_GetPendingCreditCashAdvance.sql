SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_trn_GetPendingCreditCashAdvance]  

AS
BEGIN
  --OPEN SYMMETRIC KEY sk_EncryptionKey DECRYPTION BY CERTIFICATE ec_EncryptionCert 
  OPEN SYMMETRIC KEY SymKey_SPS_20150825 DECRYPTION BY ASYMMETRIC KEY AsymKey_SPS_20150825      
  SELECT t.Id TransactionId,t.SystemDate,t.CustomerMediaType,t.DeviceDate,t.AmountRequest,t.AmountAuthenticate,t.AmountSettlement,t.AmountAuthenticate-t.AmountRequest AmountSurcharge,dbo.udf_GetValueName(51,t.ResponseCodeInternal) ResponseCodeInternal,t.AuthenticationNumber,
         t.PayoutCash,t.PayoutDeposit,t.PayoutChips,t.PayoutMarker,t.PayoutOther,t.PayoutStatus,
         d.Id DeviceId,d.TerminalName,t.DeviceSequence,t.CustomerMediaDataEncrypted,CONVERT(varchar(max),DECRYPTBYKEY(t.CustomerMediaDataEncrypted)) as CardNumber,t.AuthenticationNumber,
         c.Id CustomerId,c.FirstName,c.LastName,c.MiddleInitial
  FROM dbo.tbl_trn_Transaction t 
  LEFT JOIN dbo.tbl_Customer c ON t.CustomerId=c.Id
  LEFT JOIN dbo.tbl_Device d ON t.DeviceId=d.Id
  WHERE t.SystemDate >= DATEADD(hh,-2,GETUTCDATE()) 
    AND t.PayoutStatus IN (1,3) AND t.ResponseCodeInternal IN (0,37) AND t.TransactionType=8 AND t.TransactionFlags & 0x00080000 <> 0
  ORDER BY t.Id desc
END
GO
GRANT EXECUTE ON  [dbo].[usp_trn_GetPendingCreditCashAdvance] TO [SAV4Role]
GRANT EXECUTE ON  [dbo].[usp_trn_GetPendingCreditCashAdvance] TO [WebV4Role]
GO
