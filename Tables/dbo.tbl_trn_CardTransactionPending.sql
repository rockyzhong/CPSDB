CREATE TABLE [dbo].[tbl_trn_CardTransactionPending]
(
[id] [bigint] NOT NULL IDENTITY(1, 2) NOT FOR REPLICATION,
[DeviceId] [bigint] NULL,
[DeviceSequence] [bigint] NULL,
[CustomerMediaDataHash] [varbinary] (512) NULL,
[CombineTime] [datetime] NULL,
[TransactionType] [bigint] NULL,
[SurchageWaivedUserId] [bigint] NULL,
[CustomerId] [bigint] NULL,
[CustomerMediaType] [bigint] NULL,
[AmountRequest] [bigint] NULL,
[AuthenticationNumber] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[HostTerminalID] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[HostMerchantID] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreatedUserId] [bigint] NULL,
[CustomerMediaEntryMode] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ExtendedColumn] [xml] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[tbl_trn_CardTransactionPending] ADD CONSTRAINT [pk_trn_CardTransactionPending] PRIMARY KEY NONCLUSTERED  ([id]) ON [PRIMARY]
GO
