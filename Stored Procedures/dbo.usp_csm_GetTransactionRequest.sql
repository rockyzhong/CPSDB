SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[usp_csm_GetTransactionRequest] 
@CustomerMediaDataHash varchar(512)
AS
BEGIN
  SELECT Id,SystemDate,SystemTime,TransactionType,DeviceId,DeviceDate,DeviceSequence,AmountRequest,AmountSurcharge,CurrencySource,
       CustomerId,CustomerMediaType,CustomerMediaDataPart1,CustomerMediaDataPart2,CustomerMediaExpiryDate
  FROM dbo.tbl_trn_Transaction
  WHERE CustomerMediaDataHash=@CustomerMediaDataHash
END
GO
GRANT EXECUTE ON  [dbo].[usp_csm_GetTransactionRequest] TO [WebV4Role]
GO
