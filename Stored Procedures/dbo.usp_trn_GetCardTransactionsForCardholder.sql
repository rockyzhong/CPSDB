SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_trn_GetCardTransactionsForCardholder]
	 @card_no nvarchar(50)
	,@trans_date datetime = NULL
	,@trans_amount bigint
	,@isoId bigint
AS
BEGIN
	SET NOCOUNT ON
	
	DECLARE @cardnoHash varbinary(512)
	DECLARE @cardnoEncrypted varbinary(512)
	EXEC dbo.usp_sys_EncryptExt @card_no,@cardnoHash output,@cardnoEncrypted output
	
    SELECT 
    t.Id TransactionId,t.SystemDate,t.SystemTime,t.SystemSettlementDate,t.TransactionType,t.TransactionFlags,t.TransactionReason,
    i.Id IsoId,i.RegisteredName,i.TradeName1,d.Id DeviceId,d.TerminalName,t.DeviceDate,t.DeviceSequence,
    n.Id NetworkId,n.NetworkCode,n.NetworkName,t.NetworkSettlementDate1,t.NetworkSettlementDate2,
    t.AmountRequest,t.AmountAuthenticate,t.AmountSettlement-AmountSurcharge AmountDispensed,t.ServiceFee as ServiceFee,
    t.AmountSurcharge,t.AmountSettlement,t.AmountSettlementDestination,t.AmountSettlementReconciliation,ISNULL(tf.AmountInterchange,0) AmountInterchange,
    t.ResponseCodeInternal,t.ResponseCodeExternal,txc.ImageData,txc.ExtendedColumn, t.CustomerMediaType,
    t.CustomerMediaDataPart1, t.CustomerMediaDataPart2,
    t.AuthenticationNumber,u.FirstName as CashierFirstName, u.LastName as CashierLastName,
    CASE 
		WHEN t.CustomerMediaType IN (SELECT value FROM dbo.tbl_TypeValue WHERE TypeId=45) THEN RTRIM(t.CustomerMediaDataPart1)+'XXXXXX'+t.CustomerMediaDataPart2
		WHEN t.CustomerMediaType IN (SELECT value FROM dbo.tbl_TypeValue WHERE TypeId=59) THEN REPLICATE('X',len(t.CustomerMediaDataPart2)-4)+RIGHT(t.CustomerMediaDataPart2,4)
		ELSE ''
	END 
	AS CustomerMaskedAccountNumber,
	tv.Description as CustomerMediaTypeName,
	CASE 
		WHEN t.TransactionType IN (7,9) AND t.TransactionFlags & 0x00080000=0  THEN 'POS Debit'
		WHEN t.TransactionType IN (7,9) AND t.TransactionFlags & 0x00080000<>0 THEN 'Cash Advance'
	END
	AS TransactionTypeName
  FROM dbo.tbl_trn_Transaction t
  LEFT JOIN dbo.tbl_trn_TransactionAmountInter tf ON t.Id=tf.TranId
  LEFT JOIN dbo.tbl_trn_TransactionreExtendedColumn txc ON t.Id=txc.TranId
  LEFT JOIN dbo.tbl_Network n ON t.NetworkId=n.Id 
  LEFT JOIN dbo.tbl_Device d ON t.DeviceId=d.Id LEFT JOIN dbo.tbl_Iso i ON d.IsoId=i.Id
  LEFT JOIN dbo.tbl_upm_User u ON t.CreatedUserId = u.Id
  LEFT JOIN dbo.tbl_TypeValue tv ON tv.Value = t.CustomerMediaType and tv.TypeId in (45,59)
  WHERE t.CustomerMediaDataHash = @cardnoHash
    AND t.TransactionType in (7,9) 
    AND (@trans_amount = 0 OR t.AmountRequest = @trans_amount) AND (@trans_date IS NULL OR DATEDIFF(dd,t.DeviceDate,@trans_date)=0)
    AND d.IsoId=@isoId
  ORDER BY t.DeviceDate desc
END
GO
GRANT EXECUTE ON  [dbo].[usp_trn_GetCardTransactionsForCardholder] TO [SAV4Role]
GRANT EXECUTE ON  [dbo].[usp_trn_GetCardTransactionsForCardholder] TO [WebV4Role]
GO
