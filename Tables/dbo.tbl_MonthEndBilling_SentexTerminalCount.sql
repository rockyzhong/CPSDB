CREATE TABLE [dbo].[tbl_MonthEndBilling_SentexTerminalCount]
(
[Id] [bigint] NOT NULL IDENTITY(1, 2),
[ISOID] [int] NOT NULL,
[WiredCount] [int] NOT NULL,
[WirelessCount] [int] NOT NULL,
[UpdatedUserId] [bigint] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tbl_MonthEndBilling_SentexTerminalCount] ADD CONSTRAINT [pk_MonthEndBilling_SentexTerminalCount] PRIMARY KEY NONCLUSTERED  ([Id]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_MonthEndBilling_SentexTerminalCount_ISOID] ON [dbo].[tbl_MonthEndBilling_SentexTerminalCount] ([ISOID]) ON [PRIMARY]
GO
