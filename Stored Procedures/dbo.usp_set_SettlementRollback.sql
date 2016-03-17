SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[usp_set_SettlementRollback] 
@SettlementDate datetime
AS
BEGIN
  SET NOCOUNT ON

  DECLARE @LastSettlementDate datetime
  SELECT @LastSettlementDate=MAX(SettlementDate) FROM dbo.tbl_AchFileHistory
  
  IF @SettlementDate<>@LastSettlementDate
    RAISERROR('Settlement can not be roll back because it is not latest settlement',11,1)
  ELSE
  BEGIN
    DELETE FROM dbo.tbl_AchTransaction  WHERE SettlementDate=@SettlementDate
    DELETE FROM dbo.tbl_AchEntryHistory WHERE SettlementDate=@SettlementDate
    DELETE FROM dbo.tbl_AchFileHistory  WHERE SettlementDate=@SettlementDate

    SELECT @LastSettlementDate=MAX(SettlementDate) FROM dbo.tbl_AchFileHistory
    UPDATE dbo.tbl_AchSchedule SET SettlementDate=CASE WHEN StartDate<@LastSettlementDate THEN @LastSettlementDate ELSE NULL END,UpdatedUserId=0 WHERE SettlementDate=@SettlementDate
  END
END
GO
