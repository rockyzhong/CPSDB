CREATE TABLE [dbo].[tbl_trn_TransactionAmountInter]
(
[TranId] [bigint] NOT NULL,
[AmountInterchange] [bigint] NOT NULL CONSTRAINT [DF_tbl_trn_TransactionAmountInter_AmountInterchange] DEFAULT ((0)),
[AmountInterchangePaid] [bigint] NOT NULL CONSTRAINT [DF_tbl_trn_TransactionAmountInter_AmountInterchangePaid] DEFAULT ((0))
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [inx_TransactionAmountInter_TranId] ON [dbo].[tbl_trn_TransactionAmountInter] ([TranId]) ON [PRIMARY]
GO
