CREATE TABLE [dbo].[tbl_BINRange]
(
[Id] [bigint] NOT NULL IDENTITY(1, 2) NOT FOR REPLICATION,
[CountryNumberCode] [bigint] NULL,
[BINVal] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[BINLen] [int] NOT NULL,
[PANLen] [int] NOT NULL,
[NetworkID] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CountryCode] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BaseCurrencyCode] [int] NULL,
[BINGroup] [int] NULL,
[CreditDebitFlag] [int] NULL,
[TransactionTypeMask] [int] NULL,
[TransactionTypeList] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UpdatedUserId] [bigint] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tbl_BINRange] ADD CONSTRAINT [pk_BINRange] PRIMARY KEY NONCLUSTERED  ([Id]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_BINRange_BINVal_PANLen_CountryNumberCode_NetworkID] ON [dbo].[tbl_BINRange] ([BINVal], [PANLen], [CountryNumberCode], [NetworkID]) WITH (FILLFACTOR=80, PAD_INDEX=ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_BINRange_CountryNumberCode_BINVal_BinGroup_TransactionTypeList] ON [dbo].[tbl_BINRange] ([CountryNumberCode], [BINVal], [BINGroup], [TransactionTypeList]) WITH (FILLFACTOR=80, PAD_INDEX=ON) ON [PRIMARY]
GO
