CREATE TABLE [dbo].[tbl_MonthEndBilling_BalancingEntries]
(
[Id] [bigint] NOT NULL IDENTITY(1, 2) NOT FOR REPLICATION,
[StartDate] [datetime] NOT NULL,
[EndDate] [datetime] NOT NULL,
[ISOID] [int] NOT NULL,
[TotalInterchangePayable] [money] NOT NULL,
[TotalExpensesChargeable] [money] NOT NULL,
[NetRevenueToISO] [money] NOT NULL,
[TaxRegionID] [int] NOT NULL,
[TaxName] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[TaxPct] [money] NOT NULL,
[TaxAmount] [money] NOT NULL,
[NetRevenueAfterTax] [money] NOT NULL,
[AmountPaidDaily] [money] NOT NULL,
[BalanceToISO] [money] NOT NULL,
[UpdatedUserId] [bigint] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tbl_MonthEndBilling_BalancingEntries] ADD CONSTRAINT [pk_MonthEndBilling_BalancingEntries] PRIMARY KEY NONCLUSTERED  ([Id]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_MonthEndBilling_BalancingEntries_StartDate_EndDate_ISOID] ON [dbo].[tbl_MonthEndBilling_BalancingEntries] ([StartDate], [EndDate], [ISOID]) ON [PRIMARY]
GO
