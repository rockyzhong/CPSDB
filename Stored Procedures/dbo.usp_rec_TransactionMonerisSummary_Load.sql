SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

/*
EXEC dbo.usp_rec_TransactionMonerisSummary_Load '2015-04-19', 124
SELECT * FROM [dbo].[tbl_rec_TransactionMonerisSummary]
*/
CREATE PROCEDURE [dbo].[usp_rec_TransactionMonerisSummary_Load]
	@pSettDate datetime
	,@pCurrency smallint = 124
AS
BEGIN
SET NOCOUNT ON


DELETE FROM [dbo].[tbl_rec_TransactionMonerisSummary]
WHERE DateTimeSettlement = @pSettDate
	AND Currency = @pCurrency

INSERT INTO [dbo].[tbl_rec_TransactionMonerisSummary]
(
	DateTimeSettlement,
	Currency,
	SCDDebit,
	SCDFee,
	SCDProcessing,
	IDPDebit,
	IDPFee,
	IDPProcessing
)
SELECT 
	@pSettDate AS DateTimeSettlement,
	@pCurrency AS Currnecy,
	MAX(CASE 
			WHEN LineData LIKE ' SCD ACQUIRER%' THEN CONVERT(money, SUBSTRING(LineData, 38, 18))
			ELSE convert(money, 0) 
		END) AS SCDDebit,
	MAX(CASE 
			WHEN LineData LIKE ' SCD ACQUIRER%' THEN CONVERT(money, SUBSTRING(LineData, 61, 13))
			ELSE convert(money, 0) 
		END) AS SCDFee,
	MAX(CASE 
			WHEN LineData LIKE ' SCD ACQUIRER%' THEN CONVERT(money, SUBSTRING(LineData, 81, 13))
			ELSE convert(money, 0) 
		END) AS SCDProcessing,
	MAX(CASE 
			WHEN LineData LIKE ' IDP ACQUIRER%' THEN CONVERT(money, SUBSTRING(LineData, 38, 18))
			ELSE CONVERT(money, 0) 
		END) AS IDPDebit,
	MAX(CASE 
			WHEN LineData LIKE ' IDP ACQUIRER%' THEN CONVERT(money, SUBSTRING(LineData, 61, 13))
			ELSE convert(money, 0) 
		END) AS IDPFee,
	MAX(CASE 
			WHEN LineData LIKE ' IDP ACQUIRER%' THEN convert(money, substring(LineData, 81, 13))
			ELSE convert(money, 0) 
		END) AS IDPProcessing
FROM [dbo].[tbl_rec_TransactionMonerisSummaryImport] (NOLOCK)
--WHERE RecNo <= 13

END


GRANT EXEC ON  dbo.usp_rec_TransactionMonerisSummary_Load TO WebV4Role
GO
