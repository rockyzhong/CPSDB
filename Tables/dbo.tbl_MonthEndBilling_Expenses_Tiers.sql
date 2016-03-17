CREATE TABLE [dbo].[tbl_MonthEndBilling_Expenses_Tiers]
(
[Id] [bigint] NOT NULL IDENTITY(1, 2) NOT FOR REPLICATION,
[ISOID] [int] NOT NULL,
[MinTransactions] [int] NOT NULL,
[MaxTransactions] [int] NOT NULL,
[ExpenseType] [int] NOT NULL,
[TranType] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ApprDeclCode] [int] NOT NULL,
[NetworkCode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[StatementOrder] [int] NOT NULL,
[StatementLabel1] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[StatementLabel2] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CurrencyCode] [int] NOT NULL,
[ExpenseAmount] [money] NOT NULL,
[Taxable] [int] NOT NULL,
[UpdatedUserId] [bigint] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tbl_MonthEndBilling_Expenses_Tiers] ADD CONSTRAINT [pk_MonthEndBilling_Expenses_Tiers] PRIMARY KEY NONCLUSTERED  ([Id]) WITH (FILLFACTOR=80, PAD_INDEX=ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_MonthEndBilling_Expenses_Tiers_ISOID_ExpenseType] ON [dbo].[tbl_MonthEndBilling_Expenses_Tiers] ([ISOID], [MinTransactions]) WITH (FILLFACTOR=80, PAD_INDEX=ON) ON [PRIMARY]
GO
