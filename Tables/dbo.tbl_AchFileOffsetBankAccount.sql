CREATE TABLE [dbo].[tbl_AchFileOffsetBankAccount]
(
[Id] [bigint] NOT NULL IDENTITY(1, 2) NOT FOR REPLICATION,
[AchFileId] [bigint] NOT NULL,
[FundsType] [bigint] NOT NULL,
[BankAccountId] [bigint] NOT NULL,
[UpdatedUserId] [bigint] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tbl_AchFileOffsetBankAccount] ADD CONSTRAINT [pk_AchFileOffsetBankAccount] PRIMARY KEY NONCLUSTERED  ([Id]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [idx_AchFileOffsetBankAccount_AchFileId_FundsType] ON [dbo].[tbl_AchFileOffsetBankAccount] ([AchFileId], [FundsType]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_AchFileOffsetBankAccount_BankAccountId] ON [dbo].[tbl_AchFileOffsetBankAccount] ([BankAccountId]) ON [PRIMARY]
GO
