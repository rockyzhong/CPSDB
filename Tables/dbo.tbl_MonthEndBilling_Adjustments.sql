CREATE TABLE [dbo].[tbl_MonthEndBilling_Adjustments]
(
[Id] [bigint] NOT NULL IDENTITY(1, 2) NOT FOR REPLICATION,
[AdjustmentID] [int] NOT NULL,
[ISOID] [int] NOT NULL,
[Amount] [money] NOT NULL,
[Taxable] [int] NOT NULL,
[AdjustmentDesc] [varchar] (80) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Status] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ProcessedDate] [datetime] NULL,
[UpdatedUserId] [bigint] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tbl_MonthEndBilling_Adjustments] ADD CONSTRAINT [pk_MonthEndBilling_Adjustments] PRIMARY KEY NONCLUSTERED  ([Id]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_MonthEndBilling_Adjustments_Status] ON [dbo].[tbl_MonthEndBilling_Adjustments] ([Status]) ON [PRIMARY]
GO
