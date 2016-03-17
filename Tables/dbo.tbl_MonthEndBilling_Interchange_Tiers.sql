CREATE TABLE [dbo].[tbl_MonthEndBilling_Interchange_Tiers]
(
[Id] [bigint] NOT NULL IDENTITY(1, 2) NOT FOR REPLICATION,
[ISOID] [int] NOT NULL,
[MinTransactions] [int] NOT NULL,
[MaxTransactions] [int] NOT NULL,
[TranType] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ApprDeclCode] [int] NOT NULL,
[NetworkCode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[StatementOrder] [int] NOT NULL,
[StatementLabel] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CurrencyCode] [int] NOT NULL,
[InterchangeAmount] [money] NOT NULL,
[UpdatedUserId] [bigint] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tbl_MonthEndBilling_Interchange_Tiers] ADD CONSTRAINT [pk_MonthEndBilling_Interchange_Tiers] PRIMARY KEY NONCLUSTERED  ([Id]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_MonthEndBilling_Interchange_Tiers_ISOID_NetworkCode_TranType] ON [dbo].[tbl_MonthEndBilling_Interchange_Tiers] ([ISOID], [NetworkCode], [TranType]) WITH (FILLFACTOR=80, PAD_INDEX=ON) ON [PRIMARY]
GO
