SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[usp_trn_getUnsettleACHECheckListmanual]
      @startDate DATETIME,    --- must be UTC time
      @endDate DATETIME       -- must be UTC time

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
    
    select nm.MerchantId,t.NetworkTransactionId,t.AmountAuthenticate,SystemTime
	from tbl_trn_Transaction t
	left join tbl_Device d on d.Id = t.DeviceId 
	left join tbl_NetworkMerchant nm on nm.NetworkId = t.NetworkId and nm.IsoId = d.IsoId
	where TransactionType in (56,63) and ACHECheckAck is null and PayoutStatus = 5 and SystemTime between @startDate and @endDate 
	order by nm.MerchantId

END

GO
