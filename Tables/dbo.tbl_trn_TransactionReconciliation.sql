CREATE TABLE [dbo].[tbl_trn_TransactionReconciliation]
(
[Id] [bigint] NOT NULL IDENTITY(1, 2) NOT FOR REPLICATION,
[SystemDate] [datetime] NOT NULL CONSTRAINT [DF_tbl_trn_TransactionReconciliation_SystemDate] DEFAULT (getutcdate()),
[FileId] [bigint] NULL,
[TransactionId] [bigint] NULL,
[NetworkTransactionId] [bigint] NULL,
[TransactionType] [bigint] NULL,
[IssuerNetworkId] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IssuerInstitutionId] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MerchantId] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TerminalName] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DeviceId] [bigint] NULL,
[DeviceDate] [datetime] NULL,
[DeviceSequence] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AmountRequest] [bigint] NULL,
[AmountSettlement] [bigint] NOT NULL,
[AmountSurcharge] [bigint] NULL,
[AmountInterchange] [bigint] NULL,
[ResponseCodeInternal] [bigint] NOT NULL,
[ResponseCodeExternal] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerMediaDataPart1] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerMediaDataPart2] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PAN] [nvarchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BINRange] [nvarchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RetrevalNumber] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ReverseType] [bigint] NULL,
[ProcessingFee] [bigint] NULL,
[RequestType] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SettlementStatus] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ReconciliationStatus] [bigint] NULL CONSTRAINT [DF_TransactionReconciliation_ReconciliationStatus] DEFAULT ((1)),
[UnreconciledStatus] [bigint] NULL,
[ReconciliationComment] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tbl_trn_TransactionReconciliation] ADD CONSTRAINT [pk_TransactionReconciliation] PRIMARY KEY NONCLUSTERED  ([Id]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_TransactionReconciliation_SystemDate_ReconciliationStatus] ON [dbo].[tbl_trn_TransactionReconciliation] ([SystemDate], [ReconciliationStatus]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_TransactionReconciliation_TransactionId] ON [dbo].[tbl_trn_TransactionReconciliation] ([TransactionId]) ON [PRIMARY]
GO
