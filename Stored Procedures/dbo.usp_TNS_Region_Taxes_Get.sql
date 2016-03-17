SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_TNS_Region_Taxes_Get]
@pRegionID int
AS
BEGIN
  SELECT TaxName, TaxPercent AS TaxPct, RefNumber
  FROM dbo.tbl_RegionTax
  WHERE RegionID = @pRegionID
END
GO
