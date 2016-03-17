SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_iso_GetIsoCageCardTransactionConfig]
@IsoId   bigint
AS
BEGIN
  SET NOCOUNT ON
 
  SELECT Id IsoCageCardTransactionConfigId,IsoId,CallCenterPhone,DAPLookupLevel,AvsCvv2Required,InitializeTransactionAtCage,DisplayCashToCustomerToday,ManualCardEntryAllowed, PinDebitAllowed,SignDebitAllowed,ISNULL(Title31limit,0) Title31Limit 
  FROM dbo.tbl_IsoCageCardTransactionConfig
  WHERE IsoId=@IsoId
END
GO
GRANT EXECUTE ON  [dbo].[usp_iso_GetIsoCageCardTransactionConfig] TO [WebV4Role]
GO
