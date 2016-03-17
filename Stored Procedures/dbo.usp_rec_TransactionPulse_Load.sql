SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

/*
truncate table tbl_rec_TransactionPulseImport
truncate table tbl_rec_TransactionPulse
SELECT * FROM tbl_trn_TransactionConsolidated (NOLOCK)
SELECT * FROM tbl_rec_TransactionPulseImport (NOLOCK)
SELECT * FROM tbl_rec_TransactionPulse (NOLOCK)

SELECT DISTINCT AcquirerBusinessID FROM tbl_rec_TransactionPulse (NOLOCK)
WHERE DateTimeSettlement = '2015-04-19' 
	AND Currency = 840

BCP CPS.dbo.tbl_rec_TransactionPulseImport IN "c:\recfile\D150419.PL.HXS.PRD1.DATA1.INT610" -S 10.1.9.101  -U sa  -P Password0 -c
BCP CPS.dbo.tbl_rec_TransactionPulseImport IN "c:\recfile\D150419.PL.HXS.PRD1.DATA1.INT554" -S 10.1.9.101  -U sa  -P Password0 -c

BCP CPS.dbo.tbl_rec_TransactionPulseImport IN "c:\recfile\D150419.PL.HXS.PRD1.DATA1.INT610" -Sitwsjw01  -T -c
BCP CPS.dbo.tbl_rec_TransactionPulseImport IN "c:\recfile\D150419.PL.HXS.PRD1.DATA1.INT554" -Sitwsjw01  -T -c

EXEC [dbo].[usp_rec_TransactionPulse_Load] '2015-04-19', 124
SELECT * FROM dbo.tbl_rec_TransactionPulse WHERE DateTimeSettlement = '2015-04-19' and acquirerbusinessid = 'INT554'



*/
CREATE PROCEDURE [dbo].[usp_rec_TransactionPulse_Load]
	@pSettDate datetime
	,@Currency smallint = 840
AS
BEGIN
SET NOCOUNT ON

IF OBJECT_ID('tempdb..#TempTransactionPulseImport') IS NOT NULL
BEGIN
	TRUNCATE TABLE #TempTransactionPulseImport
	DROP TABLE #TempTransactionPulseImport
END

--insert into [tbl_SPS_Reconciliation_PULSE_DATA1_Detail]
SELECT 
  @pSettDate AS DateTimeSettlement,
  max(CASE WHEN substring(LineData, 1, 2) = '06' THEN RTRIM(substring(LineData, 14, 16)) ELSE '' END) AS AcquirerBusinessID,
  convert(int, substring(LineData, 3, 10)) AS RecordSeqNo,
  @Currency AS Currency,
  max(CASE WHEN substring(LineData, 1, 2) = '06' THEN RTRIM(substring(LineData, 13, 1)) ELSE '' END) AS IssuerAcquirerFlag,
  max(CASE WHEN substring(LineData, 1, 2) = '06' THEN RTRIM(substring(LineData, 30, 16)) ELSE '' END) AS IssuerBusinessID,
  max(CASE WHEN substring(LineData, 1, 2) = '06' THEN convert(datetime, substring(LineData, 46, 4)
      + '-' + substring(LineData, 50, 2)  + '-' + substring(LineData, 52, 2)
      + ' ' + substring(LineData, 54, 2) + ':' + substring(LineData, 56, 2)
      + ':' + substring(LineData, 58, 2) + '.' + substring(LineData, 60, 3))
    ELSE '' END) AS ExternalTimeStamp,
  max(CASE WHEN substring(LineData, 1, 2) = '06' THEN convert(datetime, substring(LineData, 66, 4)
      + '-' + substring(LineData, 70, 2) + '-' + substring(LineData, 72, 2))
    ELSE '' END) AS SystemBusinessDate,
  max(CASE WHEN substring(LineData, 1, 2) = '06' THEN RTRIM(substring(LineData, 74, 28)) ELSE '' END) AS AccountID1,
  max(CASE WHEN substring(LineData, 1, 2) = '06' THEN RTRIM(substring(LineData, 102, 28)) ELSE '' END) AS AccountID2,
  max(CASE WHEN substring(LineData, 1, 2) = '06' THEN RTRIM(substring(LineData, 130, 6)) ELSE '' END) AS PCode,
  max(CASE WHEN substring(LineData, 1, 2) = '06' THEN RTRIM(substring(LineData, 136, 9)) ELSE '' END) AS AcquiringInstID,
  max(CASE WHEN substring(LineData, 1, 2) = '06' THEN RTRIM(substring(LineData, 145, 3)) ELSE '' END) AS AcquiringNetworkID,
  max(CASE WHEN substring(LineData, 1, 2) = '06' THEN RTRIM(substring(LineData, 148, 4)) ELSE '' END) AS ActionCode,
  max(CASE WHEN substring(LineData, 1, 2) = '06' THEN RTRIM(substring(LineData, 152, 23)) ELSE '' END) AS CardAcceptorAddress,
  max(CASE WHEN substring(LineData, 1, 2) = '06' THEN RTRIM(substring(LineData, 175, 13)) ELSE '' END) AS CardAcceptorCity,
  max(CASE WHEN substring(LineData, 1, 2) = '06' THEN RTRIM(substring(LineData, 188, 2)) ELSE '' END) AS CardAcceptorState,
  max(CASE WHEN substring(LineData, 1, 2) = '06' THEN RTRIM(substring(LineData, 190, 3)) ELSE '' END) AS CardAcceptorCountryCode,
  max(CASE WHEN substring(LineData, 1, 2) = '06' THEN RTRIM(substring(LineData, 193, 25)) ELSE '' END) AS CardAcceptorName,
  max(CASE WHEN substring(LineData, 1, 2) = '06' THEN RTRIM(substring(LineData, 218, 15)) ELSE '' END) AS CardAcceptorID,
  max(CASE WHEN substring(LineData, 1, 2) = '06' THEN RTRIM(substring(LineData, 233, 16)) ELSE '' END) AS TerminalID,
  max(CASE WHEN substring(LineData, 1, 2) = '06' THEN RTRIM(substring(LineData, 249, 3)) ELSE '' END) AS CardSeqNo,
  max(CASE WHEN substring(LineData, 1, 2) = '06' THEN RTRIM(substring(LineData, 252, 3)) ELSE '' END) AS AcquirerCountryCode,
  max(CASE WHEN substring(LineData, 1, 2) = '06' THEN RIGHT(RTRIM(substring(LineData, 259, 19)), 4) ELSE '' END) AS PAN_Last4,
  max(CASE WHEN substring(LineData, 1, 2) = '06' THEN RTRIM(substring(LineData, 278, 9)) ELSE '' END) AS IssuerInstID,
  max(CASE WHEN substring(LineData, 1, 2) = '06' THEN RTRIM(substring(LineData, 287, 3)) ELSE '' END) AS IssuerNetworkID,
  max(CASE WHEN substring(LineData, 1, 2) = '06' THEN convert(datetime, substring(LineData, 290, 4)
      + '-' + substring(LineData, 294, 2)  + '-' + substring(LineData, 296, 2)
      + ' ' + substring(LineData, 298, 2) + ':' + substring(LineData, 300, 2)
      + ':' + substring(LineData, 302, 2) + '.' + substring(LineData, 304, 2) + '0')
    ELSE '' END) AS LocalTimeStamp,
  max(CASE WHEN substring(LineData, 1, 2) = '06' THEN RTRIM(substring(LineData, 306, 4)) ELSE '' END) AS MCC,
  max(CASE WHEN substring(LineData, 1, 2) = '06' THEN RTRIM(substring(LineData, 310, 6)) ELSE '' END) AS NetworkTerminalID,
  max(CASE WHEN substring(LineData, 1, 2) = '06' THEN RTRIM(substring(LineData, 316, 6)) ELSE '' END) AS RetrievalRefNum1,
  max(CASE WHEN substring(LineData, 1, 2) = '06' THEN RTRIM(substring(LineData, 322, 10)) ELSE '' END) AS RetrievalRefNum2,
  (CASE WHEN ISNUMERIC(max(CASE WHEN substring(LineData, 1, 2) = '06' THEN RTRIM(substring(LineData, 322, 10)) ELSE '0' END)) = 0 THEN 0
    ELSE convert(int, max(CASE WHEN substring(LineData, 1, 2) = '06' THEN RTRIM(substring(LineData, 322, 10)) ELSE '0' END)) END) AS RetrievalRefNum2Int,
  max(CASE WHEN substring(LineData, 1, 2) = '06' THEN RTRIM(substring(LineData, 332, 1)) ELSE '' END) AS ReversalFlag,
  max(CASE WHEN substring(LineData, 1, 2) = '06' THEN RTRIM(substring(LineData, 333, 12)) ELSE '' END) AS SystemTraceAudit,
  max(CASE WHEN substring(LineData, 1, 2) = '06' THEN convert(money, substring(LineData, 345, 19)) / 10000 ELSE '' END) AS AmountSettlement,
  max(CASE WHEN substring(LineData, 1, 2) = '06' THEN RTRIM(substring(LineData, 364, 3)) ELSE '' END) AS SettlementCurrency,
  max(CASE WHEN substring(LineData, 1, 2) = '06' THEN RTRIM(substring(LineData, 367, 2)) ELSE '' END) AS TransactionAmountIndicator,
  max(CASE WHEN substring(LineData, 1, 2) = '06' THEN RTRIM(substring(LineData, 369, 1)) ELSE '' END) AS TransactionAmountImpactType,
  max(CASE WHEN substring(LineData, 1, 2) = '50' THEN RTRIM(substring(LineData, 13, 3)) ELSE '' END) AS ActionValue,
  max(CASE WHEN substring(LineData, 1, 2) = '50' THEN RTRIM(substring(LineData, 16, 2)) ELSE '' END) AS Format8TranType,
  max(CASE WHEN substring(LineData, 1, 2) = '50' THEN RTRIM(substring(LineData, 18, 1)) ELSE '' END) AS OriginalSettlementIndicator,
  max(CASE WHEN substring(LineData, 1, 2) = '50' THEN RTRIM(substring(LineData, 19, 3)) ELSE '' END) AS POSEntryMode,
  max(CASE WHEN substring(LineData, 1, 2) = '50' THEN RTRIM(substring(LineData, 22, 1)) ELSE '' END) AS POSPINCaptureCode,
  max(CASE WHEN substring(LineData, 1, 2) = '07' THEN convert(int, substring(LineData, 13, 2)) ELSE '' END) AS AmountCount,
  max(CASE WHEN substring(LineData, 1, 2) = '07' THEN RTRIM(substring(LineData, 15, 20)) ELSE '' END) AS Amount1Name,
  max(CASE WHEN substring(LineData, 1, 2) = '07' THEN convert(money, substring(LineData, 35, 19)) / 10000 ELSE '' END) AS Amount1Value,
  max(CASE WHEN substring(LineData, 1, 2) = '07' THEN RTRIM(substring(LineData, 54, 3)) ELSE '' END) AS Amount1CurrencyCode,
  max(CASE WHEN substring(LineData, 1, 2) = '07' THEN RTRIM(substring(LineData, 57, 19)) ELSE '' END) AS Amount1ConversionRate,
  max(CASE WHEN substring(LineData, 1, 2) = '07' THEN RTRIM(substring(LineData, 76, 20)) ELSE '' END) AS Amount1ConversionTimeStamp,
  max(CASE WHEN substring(LineData, 1, 2) = '07' THEN RTRIM(substring(LineData, 96, 20)) ELSE '' END) AS Amount2Name,
  max(CASE WHEN substring(LineData, 1, 2) = '07' THEN convert(money, substring(LineData, 116, 19)) / 10000 ELSE '' END) AS Amount2Value,
  max(CASE WHEN substring(LineData, 1, 2) = '07' THEN RTRIM(substring(LineData, 135, 3)) ELSE '' END) AS Amount2CurrencyCode,
  max(CASE WHEN substring(LineData, 1, 2) = '07' THEN RTRIM(substring(LineData, 138, 19)) ELSE '' END) AS Amount2ConversionRate,
  max(CASE WHEN substring(LineData, 1, 2) = '07' THEN RTRIM(substring(LineData, 157, 20)) ELSE '' END) AS Amount2ConversionTimeStamp,
  max(CASE WHEN substring(LineData, 1, 2) = '07' THEN RTRIM(substring(LineData, 177, 20)) ELSE '' END) AS Amount3Name,
  max(CASE WHEN substring(LineData, 1, 2) = '07' THEN convert(money, substring(LineData, 197, 19)) / 10000 ELSE '' END) AS Amount3Value,
  max(CASE WHEN substring(LineData, 1, 2) = '07' THEN RTRIM(substring(LineData, 216, 3)) ELSE '' END) AS Amount3CurrencyCode,
  max(CASE WHEN substring(LineData, 1, 2) = '07' THEN RTRIM(substring(LineData, 219, 19)) ELSE '' END) AS Amount3ConversionRate,
  max(CASE WHEN substring(LineData, 1, 2) = '07' THEN RTRIM(substring(LineData, 238, 20)) ELSE '' END) AS Amount3ConversionTimeStamp,
  max(CASE WHEN substring(LineData, 1, 2) = '07' THEN RTRIM(substring(LineData, 258, 20)) ELSE '' END) AS Amount4Name,
  max(CASE WHEN substring(LineData, 1, 2) = '07' THEN convert(money, substring(LineData, 278, 19)) / 10000 ELSE '' END) AS Amount4Value,
  max(CASE WHEN substring(LineData, 1, 2) = '07' THEN RTRIM(substring(LineData, 297, 3)) ELSE '' END) AS Amount4CurrencyCode,
  max(CASE WHEN substring(LineData, 1, 2) = '07' THEN RTRIM(substring(LineData, 300, 19)) ELSE '' END) AS Amount4ConversionRate,
  max(CASE WHEN substring(LineData, 1, 2) = '07' THEN RTRIM(substring(LineData, 319, 20)) ELSE '' END) AS Amount4ConversionTimeStamp,
  max(CASE WHEN substring(LineData, 1, 2) = '07' THEN RTRIM(substring(LineData, 339, 20)) ELSE '' END) AS Amount5Name,
  max(CASE WHEN substring(LineData, 1, 2) = '07' THEN convert(money, substring(LineData, 359, 19)) / 10000 ELSE '' END) AS Amount5Value,
  max(CASE WHEN substring(LineData, 1, 2) = '07' THEN RTRIM(substring(LineData, 378, 3)) ELSE '' END) AS Amount5CurrencyCode,
  max(CASE WHEN substring(LineData, 1, 2) = '07' THEN RTRIM(substring(LineData, 381, 19)) ELSE '' END) AS Amount5ConversionRate,
  max(CASE WHEN substring(LineData, 1, 2) = '07' THEN RTRIM(substring(LineData, 400, 20)) ELSE '' END) AS Amount5ConversionTimeStamp,
  max(CASE WHEN substring(LineData, 1, 2) = '07' THEN RTRIM(substring(LineData, 420, 20)) ELSE '' END) AS Amount6Name,
  max(CASE WHEN substring(LineData, 1, 2) = '07' THEN convert(money, substring(LineData, 440, 19)) / 10000 ELSE '' END) AS Amount6Value,
  max(CASE WHEN substring(LineData, 1, 2) = '07' THEN RTRIM(substring(LineData, 459, 3)) ELSE '' END) AS Amount6CurrencyCode,
  max(CASE WHEN substring(LineData, 1, 2) = '07' THEN RTRIM(substring(LineData, 462, 19)) ELSE '' END) AS Amount6ConversionRate,
  max(CASE WHEN substring(LineData, 1, 2) = '07' THEN RTRIM(substring(LineData, 481, 20)) ELSE '' END) AS Amount6ConversionTimeStamp,
  max(CASE WHEN substring(LineData, 1, 2) = '07' THEN RTRIM(substring(LineData, 501, 20)) ELSE '' END) AS Amount7Name,
  max(CASE WHEN substring(LineData, 1, 2) = '07' THEN convert(money, substring(LineData, 521, 19)) / 10000 ELSE '' END) AS Amount7Value,
  max(CASE WHEN substring(LineData, 1, 2) = '07' THEN RTRIM(substring(LineData, 540, 3)) ELSE '' END) AS Amount7CurrencyCode,
  max(CASE WHEN substring(LineData, 1, 2) = '07' THEN RTRIM(substring(LineData, 543, 19)) ELSE '' END) AS Amount7ConversionRate,
  max(CASE WHEN substring(LineData, 1, 2) = '07' THEN RTRIM(substring(LineData, 562, 20)) ELSE '' END) AS Amount7ConversionTimeStamp,
  max(CASE WHEN substring(LineData, 1, 2) = '09' THEN convert(int, substring(LineData, 13, 2)) ELSE '' END) AS FeeCount,
  max(CASE WHEN substring(LineData, 1, 2) = '09' THEN RTRIM(substring(LineData, 15, 20)) ELSE '' END) AS Fee1Type,
  max(CASE WHEN substring(LineData, 1, 2) = '09' THEN convert(money, substring(LineData, 35, 19)) / 10000 ELSE '' END) AS Fee1Value,
  max(CASE WHEN substring(LineData, 1, 2) = '09' THEN RTRIM(substring(LineData, 54, 3)) ELSE '' END) AS Fee1CurrencyCode,
  max(CASE WHEN substring(LineData, 1, 2) = '09' THEN RTRIM(substring(LineData, 57, 2)) ELSE '' END) AS Fee1AmountIndicator,
  max(CASE WHEN substring(LineData, 1, 2) = '09' THEN RTRIM(substring(LineData, 59, 1)) ELSE '' END) AS Fee1AmountImpactType,
  max(CASE WHEN substring(LineData, 1, 2) = '09' THEN RTRIM(substring(LineData, 60, 20)) ELSE '' END) AS Fee2Type,
  max(CASE WHEN substring(LineData, 1, 2) = '09' THEN convert(money, substring(LineData, 80, 19)) / 10000 ELSE '' END) AS Fee2Value,
  max(CASE WHEN substring(LineData, 1, 2) = '09' THEN RTRIM(substring(LineData, 99, 3)) ELSE '' END) AS Fee2CurrencyCode,
  max(CASE WHEN substring(LineData, 1, 2) = '09' THEN RTRIM(substring(LineData, 102, 2)) ELSE '' END) AS Fee2AmountIndicator,
  max(CASE WHEN substring(LineData, 1, 2) = '09' THEN RTRIM(substring(LineData, 104, 1)) ELSE '' END) AS Fee2AmountImpactType,
  max(CASE WHEN substring(LineData, 1, 2) = '09' THEN RTRIM(substring(LineData, 105, 20)) ELSE '' END) AS Fee3Type,
  max(CASE WHEN substring(LineData, 1, 2) = '09' THEN convert(money, substring(LineData, 125, 19)) / 10000 ELSE '' END) AS Fee3Value,
  max(CASE WHEN substring(LineData, 1, 2) = '09' THEN RTRIM(substring(LineData, 144, 3)) ELSE '' END) AS Fee3CurrencyCode,
  max(CASE WHEN substring(LineData, 1, 2) = '09' THEN RTRIM(substring(LineData, 147, 2)) ELSE '' END) AS Fee3AmountIndicator,
  max(CASE WHEN substring(LineData, 1, 2) = '09' THEN RTRIM(substring(LineData, 149, 1)) ELSE '' END) AS Fee3AmountImpactType,
  max(CASE WHEN substring(LineData, 1, 2) = '09' THEN RTRIM(substring(LineData, 150, 20)) ELSE '' END) AS Fee4Type,
  max(CASE WHEN substring(LineData, 1, 2) = '09' THEN convert(money, substring(LineData, 170, 19)) / 10000 ELSE '' END) AS Fee4Value,
  max(CASE WHEN substring(LineData, 1, 2) = '09' THEN RTRIM(substring(LineData, 189, 3)) ELSE '' END) AS Fee4CurrencyCode,
  max(CASE WHEN substring(LineData, 1, 2) = '09' THEN RTRIM(substring(LineData, 192, 2)) ELSE '' END) AS Fee4AmountIndicator,
  max(CASE WHEN substring(LineData, 1, 2) = '09' THEN RTRIM(substring(LineData, 194, 1)) ELSE '' END) AS Fee4AmountImpactType,
  max(CASE WHEN substring(LineData, 1, 2) = '09' THEN RTRIM(substring(LineData, 195, 20)) ELSE '' END) AS Fee5Type,
  max(CASE WHEN substring(LineData, 1, 2) = '09' THEN convert(money, substring(LineData, 215, 19)) / 10000 ELSE '' END) AS Fee5Value,
  max(CASE WHEN substring(LineData, 1, 2) = '09' THEN RTRIM(substring(LineData, 234, 3)) ELSE '' END) AS Fee5CurrencyCode,
  max(CASE WHEN substring(LineData, 1, 2) = '09' THEN RTRIM(substring(LineData, 237, 2)) ELSE '' END) AS Fee5AmountIndicator,
  max(CASE WHEN substring(LineData, 1, 2) = '09' THEN RTRIM(substring(LineData, 239, 1)) ELSE '' END) AS Fee5AmountImpactType,
  max(CASE WHEN substring(LineData, 1, 2) = '50' AND len(LineData) >= 621 THEN RTRIM(substring(LineData, 619, 3))
    WHEN substring(LineData, 1, 2) = '06' AND substring(LineData, 287, 3) = 'AFN' THEN 'AFN Interchange'
    WHEN substring(LineData, 1, 2) = '06' AND substring(LineData, 287, 3) IN ('MAC', 'SES', 'STR') THEN 'STAR Interchange'
    WHEN substring(LineData, 1, 2) = '06' AND substring(LineData, 287, 3) = 'NYC' THEN 'NYCE Interchange'
    WHEN substring(LineData, 1, 2) = '09' THEN RTRIM(substring(LineData, 240, 20)) ELSE '' END) AS Fee6Type,
  max(CASE WHEN substring(LineData, 1, 2) = '50' AND len(LineData) >= 621 AND substring(LineData, 619, 3) IN ('858', '885', '886', '890')
        AND substring(LineData, 13, 3) = 'REJ' THEN convert(money, 0.30)
    WHEN substring(LineData, 1, 2) = '50' AND len(LineData) >= 621
        AND substring(LineData, 13, 3) = 'REJ' THEN convert(money, 0.25)
    WHEN substring(LineData, 1, 2) = '50' AND len(LineData) >= 621
        AND substring(LineData, 619, 3) IN ('858', '885', '886', '890') THEN convert(money, 0.80)
    WHEN substring(LineData, 1, 2) = '50' AND len(LineData) >= 621
        AND substring(LineData, 619, 3) = '8A7' THEN convert(money, 0.50)
    WHEN substring(LineData, 1, 2) = '50' AND len(LineData) >= 621
        AND substring(LineData, 619, 3) = '860' THEN convert(money, 0.42)
    WHEN substring(LineData, 1, 2) = '50' AND len(LineData) >= 621
        AND substring(LineData, 619, 3) = '874' THEN convert(money, 0.35)
    WHEN substring(LineData, 1, 2) = '50' AND len(LineData) >= 621
        AND substring(LineData, 619, 3) = '875' THEN convert(money, 0.25)
    WHEN substring(LineData, 1, 2) = '06' AND substring(LineData, 287, 3) = 'AFN'
        AND substring(LineData, 148, 4) = '0000' AND substring(LineData, 130, 2) = '01'
      THEN convert(money, 0.46)
    WHEN substring(LineData, 1, 2) = '06' AND substring(LineData, 287, 3) = 'AFN'
        AND NOT (substring(LineData, 148, 4) = '0000' AND substring(LineData, 130, 2) = '01')
      THEN convert(money, 0.25)
    WHEN substring(LineData, 1, 2) = '06' AND substring(LineData, 287, 3) IN ('MAC', 'SES', 'STR')
        AND substring(LineData, 148, 4) = '0000' AND substring(LineData, 130, 2) = '01'
      THEN convert(money, 0.475)
    WHEN substring(LineData, 1, 2) = '06' AND substring(LineData, 287, 3) IN ('MAC', 'SES', 'STR')
        AND NOT (substring(LineData, 148, 4) = '0000' AND substring(LineData, 130, 2) = '01')
      THEN convert(money, 0.25)
    WHEN substring(LineData, 1, 2) = '06' AND substring(LineData, 287, 3) = 'NYC'
        AND substring(LineData, 148, 4) = '0000' AND substring(LineData, 130, 2) = '01'
      THEN convert(money, 0.50)
    WHEN substring(LineData, 1, 2) = '06' AND substring(LineData, 287, 3) = 'NYC'
        AND NOT (substring(LineData, 148, 4) = '0000' AND substring(LineData, 130, 2) = '01')
      THEN convert(money, 0.20)
    WHEN substring(LineData, 1, 2) = '09' THEN convert(money, substring(LineData, 260, 19)) / 10000 ELSE '' END) AS Fee6Value,
  max(CASE WHEN substring(LineData, 1, 2) = '50' AND len(LineData) >= 621 THEN RTRIM(substring(LineData, 288, 3))
    WHEN substring(LineData, 1, 2) = '09' THEN RTRIM(substring(LineData, 279, 3)) ELSE '840' END) AS Fee6CurrencyCode,
  max(CASE WHEN substring(LineData, 1, 2) = '09' THEN RTRIM(substring(LineData, 282, 2)) ELSE '' END) AS Fee6AmountIndicator,
  max(CASE WHEN substring(LineData, 1, 2) = '09' THEN RTRIM(substring(LineData, 284, 1)) ELSE '' END) AS Fee6AmountImpactType
INTO #TempTransactionPulseImport
--FROM (SELECT TOP 1000 * FROM dbo.tbl_rec_TransactionPulseImport(NOLOCK)) a
FROM dbo.tbl_rec_TransactionPulseImport(NOLOCK)
WHERE LineData NOT LIKE '01%' AND LineData NOT LIKE '88%' AND LineData NOT LIKE '99%'
GROUP BY substring(LineData, 3, 10)

DELETE FROM dbo.tbl_rec_TransactionPulse
WHERE DateTimeSettlement = @pSettDate 
	AND Currency = @Currency
	AND AcquirerBusinessID IN (SELECT DISTINCT AcquirerBusinessID FROM #TempTransactionPulseImport(NOLOCK))

INSERT INTO dbo.tbl_rec_TransactionPulse
SELECT * FROM #TempTransactionPulseImport (NOLOCK)

--SELECT * FROM #TempTransactionPulseImport (NOLOCK)
IF OBJECT_ID('tempdb..#TempTransactionPulseImport') IS NOT NULL
BEGIN
	TRUNCATE TABLE #TempTransactionPulseImport
	DROP TABLE #TempTransactionPulseImport
END

--TRUNCATE TABLE dbo.tbl_rec_TransactionPulseImport

END
GO
GRANT EXECUTE ON  [dbo].[usp_rec_TransactionPulse_Load] TO [WebV4Role]
GO
