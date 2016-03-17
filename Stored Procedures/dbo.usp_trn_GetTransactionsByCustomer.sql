SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_trn_GetTransactionsByCustomer]
	 @CustomerId	bigint
	,@IsoId			bigint
	,@BeginDate     nvarchar(50)
	,@EndDate		nvarchar(50)
AS
BEGIN
  SET NOCOUNT ON;
  
  SELECT 
    t.Id TransactionId,t.SystemDate,t.SystemTime,t.SystemSettlementDate,t.TransactionType,t.TransactionReason,
    i.Id IsoId,i.RegisteredName,d.Id DeviceId,d.TerminalName,t.DeviceDate,t.DeviceSequence,
    n.Id NetworkId,n.NetworkCode,n.NetworkName,t.NetworkSettlementDate1,t.NetworkSettlementDate2,
    t.AmountRequest,t.AmountAuthenticate,t.AmountSettlement-t.AmountSurcharge AmountDispensed,t.ServiceFee as ServiceFee,
    t.AmountSurcharge,t.AmountSettlement,t.AmountSettlementDestination,t.AmountSettlementReconciliation,tf.AmountInterchange,
    t.ResponseCodeInternal,t.ResponseCodeExternal,txc.ImageData ,txc.ExtendedColumn, t.CustomerMediaType,
    t.CustomerMediaDataPart1, t.CustomerMediaDataPart2,
    t.AuthenticationNumber,u.FirstName as CashierFirstName, u.LastName as CashierLastName,
    CASE 
		WHEN t.CustomerMediaType in (select value from dbo.tbl_TypeValue where TypeId=45) then RTRIM(t.CustomerMediaDataPart1)+'XXXXXX'+t.CustomerMediaDataPart2
		WHEN t.CustomerMediaType in (select value from dbo.tbl_TypeValue where TypeId=59) then REPLICATE('X',len(t.CustomerMediaDataPart2)-4)+RIGHT(t.CustomerMediaDataPart2,4)
		ELSE ''
	END 
	AS CustomerMaskedAccountNumber,
	tv.Description as CustomerMediaTypeName,
	CASE 
		--WHEN t.TransactionType = 9           THEN 'POS Debit'
		--WHEN t.TransactionType IN (13,15,16) THEN 'Cash Advance'
		WHEN t.TransactionType IN (56)       THEN 'E-Check Cashing'
		WHEN t.TransactionType IN (61)       THEN 'OTB Check Cashing'
		WHEN t.TransactionType IN (52,54)    THEN 'Check Cashing'
	END
	AS TransactionTypeName
  FROM dbo.tbl_trn_Transaction t 
  LEFT JOIN dbo.tbl_trn_TransactionAmountInter tf ON t.Id=tf.TranId
  LEFT JOIN tbl_trn_TransactionreExtendedColumn txc ON t.Id=txc.TranId
  LEFT JOIN dbo.tbl_Network n ON t.NetworkId=n.Id 
  LEFT JOIN dbo.tbl_Device d ON t.DeviceId=d.Id LEFT JOIN dbo.tbl_Iso i ON d.IsoId=i.Id
  LEFT JOIN dbo.tbl_upm_User u ON t.CreatedUserId = u.Id
  LEFT JOIN dbo.tbl_TypeValue tv ON tv.Value = t.CustomerMediaType and tv.TypeId in (45,59)
  WHERE t.CustomerId =@CustomerId
    AND t.SystemDate>=@BeginDate AND t.SystemDate<@EndDate
    AND t.TransactionType IN (52,54,56,61) AND t.PayoutStatus in (5)
	AND i.Id=@IsoId 
  ORDER BY t.DeviceDate DESC
END
GO
GRANT EXECUTE ON  [dbo].[usp_trn_GetTransactionsByCustomer] TO [WebV4Role]
GO
