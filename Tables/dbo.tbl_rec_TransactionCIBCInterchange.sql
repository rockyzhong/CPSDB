CREATE TABLE [dbo].[tbl_rec_TransactionCIBCInterchange]
(
[FileDate] [datetime] NOT NULL,
[CurrencyCode] [smallint] NOT NULL,
[RecordID] [int] NOT NULL,
[RecordType] [char] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[AcquirerInstID] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[IssuerID] [char] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ConversionRate] [numeric] (19, 8) NOT NULL,
[InterchangeFeeIssuerCurrency] [numeric] (19, 8) NOT NULL,
[InterchangeFeeCAD] [money] NOT NULL,
[AmountCompletedIssuerCurrency] [numeric] (19, 8) NOT NULL,
[AmountCompletedCAD] [money] NOT NULL,
[BookingDate] [datetime] NOT NULL,
[RefNum] [varchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[TerminalID] [varchar] (16) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[RefNumInt] [int] NOT NULL,
[TransactionDateTime] [datetime] NOT NULL,
[PCode] [char] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tbl_rec_TransactionCIBCInterchange] ADD CONSTRAINT [PK_tbl_rec_TransactionCIBCInterchange] PRIMARY KEY CLUSTERED  ([FileDate], [CurrencyCode], [RecordID]) ON [PRIMARY]
GO
