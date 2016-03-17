CREATE TABLE [dbo].[tbl_trn_TransactionConsolidated]
(
[SettlementDate] [datetime] NOT NULL,
[DeviceId] [bigint] NOT NULL,
[DeviceDate] [datetime] NOT NULL,
[DeviceSequence] [int] NOT NULL,
[TransactionType] [smallint] NOT NULL,
[TransactionId] [bigint] NOT NULL,
[SystemTime] [datetime] NOT NULL,
[NetworkSequence] [int] NOT NULL,
[BINRange] [nvarchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PAN] [nvarchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ResponseCodeInternal] [smallint] NULL,
[NetworkId] [int] NULL,
[DestCode] [tinyint] NOT NULL,
[AmountRequest] [money] NOT NULL,
[AmountSettlement] [money] NOT NULL,
[AmountSurcharge] [money] NOT NULL,
[AmountGatewayDebit] [money] NULL,
[AmountInterchangeCollected] [money] NULL,
[AmountGatewayProcFee] [money] NULL,
[TerminalName] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CurrencyRequest] [smallint] NOT NULL,
[TransactionFlags] [bigint] NULL,
[IssuerNetworkId] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ReconciliationStatus] [tinyint] NOT NULL,
[UnreconciledStatus] [tinyint] NULL,
[ReconciliationComment] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SettlementAllocationDate] [datetime] NULL,
[SurchargeAllocationDate] [datetime] NULL,
[InterchangeAllocationDate] [datetime] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tbl_trn_TransactionConsolidated] ADD CONSTRAINT [pk_tbl_trn_TransactionConsolidated] PRIMARY KEY CLUSTERED  ([SettlementDate], [DeviceId], [DeviceDate], [DeviceSequence], [TransactionType]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_tbl_trn_TransactionConsolidated_InterchangeAllocationDate] ON [dbo].[tbl_trn_TransactionConsolidated] ([InterchangeAllocationDate]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_tbl_trn_TransactionConsolidated_SettlementAllocationDate] ON [dbo].[tbl_trn_TransactionConsolidated] ([SettlementAllocationDate]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_tbl_trn_TransactionConsolidated_SurchargeAllocationDate] ON [dbo].[tbl_trn_TransactionConsolidated] ([SurchargeAllocationDate]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_tbl_trn_TransactionConsolidated_TransactionId] ON [dbo].[tbl_trn_TransactionConsolidated] ([TransactionId]) ON [PRIMARY]
GO
