SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_TNS_MonthEndBilling_VISATransactionFees_Get_ForDateRange]
@pStartDate datetime,
@pEndDate datetime,
@pISOID int = -1
AS
BEGIN
  SELECT 
    i.RegisteredName AS ISOName,
    d.TerminalName AS TerminalID,
    v.VISATransCount,
    v.VISASettlementAmt,
    v.VISASurchargeAmt,
    v.VISATotalAmt,
    v.VISAPct,
    v.VISAFee
  FROM dbo.tbl_MonthEndBilling_VISATransactionFees v
  JOIN dbo.tbl_Device d ON d.Id=v.DeviceId
  JOIN dbo.tbl_Iso    i ON i.Id=d.IsoId
  WHERE v.StartDate = @pStartDate AND v.EndDate = @pEndDate
    AND d.IsoId = @pISOID
  ORDER BY i.RegisteredName,d.TerminalName
END
GO
