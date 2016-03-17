CREATE TABLE [dbo].[tbl_rec_TransactionACISummary]
(
[DateTimeSettlement] [datetime] NOT NULL,
[Currency] [smallint] NOT NULL,
[Service] [char] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[NodeID] [char] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[InstName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ACSSDebitCount] [int] NOT NULL,
[ACSSDebitAmount] [money] NOT NULL,
[ACSSCreditCount] [int] NOT NULL,
[ACSSCreditAmount] [money] NOT NULL,
[NetDepositAmount] [money] NOT NULL,
[SettlementRegion] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tbl_rec_TransactionACISummary] ADD CONSTRAINT [PK_tbl_rec_TransactionACISummary] PRIMARY KEY CLUSTERED  ([DateTimeSettlement], [Currency], [Service], [NodeID]) ON [PRIMARY]
GO
