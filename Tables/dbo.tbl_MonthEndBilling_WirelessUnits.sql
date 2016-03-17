CREATE TABLE [dbo].[tbl_MonthEndBilling_WirelessUnits]
(
[Id] [bigint] NOT NULL IDENTITY(1, 2) NOT FOR REPLICATION,
[ISOID] [int] NOT NULL,
[WirelessUnitCount] [int] NOT NULL,
[UpdatedUserId] [bigint] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tbl_MonthEndBilling_WirelessUnits] ADD CONSTRAINT [pk_MonthEndBilling_WirelessUnits] PRIMARY KEY NONCLUSTERED  ([Id]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_MonthEndBilling_WirelessUnits_ISOID] ON [dbo].[tbl_MonthEndBilling_WirelessUnits] ([ISOID]) ON [PRIMARY]
GO
