SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
/*
EXEC dbo.usp_rec_TransactionCIBC_Load '2015-04-19', 124
SELECT DATEDIFF(day, '2015-04-19',getdate())


BCP CPS.dbo.tbl_rec_TransactionCIBCImport IN "c:\recfile\WL_RECL04_US_20150419214132.txt" -Sitwsjw01  -T -c -r0x0A

SELECT * FROM dbo.tbl_rec_TransactionCIBCImport
--truncate table tbl_rec_TransactionCIBC
SELECT * FROM dbo.tbl_rec_TransactionCIBC where currency = 124
SELECT * FROM dbo.tbl_rec_TransactionCIBC where currency = 840


*/
CREATE PROC [dbo].[usp_rec_TransactionCIBC_Load]
	@pSettDate datetime
	,@pCurrency smallint
AS
BEGIN
SET NOCOUNT ON

DELETE FROM dbo.tbl_rec_TransactionCIBC
WHERE DateTimeSettlement = @pSettDate
	AND Currency = @pCurrency

INSERT INTO  dbo.tbl_rec_TransactionCIBC
(
    DateTimeSettlement,
    TerminalID,
    DateTimeLocal,
    RetrievalRefNumInt,
    MsgType,
	Currency,
    PCode,
    AmountTransactionCAD,
    SettleDate,
    CaptureDate,
    AmountFeeCAD,
    AcqInstID,
    RetrievalRefNum,
    CardAcceptorID,
    DCC_Cat,
    DCC_Disp,
    DCC_CurrencyCode,
    DCC_ExchangeRate,
    DCC_ForeignAmount,
    DCC_Outcome,
    DCC_Quote_ID,
    PostalCode,
    AmountReconciliationCAD,
    IssuerID
)
SELECT @pSettDate AS DateTimeSettlement,
  RTRIM(substring(LineText, 75, 16)) AS TerminalID,
  convert(datetime, convert(varchar(5), (CASE WHEN month(@pSettDate) = 1 AND substring(LineText, 31, 2) = '12'
        THEN year(@pSettDate) - 1 ELSE year(@pSettDate) END))
      + '-' + substring(LineText, 31, 2) + '-' + substring(LineText, 33, 2)
      + ' ' + substring(LineText, 25, 2) + ':' + substring(LineText, 27, 2) + ':' + substring(LineText, 29, 2)
  ) AS DateTimeLocal,
  convert(int, substring(LineText, 69, 6)) AS RetrievalRefNumInt,
  convert(int, substring(LineText, 3, 4)) AS MsgType,
  @pCurrency as Currency,
  convert(int, substring(LineText, 7, 6)) AS PCode,
  convert(money, substring(LineText, 13, 12)) / 100 AS AmountTransactionCAD,
  substring(LineText, 35, 4) AS SettleDate,
  substring(LineText, 39, 4) AS CaptureDate,
  convert(money, substring(LineText, 44, 8)) / 100 AS AmountFeeCAD,
  RTRIM(substring(LineText, 52, 11)) AS AcqInstID,
  RTRIM(substring(LineText, 63, 12)) AS RetrievalRefNum,
  RTRIM(substring(LineText, 91, 15)) AS CardAcceptorID,
  substring(LineText, 106, 2) AS DCC_Cat,
  RTRIM(substring(LineText, 108, 1)) AS DCC_Disp,
  substring(LineText, 109, 3) AS DCC_CurrencyCode,
  (CASE WHEN ISNUMERIC(substring(LineText, 113, 7)) = 0 THEN 1
    ELSE convert(numeric(19, 12), substring(LineText, 113, 7))
        / power(10, convert(float, substring(LineText, 112, 1))) END) AS DCC_ExchangeRate,
  (CASE WHEN ISNUMERIC(substring(LineText, 120, 12)) = 0 THEN 0
    ELSE convert(numeric(21, 12), substring(LineText, 120, 12)) 
        / power(10, convert(float, substring(LineText, 132, 1))) END) AS ForeignAmount,
  substring(LineText, 133, 1) AS DCC_Outcome,
  substring(LineText, 134, 32) AS DCC_Quote_ID,
  substring(LineText, 166, 10) AS PostalCode,
  convert(money, substring(LineText, 176, 12)) / 100 AS AmountReconciliationCAD,
  substring(LineText, 188, 4) AS IssuerID
FROM dbo.tbl_rec_TransactionCIBCImport (NOLOCK)
WHERE LineText LIKE 'RR%'

END

GO
GRANT EXECUTE ON  [dbo].[usp_rec_TransactionCIBC_Load] TO [WebV4Role]
GO
