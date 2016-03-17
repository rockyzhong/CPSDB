CREATE TABLE [dbo].[tbl_rec_TransactionCIBC]
(
[DateTimeSettlement] [datetime] NOT NULL,
[TerminalID] [varchar] (16) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[DateTimeLocal] [datetime] NOT NULL,
[RetrievalRefNumInt] [int] NOT NULL,
[MsgType] [int] NOT NULL,
[Currency] [smallint] NOT NULL,
[PCode] [int] NOT NULL,
[AmountTransactionCAD] [money] NOT NULL,
[SettleDate] [char] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CaptureDate] [char] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[AmountFeeCAD] [money] NOT NULL,
[AcqInstID] [varchar] (11) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[RetrievalRefNum] [varchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CardAcceptorID] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[DCC_Cat] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[DCC_Disp] [varchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[DCC_CurrencyCode] [char] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[DCC_ExchangeRate] [numeric] (19, 12) NOT NULL,
[DCC_ForeignAmount] [numeric] (19, 12) NOT NULL,
[DCC_Outcome] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[DCC_Quote_ID] [varchar] (42) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[PostalCode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[AmountReconciliationCAD] [money] NOT NULL,
[IssuerID] [char] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tbl_rec_TransactionCIBC] ADD CONSTRAINT [PK_DROP TABLE dbo.tbl_rec_TransactionCIBC] PRIMARY KEY CLUSTERED  ([DateTimeSettlement], [TerminalID], [DateTimeLocal], [RetrievalRefNumInt], [MsgType], [Currency]) ON [PRIMARY]
GO
