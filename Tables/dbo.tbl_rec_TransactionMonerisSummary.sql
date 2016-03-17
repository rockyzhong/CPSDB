CREATE TABLE [dbo].[tbl_rec_TransactionMonerisSummary]
(
[DateTimeSettlement] [datetime] NOT NULL,
[Currency] [smallint] NOT NULL,
[SCDDebit] [money] NOT NULL,
[SCDFee] [money] NOT NULL,
[SCDProcessing] [money] NOT NULL,
[IDPDebit] [money] NOT NULL,
[IDPFee] [money] NOT NULL,
[IDPProcessing] [money] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tbl_rec_TransactionMonerisSummary] ADD CONSTRAINT [PK_tbl_rec_TransactionMonerisSummary] PRIMARY KEY CLUSTERED  ([DateTimeSettlement], [Currency]) ON [PRIMARY]
GO
