CREATE TABLE [dbo].[tbl_MonthEndBilling_MCITransactionFees]
(
[Id] [bigint] NOT NULL IDENTITY(1, 2) NOT FOR REPLICATION,
[StartDate] [datetime] NOT NULL,
[EndDate] [datetime] NOT NULL,
[DeviceId] [bigint] NOT NULL,
[MCITransCount] [bigint] NULL,
[MCISettlementAmt] [money] NULL,
[MCISurchargeAmt] [money] NULL,
[MCITotalAmt] [money] NULL,
[MCIPct] [money] NULL,
[MCIFee] [money] NULL,
[UpdatedUserId] [bigint] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tbl_MonthEndBilling_MCITransactionFees] ADD CONSTRAINT [pk_MonthEndBilling_MCITransactionFees] PRIMARY KEY NONCLUSTERED  ([Id]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_MonthEndBilling_MCITransactionFees_StartDate_EndDate] ON [dbo].[tbl_MonthEndBilling_MCITransactionFees] ([StartDate], [EndDate]) ON [PRIMARY]
GO
