CREATE TABLE [dbo].[tbl_trn_TransactionPaymentMethod]
(
[TransId] [bigint] NOT NULL,
[PaymentId] [bigint] NOT NULL,
[Amount] [bigint] NOT NULL CONSTRAINT [DF_tbl_trn_TransactionPaymentMethod] DEFAULT ((0))
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_TransactionPaymentMethod_TransId] ON [dbo].[tbl_trn_TransactionPaymentMethod] ([TransId]) ON [PRIMARY]
GO
