CREATE TABLE [dbo].[tbl_trn_Transaction]
(
[OriginalTransactionId] [bigint] NULL,
[Id] [bigint] NOT NULL IDENTITY(1, 2) NOT FOR REPLICATION,
[SystemDate] [datetime] NOT NULL,
[SystemTime] [datetime] NULL,
[SystemSettlementDate] [datetime] NOT NULL,
[TransactionType] [bigint] NOT NULL,
[TransactionFlags] [bigint] NULL,
[TransactionReason] [bigint] NULL,
[TransactionState] [bigint] NOT NULL CONSTRAINT [DF_tbl_trn_Transaction_TransactionState] DEFAULT ((1)),
[DeviceId] [bigint] NOT NULL,
[DeviceDate] [datetime] NOT NULL,
[DeviceSequence] [bigint] NOT NULL,
[NetworkId] [bigint] NOT NULL,
[NetworkSequence] [bigint] NULL,
[NetworkSettlementDate1] [datetime] NOT NULL,
[NetworkSettlementDate2] [datetime] NULL,
[NetworkTransactionId] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NetworkMerchantStationId] [bigint] NULL,
[RoutingCode] [bigint] NULL,
[AmountRequest] [bigint] NOT NULL,
[AmountAuthenticate] [bigint] NOT NULL,
[AmountSettlement] [bigint] NOT NULL,
[AmountSettlementDestination] [bigint] NOT NULL,
[AmountSettlementReconciliation] [bigint] NULL,
[AmountSurchargeRequest] [bigint] NULL,
[AmountSurchargeFixed] [bigint] NOT NULL CONSTRAINT [DF_tbl_trn_Transaction_AmountSurchargeFixed] DEFAULT ((0)),
[AmountSurchargeWaived] [bigint] NOT NULL,
[AmountSurcharge] [bigint] NOT NULL,
[AmountCommission] [bigint] NOT NULL CONSTRAINT [DF_tbl_trn_Transaction_AmountCommission] DEFAULT ((0)),
[AmountCashBack] [bigint] NOT NULL CONSTRAINT [DF_tbl_trn_Transaction_AmountCashBack] DEFAULT ((0)),
[AmountConvinience] [bigint] NOT NULL CONSTRAINT [DF_tbl_trn_Transaction_AmountConvinience] DEFAULT ((0)),
[SurchargeWaiveAuthorityId] [bigint] NULL,
[CurrencyRequest] [bigint] NOT NULL,
[CurrencySource] [bigint] NOT NULL,
[CurrencyDestination] [bigint] NOT NULL,
[CurrencyDeviceRate] [numeric] (9, 6) NOT NULL,
[CurrencyNetworkRate] [numeric] (9, 6) NOT NULL,
[ResponseTypeId] [bigint] NULL,
[ResponseCodeInternal] [bigint] NULL,
[ResponseCodeExternal] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ResponseSubCodeExternal] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerId] [bigint] NULL,
[CustomerMediaType] [bigint] NULL,
[CustomerMediaEntryMode] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerMediaDataPart1] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerMediaDataPart2] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerMediaDataHash] [varbinary] (512) NULL,
[CustomerMediaDataEncrypted] [varbinary] (512) NULL,
[CustomerMediaExpiryDate] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AuthenticationNumber] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ReferenceNumber] [nvarchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ApprovalCode] [nvarchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BatchId] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PAN] [nvarchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BINRange] [nvarchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BINGroup] [bigint] NULL,
[SourceAccountType] [bigint] NULL,
[DestinationAccountType] [bigint] NULL,
[SourcePCode] [nvarchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IssuerNetworkId] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ProcessingFee] [bigint] NULL,
[ServiceFee] [bigint] NULL,
[ReversalType] [bigint] NULL,
[Title31Posted] [bit] NULL,
[ACHEntryClass] [nvarchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ACHECheckAck] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SourceDeviceId] [bigint] NULL,
[NetAddr] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NetAPI] [bigint] NULL,
[PayoutCash] [bigint] NULL,
[PayoutDeposit] [bigint] NULL,
[PayoutChips] [bigint] NULL,
[PayoutMarker] [bigint] NULL,
[PayoutOther] [bigint] NULL,
[PayoutStatus] [bigint] NULL,
[CreatedUserId] [bigint] NULL,
[SmartAcquierId] [bigint] NULL,
[ProcessedDate] [datetime] NULL CONSTRAINT [DF_tbl_trn_Transaction_ProcessedDate] DEFAULT (((1900)-(1))-(1)),
[HostMerchantID] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[HostTerminalID] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tbl_trn_Transaction] ADD CONSTRAINT [pk_Transaction] PRIMARY KEY CLUSTERED  ([Id]) WITH (FILLFACTOR=95) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [inx_SystemDate_CMDHASH_PayoutStatus_DeviceId] ON [dbo].[tbl_trn_Transaction] ([CustomerMediaDataHash], [PayoutStatus], [DeviceId], [SystemDate]) INCLUDE ([AmountAuthenticate], [AmountRequest], [AmountSettlement], [AmountSurchargeRequest], [ApprovalCode], [CustomerMediaType], [DeviceDate], [Id], [PayoutCash], [PayoutChips], [PayoutDeposit], [PayoutMarker], [PayoutOther], [ResponseCodeInternal], [TransactionType]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [inx_DeviceId_DeviceSequence_CMDHASH_TranType] ON [dbo].[tbl_trn_Transaction] ([DeviceId], [DeviceSequence], [CustomerMediaDataHash], [TransactionType]) INCLUDE ([AmountCommission], [AmountSettlement], [AmountSettlementDestination], [AmountSurcharge], [AmountSurchargeFixed], [AmountSurchargeWaived], [Id], [ReversalType], [SystemDate], [TransactionState]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [inx_DeviceId_SystemTime] ON [dbo].[tbl_trn_Transaction] ([DeviceId], [SystemTime], [BatchId]) INCLUDE ([AmountAuthenticate], [AmountCashBack], [AmountConvinience], [AmountRequest], [AmountSettlement], [AmountSurcharge], [DeviceDate], [DeviceSequence], [Id], [IssuerNetworkId], [PAN], [ResponseCodeInternal], [SourceAccountType], [TransactionFlags], [TransactionReason], [TransactionType]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [inx_OriginalTranId] ON [dbo].[tbl_trn_Transaction] ([OriginalTransactionId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [inx_PayoutStatus] ON [dbo].[tbl_trn_Transaction] ([PayoutStatus]) WITH (FILLFACTOR=80, PAD_INDEX=ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [inx_ProcessedDate] ON [dbo].[tbl_trn_Transaction] ([ProcessedDate]) WITH (FILLFACTOR=80, PAD_INDEX=ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [inx_SystemDate] ON [dbo].[tbl_trn_Transaction] ([SystemDate]) WITH (FILLFACTOR=80, PAD_INDEX=ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [inx_SystemTime] ON [dbo].[tbl_trn_Transaction] ([SystemTime]) INCLUDE ([Id]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [inx_deviceid_sequence_transtype_systime] ON [dbo].[tbl_trn_Transaction] ([SystemTime], [DeviceId], [DeviceSequence], [TransactionType]) WHERE ([Id]>(5562151)) ON [PRIMARY]
GO
