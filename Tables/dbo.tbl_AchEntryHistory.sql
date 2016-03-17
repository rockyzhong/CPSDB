CREATE TABLE [dbo].[tbl_AchEntryHistory]
(
[Id] [bigint] NOT NULL IDENTITY(1, 2) NOT FOR REPLICATION,
[SettlementDate] [datetime] NOT NULL,
[AchFileId] [bigint] NOT NULL,
[AchFileNumber] [bigint] NOT NULL,
[BankAccountHolderName] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[BankAccountType] [bigint] NOT NULL,
[BankAccountRta] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Amount] [money] NOT NULL,
[BatchHeader] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[StandardEntryClassCode] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ReferenceName] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[PayoutDate] [datetime] NOT NULL,
[DueDate] [datetime] NULL,
[AddendaTypeCode] [nvarchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AddendaData] [nvarchar] (80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SettlementStatus] [bigint] NOT NULL CONSTRAINT [DF_tbl_AchEntryHistory_SettlementStatus] DEFAULT ((1))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tbl_AchEntryHistory] ADD CONSTRAINT [pk_AchEntryHistory] PRIMARY KEY NONCLUSTERED  ([Id]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_AchEntryHistory_SettlementDate_SettlementStatus_AchFileId_AchFileNumber] ON [dbo].[tbl_AchEntryHistory] ([SettlementDate], [SettlementStatus], [AchFileId], [AchFileNumber]) WITH (FILLFACTOR=80, PAD_INDEX=ON) ON [PRIMARY]
GO
