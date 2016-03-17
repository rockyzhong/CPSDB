SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[usp_rec_TransactionCIBCInterchange_Add]
    @pFileDate datetime,
    @pCurrencyCode smallint,
    @pRecordID int,
    @pRecordType char(4),
    @pAcquirerInstID varchar(10),
    @pIssuerID char(4),
    @pConversionRate numeric(19, 8),
    @pInterchangeFeeIssuerCurrency numeric(19, 8),
    @pAmountCompletedIssuerCurrency numeric(19, 8),
    @pAmountCompletedCAD money,
    @pBookingDate datetime,
    @pRefNum varchar(12),
    @pTerminalID varchar(16),
    @pTransactionDateTime datetime,
    @pPCode char(6)
AS
BEGIN
SET NOCOUNT ON

INSERT INTO dbo.tbl_rec_TransactionCIBCInterchange (
	FileDate,
	CurrencyCode,
	RecordID,
	RecordType,
	AcquirerInstID,
	IssuerID,
	ConversionRate,
	InterchangeFeeIssuerCurrency,
	InterchangeFeeCAD,
	AmountCompletedIssuerCurrency,
	AmountCompletedCAD,
	BookingDate,
	RefNum,
	TerminalID,
	RefNumInt,
	TransactionDateTime,
	PCode
)
SELECT
    @pFileDate,
    @pCurrencyCode,
	@pRecordID,
    @pRecordType,
    @pAcquirerInstID,
    @pIssuerID,
    @pConversionRate,
    @pInterchangeFeeIssuerCurrency,
    0, -- InterchangeFeeCAD Updated after Summary Data Imported
    @pAmountCompletedIssuerCurrency,
    (CASE WHEN @pAmountCompletedCAD > 10 THEN @pAmountCompletedCAD / 100 ELSE @pAmountCompletedCAD END),
    @pBookingDate,
    @pRefNum,
    @pTerminalID,
    convert(int, RIGHT(@pRefNum, 6)),
    @pTransactionDateTime,
    @pPCode

END

GO
GRANT EXECUTE ON  [dbo].[usp_rec_TransactionCIBCInterchange_Add] TO [WebV4Role]
GO
