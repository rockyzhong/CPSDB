SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_TNS_MonthEndBilling_MCITransactionFees_Get_ForDateRange]
@pStartDate datetime,
@pEndDate datetime,
@pISOID int = -1
AS
BEGIN
  SELECT 
    i.RegisteredName AS ISOName,
    d.TerminalName AS TerminalID,
    mtf.MCITransCount,
    mtf.MCISettlementAmt,
    mtf.MCISurchargeAmt,
    mtf.MCITotalAmt,
    mtf.MCIPct,
    mtf.MCIFee
  FROM dbo.tbl_MonthEndBilling_MCITransactionFees mtf
  JOIN dbo.tbl_Device d ON d.Id=mtf.DeviceId
  JOIN dbo.tbl_Iso    i ON i.Id=d.IsoId
  WHERE mtf.StartDate = @pStartDate AND mtf.EndDate = @pEndDate
    AND d.IsoId = @pISOID
  ORDER BY i.RegisteredName,d.TerminalName
  END
GO
