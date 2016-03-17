CREATE TABLE [dbo].[tbl_trn_TransactionACH]
(
[SettlementDate] [datetime] NOT NULL,
[DateTimeClose] [datetime] NOT NULL,
[SourceType] [int] NOT NULL,
[SourceCode] [bigint] NOT NULL,
[AccountID] [int] NOT NULL,
[FundsType] [char] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[BaseTotal] [money] NOT NULL,
[Amount] [money] NOT NULL,
[ApprWthCount] [int] NOT NULL,
[DeclWthCount] [int] NOT NULL,
[ApprNFCount] [int] NOT NULL,
[DeclNFCount] [int] NOT NULL,
[SurchargedCount] [int] NOT NULL,
[StandardEntryCode] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BatchHeader] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ACHDesc] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ACHPayoutDate] [datetime] NULL,
[ACHFileID] [bigint] NULL,
[FileNo] [int] NULL,
[Currency] [smallint] NOT NULL,
[Id] [bigint] NOT NULL IDENTITY(1, 1)
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tbl_trn_TransactionACH] ADD CONSTRAINT [PK_tbl_trn_TransactionACH] PRIMARY KEY CLUSTERED  ([SettlementDate], [DateTimeClose], [SourceType], [SourceCode], [AccountID], [FundsType]) ON [PRIMARY]
GO
