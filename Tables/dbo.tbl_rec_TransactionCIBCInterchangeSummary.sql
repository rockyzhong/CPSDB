CREATE TABLE [dbo].[tbl_rec_TransactionCIBCInterchangeSummary]
(
[FileDate] [datetime] NOT NULL,
[CurrencyCode] [smallint] NOT NULL,
[RecordID] [int] NOT NULL,
[RecordType] [char] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[AcquirerInstID] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[IssuerID] [char] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[FinancialCount] [int] NOT NULL,
[NonFinancialCount] [int] NOT NULL,
[ExceptionCount] [int] NOT NULL,
[InterchangeDebitIssuerCurrency] [numeric] (19, 8) NOT NULL,
[InterchangeCreditIssuerCurrency] [numeric] (19, 8) NOT NULL,
[InterchangeNetIssuerCurrency] [numeric] (19, 8) NOT NULL,
[InterchangeCAD] [money] NOT NULL,
[InterchangeConversionRate] [numeric] (19, 8) NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tbl_rec_TransactionCIBCInterchangeSummary] ADD CONSTRAINT [PK_tbl_rec_TransactionCIBCInterchangeSummary] PRIMARY KEY CLUSTERED  ([FileDate], [CurrencyCode], [RecordID]) ON [PRIMARY]
GO
