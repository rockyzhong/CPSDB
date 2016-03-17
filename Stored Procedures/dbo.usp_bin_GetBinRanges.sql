SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[usp_bin_GetBinRanges]

AS
BEGIN
  SELECT CountryNumberCode,BINVal,BINGroup,TransactionTypeList FROM dbo.tbl_BinRange WHERE TransactionTypeList IS NOT NULL ORDER BY CountryNumberCode,BINVal,TransactionTypeList

END
GO
GRANT EXECUTE ON  [dbo].[usp_bin_GetBinRanges] TO [SAV4Role]
GO
