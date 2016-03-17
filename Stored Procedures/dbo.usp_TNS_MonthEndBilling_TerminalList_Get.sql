SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_TNS_MonthEndBilling_TerminalList_Get]
@pStartDate datetime,
@pEndDate datetime,
@pISOID int = -1
AS
BEGIN
  SELECT t.IsoId,i.RegisteredName, t.TerminalId
  FROM dbo.tbl_MonthEndBilling_TerminalList t
  JOIN dbo.tbl_Iso i ON i.Id = t.IsoId
  WHERE t.StartDate = @pStartDate
    AND t.EndDate = @pEndDate
    AND t.ISOID = @pISOID
  ORDER BY i.RegisteredName,t.TerminalID
END
GO
