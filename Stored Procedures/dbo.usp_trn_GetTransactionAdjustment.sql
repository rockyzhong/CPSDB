SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_trn_GetTransactionAdjustment]
@TransactionId           bigint,
@TransactionDate         datetime
AS
BEGIN
  SET NOCOUNT ON

  SELECT a.SystemDate,a.BatchHeader,a.AmountSettlement,a.AmountSurcharge,a.Description,a.UpdatedUserId,u.UserName CreatedUserName,a.SettlementStatus
  FROM dbo.tbl_trn_TransactionAdjustment a
  LEFT JOIN dbo.tbl_upm_User u ON a.UpdatedUserId=u.Id
  WHERE a.TransactionId=@TransactionId
END
GO
GRANT EXECUTE ON  [dbo].[usp_trn_GetTransactionAdjustment] TO [WebV4Role]
GO
