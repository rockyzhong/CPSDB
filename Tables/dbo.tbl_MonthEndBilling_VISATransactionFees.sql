CREATE TABLE [dbo].[tbl_MonthEndBilling_VISATransactionFees]
(
[Id] [bigint] NOT NULL IDENTITY(1, 2) NOT FOR REPLICATION,
[StartDate] [datetime] NOT NULL,
[EndDate] [datetime] NOT NULL,
[DeviceId] [bigint] NOT NULL,
[VISATransCount] [bigint] NULL,
[VISASettlementAmt] [money] NULL,
[VISASurchargeAmt] [money] NULL,
[VISATotalAmt] [money] NULL,
[VISAPct] [money] NULL,
[VISAFee] [money] NULL,
[UpdatedUserId] [bigint] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tbl_MonthEndBilling_VISATransactionFees] ADD CONSTRAINT [pk_MonthEndBilling_VISATransactionFees] PRIMARY KEY NONCLUSTERED  ([Id]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_MonthEndBilling_VISATransactionFees_StartDate_EndDate] ON [dbo].[tbl_MonthEndBilling_VISATransactionFees] ([StartDate], [EndDate]) ON [PRIMARY]
GO
