SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[udf_GetTransactionTypeDesc](@TransactionType bigint,@TransactionFlags bigint)
RETURNS nvarchar(20)
AS
BEGIN
  RETURN
  CASE WHEN @TransactionType IN (52)                                                   THEN 'PERSONAL'
       WHEN @TransactionType IN (53)                                                   THEN 'COMPANY'
       WHEN @TransactionType IN (54)                                                   THEN 'PAYROLL'
       WHEN @TransactionType IN (55)                                                   THEN 'EXCEPTION'
       WHEN @TransactionType IN (56)                                                   THEN 'ACH'
       WHEN @TransactionType IN (61)                                                   THEN 'OTB'
       WHEN @TransactionType IN (63)                                                   THEN 'KIOSK'
       WHEN @TransactionType IN (156)                                                  THEN 'ACH-Rev'
       WHEN @TransactionType IN (7,8,9,10,11,12,108) AND @TransactionFlags & 0x00080000=0 THEN 'POS Debit'
       WHEN @TransactionType IN (7,8,9,10,11,12) AND @TransactionFlags & 0x00080000<>0 THEN 'CCCA'        --Credit cash advance
       ELSE ''         
  END
END  
GO
