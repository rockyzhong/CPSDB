CREATE TABLE [dbo].[tbl_AchFileHistory]
(
[Id] [bigint] NOT NULL IDENTITY(1, 2) NOT FOR REPLICATION,
[SettlementDate] [datetime] NOT NULL,
[AchFileId] [bigint] NOT NULL,
[AchFileNumber] [bigint] NOT NULL,
[CreditCount] [bigint] NOT NULL,
[CreditAmount] [money] NOT NULL,
[DebitCount] [bigint] NOT NULL,
[DebitAmount] [money] NOT NULL,
[FileCreationNo] [bigint] NULL,
[CreationDate] [datetime] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tbl_AchFileHistory] ADD CONSTRAINT [pk_AchFileHistory] PRIMARY KEY NONCLUSTERED  ([Id]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_AchFileHistory_SettlementDate_AchFileId] ON [dbo].[tbl_AchFileHistory] ([SettlementDate], [AchFileId]) ON [PRIMARY]
GO
