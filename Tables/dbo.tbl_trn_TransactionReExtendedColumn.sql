CREATE TABLE [dbo].[tbl_trn_TransactionReExtendedColumn]
(
[TranId] [bigint] NOT NULL,
[ImageData] [varbinary] (max) NULL,
[ExtendedColumn] [xml] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [inx_TransactionReExtendedColumn_TranId] ON [dbo].[tbl_trn_TransactionReExtendedColumn] ([TranId]) ON [PRIMARY]
GO
