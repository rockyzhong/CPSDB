CREATE TABLE [dbo].[tbl_trn_TransactionCheck]
(
[Id] [bigint] NOT NULL,
[SystemDate] [datetime] NOT NULL,
[SettlementDate] [datetime] NOT NULL,
[MerchantId] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[NetworkTransactionId] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[RequestType] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_tbl_trn_TransactionCheckSettlement_RequestType] DEFAULT (N'R'),
[AmountSettlement] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tbl_trn_TransactionCheck] ADD CONSTRAINT [pk_TransactionCheck] PRIMARY KEY NONCLUSTERED  ([Id]) ON [PRIMARY]
GO
