SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_set_Settlement]
AS
BEGIN
  SET NOCOUNT ON

  DECLARE @SettlementDate datetime
  SET @SettlementDate=DATEADD(dd,-1,DATEADD(dd,0,DATEDIFF(dd,0,GETUTCDATE())))

  EXEC dbo.usp_set_SettlementAchTransaction  @SettlementDate
  EXEC dbo.usp_set_SettlementAchEntryHistory @SettlementDate
END
GO
