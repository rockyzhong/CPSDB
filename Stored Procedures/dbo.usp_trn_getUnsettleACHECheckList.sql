SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Terence Xie
-- Create date: 2012-01-03
-- Description:	get unsettle echeck cashing 
---             transactions
-- =============================================
CREATE PROCEDURE [dbo].[usp_trn_getUnsettleACHECheckList]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
    
    select nm.MerchantId,t.NetworkTransactionId,t.AmountAuthenticate 
	from tbl_trn_Transaction t
	left join tbl_Device d on d.Id = t.DeviceId 
	left join tbl_NetworkMerchant nm on nm.NetworkId = t.NetworkId and nm.IsoId = d.IsoId
	where TransactionType in (56,63) and ACHECheckAck is null and PayoutStatus = 5 
	order by nm.MerchantId

END
GO
GRANT EXECUTE ON  [dbo].[usp_trn_getUnsettleACHECheckList] TO [SAV4Role]
GRANT EXECUTE ON  [dbo].[usp_trn_getUnsettleACHECheckList] TO [WebV4Role]
GO
