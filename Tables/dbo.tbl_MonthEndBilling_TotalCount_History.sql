CREATE TABLE [dbo].[tbl_MonthEndBilling_TotalCount_History]
(
[Id] [bigint] NOT NULL IDENTITY(1, 2) NOT FOR REPLICATION,
[StartDate] [datetime] NOT NULL,
[EndDate] [datetime] NOT NULL,
[ISOID] [int] NOT NULL,
[TotalCount] [int] NOT NULL,
[UpdatedUserId] [bigint] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tbl_MonthEndBilling_TotalCount_History] ADD CONSTRAINT [pk_MonthEndBilling_TotalCount_History] PRIMARY KEY NONCLUSTERED  ([Id]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_MonthEndBilling_TotalCount_History_StartDate_EndDate_ISOID] ON [dbo].[tbl_MonthEndBilling_TotalCount_History] ([StartDate], [EndDate], [ISOID]) ON [PRIMARY]
GO
