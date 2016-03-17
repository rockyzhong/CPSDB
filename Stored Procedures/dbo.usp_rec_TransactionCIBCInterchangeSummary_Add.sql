SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[usp_rec_TransactionCIBCInterchangeSummary_Add]
    @pFileDate datetime,
    @pCurrencyCode smallint,
    @pRecordID int,
    @pRecordType char(4),
    @pAcquirerInstID varchar(10),
    @pIssuerID char(4),
    @pFinancialCount int,
    @pNonFinancialCount int,
    @pExceptionCount int,
    @pInterchangeDebitIssuerCurrency numeric(19, 8),
    @pInterchangeCreditIssuerCurrency numeric(19, 8),
    @pInterchangeNetIssuerCurrency numeric(19, 8),
    @pInterchangeCAD money,
    @pInterchangeConversionRate numeric(19, 8)
AS
BEGIN
SET NOCOUNT ON

INSERT INTO dbo.tbl_rec_TransactionCIBCInterchangeSummary (
    FileDate,
    CurrencyCode,
    RecordID,
    RecordType,
    AcquirerInstID,
    IssuerID,
    FinancialCount,
    NonFinancialCount,
    ExceptionCount,
    InterchangeDebitIssuerCurrency,
    InterchangeCreditIssuerCurrency,
    InterchangeNetIssuerCurrency,
    InterchangeCAD,
    InterchangeConversionRate
)
SELECT
    @pFileDate,
    @pCurrencyCode,
    @pRecordID,
    @pRecordType,
    @pAcquirerInstID,
    @pIssuerID,
    @pFinancialCount,
    @pNonFinancialCount,
    @pExceptionCount,
    @pInterchangeDebitIssuerCurrency,
    @pInterchangeCreditIssuerCurrency,
    @pInterchangeNetIssuerCurrency,
    @pInterchangeCAD,
    @pInterchangeConversionRate

-- per Adam's comment, we could trust the data in the recon file now.

-- Update CAD Amount in Detail records for this File Date and CurrencyCode
--UPDATE tbl_rec_TransactionCIBCInterchange
--SET InterchangeFeeCAD = convert(money, InterchangeFeeIssuerCurrency * @pInterchangeConversionRate)
--WHERE FileDate = @pFileDate
--  AND CurrencyCode = @pCurrencyCode
--  AND CountryCode = @pCountryCode

END

GO
GRANT EXECUTE ON  [dbo].[usp_rec_TransactionCIBCInterchangeSummary_Add] TO [WebV4Role]
GO
