CREATE TABLE [dbo].[tbl_AchTransaction]
(
[Id] [bigint] NOT NULL IDENTITY(1, 2) NOT FOR REPLICATION,
[SettlementDate] [datetime] NULL,
[SettlementTime] [datetime] NULL,
[SourceType] [bigint] NULL CONSTRAINT [DF_tbl_AchTransaction_SourceType] DEFAULT ((1)),
[SourceId] [bigint] NULL,
[BankAccountId] [bigint] NULL,
[FundsType] [bigint] NULL,
[ApprovedCount] [bigint] NULL CONSTRAINT [DF_tbl_AchTransaction_ApprovedCount] DEFAULT ((0)),
[ApprovedDispensedCount] [bigint] NULL CONSTRAINT [DF_tbl_AchTransaction_ApprovedDispensedCount] DEFAULT ((0)),
[ApprovedSurchargedCount] [bigint] NULL CONSTRAINT [DF_tbl_AchTransaction_ApprovedSurchargedCount] DEFAULT ((0)),
[DeclinedCount] [bigint] NULL CONSTRAINT [DF_tbl_AchTransaction_DeclinedCount] DEFAULT ((0)),
[BaseAmount] [money] NULL,
[Amount] [money] NULL,
[SplitType] [bigint] NULL CONSTRAINT [DF_tbl_AchTransaction_SplitPercent] DEFAULT ((0)),
[SplitData] [bigint] NULL CONSTRAINT [DF_tbl_AchTransaction_SplitAmount] DEFAULT ((1000000)),
[AchFileId] [bigint] NULL,
[BatchHeader] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[StandardEntryClassCode] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ScheduleType] [bigint] NULL,
[ScheduleDay] [bigint] NULL CONSTRAINT [DF_tbl_AchTransaction_ScheduleDay] DEFAULT ((0)),
[ThresholdAmount] [bigint] NULL CONSTRAINT [DF_tbl_AchTransaction_ThresholdAmount] DEFAULT ((0)),
[DepositExec] [bigint] NULL CONSTRAINT [DF_tbl_AchTransaction_DepositExec] DEFAULT ((0)),
[CutoverOffset] [bigint] NULL CONSTRAINT [DF_tbl_AchTransaction_CutoverOffset] DEFAULT ((0)),
[Tax] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Description] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SettlementType] [bigint] NULL,
[SettlementStatus] [bigint] NOT NULL CONSTRAINT [DF_tbl_AchTransaction_SettlementStatus] DEFAULT ((1))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tbl_AchTransaction] ADD CONSTRAINT [pk_AchTransaction] PRIMARY KEY NONCLUSTERED  ([Id]) WITH (FILLFACTOR=80, PAD_INDEX=ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_AchTransaction_AchFileId] ON [dbo].[tbl_AchTransaction] ([AchFileId]) WITH (FILLFACTOR=80, PAD_INDEX=ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_AchTransaction_BankAccountId] ON [dbo].[tbl_AchTransaction] ([BankAccountId]) WITH (FILLFACTOR=80, PAD_INDEX=ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_AchTransaction_FundsType_SettlementType_SourceId_SettlementTime] ON [dbo].[tbl_AchTransaction] ([FundsType], [SettlementType], [SourceId], [SettlementTime]) WITH (FILLFACTOR=80, PAD_INDEX=ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_AchTransaction_SettlementDate_SettlementStatus_AchFileId_BatchHeader_StandardEntryClassCode_BankAccountId_FundsType] ON [dbo].[tbl_AchTransaction] ([SettlementDate], [SettlementStatus], [AchFileId], [BatchHeader], [StandardEntryClassCode], [BankAccountId], [FundsType]) WITH (FILLFACTOR=80, PAD_INDEX=ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_AchTransaction_SettlementDate_SettlementStatus_AchFileId_BatchHeader_StandardEntryClassCode_BankAccountId_FundsType_SourceId] ON [dbo].[tbl_AchTransaction] ([SettlementDate], [SettlementStatus], [AchFileId], [BatchHeader], [StandardEntryClassCode], [BankAccountId], [FundsType], [SourceType], [SourceId]) WITH (FILLFACTOR=80, PAD_INDEX=ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_AchTransaction_SettlementDate_SettlementStatus_AchFileId_BatchHeader_StandardEntryClassCode_BankAccountId_SourceId] ON [dbo].[tbl_AchTransaction] ([SettlementDate], [SettlementStatus], [AchFileId], [BatchHeader], [StandardEntryClassCode], [BankAccountId], [SourceType], [SourceId]) WITH (FILLFACTOR=80, PAD_INDEX=ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_AchTransaction_SourceId_SourceType] ON [dbo].[tbl_AchTransaction] ([SourceId], [SourceType]) WITH (FILLFACTOR=80, PAD_INDEX=ON) ON [PRIMARY]
GO
