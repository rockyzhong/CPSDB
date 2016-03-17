SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_trn_UpdatePendingCardTransaction]
 @Id                bigint
AS
BEGIN
  SET NOCOUNT ON

  -- Set payout status to finish when transaction is card transaction and is approved
  DECLARE @PayoutStatus bigint
  SET @PayoutStatus=5

  UPDATE dbo.tbl_trn_Transaction SET
  PayoutStatus=@PayoutStatus
  WHERE Id=@Id 
  RETURN 0
END
GO
