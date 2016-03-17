CREATE TABLE [dbo].[tbl_trn_TransactionReversal]
(
[Id] [bigint] NOT NULL IDENTITY(1, 2) NOT FOR REPLICATION,
[SystemDate] [datetime] NOT NULL,
[TransactionType] [bigint] NOT NULL,
[TransactionFlags] [bigint] NULL,
[TransactionReason] [bigint] NULL,
[DeviceId] [bigint] NOT NULL,
[DeviceDate] [datetime] NOT NULL,
[DeviceSequence] [bigint] NOT NULL,
[NetworkId] [bigint] NOT NULL,
[NetworkSequence] [bigint] NULL,
[NetworkSettlementDate1] [datetime] NOT NULL,
[NetworkSettlementDate2] [datetime] NULL,
[NetworkData] [nvarchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AmountRequest] [bigint] NOT NULL,
[AmountAuthenticate] [bigint] NOT NULL,
[AmountDispense] [bigint] NOT NULL,
[AmountSurcharge] [bigint] NOT NULL,
[AmountDispenseDestination] [bigint] NOT NULL,
[AmountSurchargeDestination] [bigint] NOT NULL,
[AmountSurchargeWaived] [bigint] NOT NULL,
[AmountCashBack] [bigint] NOT NULL,
[AmountConvinience] [bigint] NOT NULL,
[SurchargeWaiveAuthorityId] [bigint] NULL,
[CurrencyRequest] [bigint] NOT NULL,
[CurrencySource] [bigint] NOT NULL,
[CurrencyDestination] [bigint] NOT NULL,
[CurrencyDeviceRate] [numeric] (9, 6) NOT NULL,
[CurrencyNetworkRate] [numeric] (9, 6) NOT NULL,
[CustomerMediaDataHash] [varbinary] (512) NULL,
[CustomerMediaDataEncrypted] [varbinary] (512) NULL,
[CustomerMediaExpiryDate] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AuthenticationNumber] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ReferenceNumber] [nvarchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ApprovalCode] [nvarchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BatchId] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BINGroup] [bigint] NULL,
[SourceAccountType] [bigint] NULL,
[DestinationAccountType] [bigint] NULL,
[IssuerNetworkId] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SourceDeviceName] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreatedUserId] [bigint] NULL,
[SmartAcquierId] [bigint] NULL,
[ProcessedDate] [datetime] NULL CONSTRAINT [DF_tbl_trn_TransactionReversal_ProcessedDate] DEFAULT (((1900)-(1))-(1))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tbl_trn_TransactionReversal] ADD CONSTRAINT [pk_TransactionRerversal] PRIMARY KEY NONCLUSTERED  ([Id]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_TransactionReversal_SystemDate_SmartAcquierId] ON [dbo].[tbl_trn_TransactionReversal] ([SystemDate], [SmartAcquierId]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'AES-256 encrypted data (card number)', 'SCHEMA', N'dbo', 'TABLE', N'tbl_trn_TransactionReversal', 'COLUMN', N'CustomerMediaDataEncrypted'
GO
EXEC sp_addextendedproperty N'MS_Description', N'SHA1 hashed data (card number)', 'SCHEMA', N'dbo', 'TABLE', N'tbl_trn_TransactionReversal', 'COLUMN', N'CustomerMediaDataHash'
GO
