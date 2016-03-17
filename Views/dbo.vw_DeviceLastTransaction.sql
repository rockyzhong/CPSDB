SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [dbo].[vw_DeviceLastTransaction]
AS
  SELECT DeviceId,SystemDate LastTransDate,dbo.udf_GetValueName(19,TransactionType)+' '+dbo.udf_GetValueName(105,ResponseCodeInternal)+' [$'+CONVERT(nvarchar,CONVERT(money,CASE WHEN ResponseCodeInternal=0 THEN AmountSettlement ELSE AmountRequest END)/100)+'] SeqNo['+CONVERT(nvarchar,DeviceSequence)+']' LastTransData
  FROM dbo.tbl_trn_Transaction WHERE Id IN (SELECT MAX(Id) FROM dbo.tbl_trn_Transaction GROUP BY DeviceId)
GO
