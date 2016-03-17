SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_TNS_MonthEndBilling_TerminalList_Load]
@pStartDate datetime,
@pEndDate datetime
AS
BEGIN
  DELETE FROM dbo.tbl_MonthEndBilling_TerminalList
  WHERE StartDate = @pStartDate AND EndDate = @pEndDate

  INSERT INTO dbo.tbl_MonthEndBilling_TerminalList(StartDate,EndDate,IsoId,TerminalId)
  SELECT @pStartDate, @pEndDate,IsoId,TerminalName
  FROM dbo.tbl_Device 
  WHERE DeviceStatus IN (1,3)
END
GO
