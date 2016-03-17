CREATE TABLE [dbo].[tbl_DeviceStateFile]
(
[Id] [bigint] NOT NULL IDENTITY(1, 2) NOT FOR REPLICATION,
[StateFileName] [nvarchar] (60) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[DefAuthState] [bigint] NOT NULL,
[DefDenyState] [bigint] NOT NULL,
[NextStates] [nvarchar] (300) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LanguageStateOffsets] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TransactionTypes] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SourceAccounts] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[DestinationAccounts] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CurrencyCodes] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FastCashAmounts] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Languages] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NoReceiptValues] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FeeRefuseVal] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UpdatedUserId] [bigint] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tbl_DeviceStateFile] ADD CONSTRAINT [pk_DeviceStateFile] PRIMARY KEY NONCLUSTERED  ([Id]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [idx_DeviceStateFile_StateFileName] ON [dbo].[tbl_DeviceStateFile] ([StateFileName]) ON [PRIMARY]
GO
