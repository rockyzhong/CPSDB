CREATE TABLE [dbo].[tbl_trn_TransactionAllocation]
(
[Id] [bigint] NOT NULL IDENTITY(1, 2) NOT FOR REPLICATION,
[TransactionId] [bigint] NULL,
[SystemDate] [datetime] NULL,
[DeviceId] [bigint] NULL,
[BankAccountId] [bigint] NULL,
[FundsType] [bigint] NULL,
[BaseAmount] [money] NULL,
[Amount] [money] NULL,
[SplitType] [bigint] NULL CONSTRAINT [DF_tbl_trn_TransactionAllocation_SplitType] DEFAULT ((0)),
[SplitData] [money] NULL CONSTRAINT [DF_tbl_trn_TransactionAllocation_SplitData] DEFAULT ((1)),
[SettlementType] [bigint] NULL,
[SettlementDate] [datetime] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tbl_trn_TransactionAllocation] ADD CONSTRAINT [pk_TransactionAllocation] PRIMARY KEY NONCLUSTERED  ([Id]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_TransactionAllocation_TransactionId_SettlementType_FundsType] ON [dbo].[tbl_trn_TransactionAllocation] ([TransactionId], [SettlementType], [FundsType]) ON [PRIMARY]
GO
