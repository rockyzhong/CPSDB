CREATE TABLE [dbo].[tbl_trn_TransactionTeleCheckACHCount]
(
[CustomerId] [bigint] NOT NULL,
[EnrollDate] [datetime] NOT NULL,
[ACHTransCount] [bigint] NULL,
[ACHTransAmount] [bigint] NULL,
[NonACHTransCount] [bigint] NULL,
[NonACHTransAmount] [bigint] NULL,
[UpdatedDate] [datetime] NOT NULL
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_TransactionTeleCheckACHCount_CID] ON [dbo].[tbl_trn_TransactionTeleCheckACHCount] ([CustomerId]) ON [PRIMARY]
GO
