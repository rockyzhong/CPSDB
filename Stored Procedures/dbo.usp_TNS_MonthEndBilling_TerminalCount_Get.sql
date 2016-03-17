SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_TNS_MonthEndBilling_TerminalCount_Get]
@pStartDate datetime,
@pEndDate datetime,
@pISOID int = -1
AS
BEGIN
  SELECT COUNT(*) TermCount
  FROM dbo.tbl_MonthEndBilling_TerminalList
  WHERE StartDate = @pStartDate
    AND EndDate = @pEndDate
    AND IsoId = @pISOID
END
GO
