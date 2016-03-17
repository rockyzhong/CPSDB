CREATE TABLE [dbo].[tbl_MonthEndBilling_TerminalList]
(
[Id] [bigint] NOT NULL IDENTITY(1, 2) NOT FOR REPLICATION,
[StartDate] [datetime] NOT NULL,
[EndDate] [datetime] NOT NULL,
[ISOID] [int] NOT NULL,
[TerminalID] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[UpdatedUserId] [bigint] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tbl_MonthEndBilling_TerminalList] ADD CONSTRAINT [pk_MonthEndBilling_TerminalList] PRIMARY KEY NONCLUSTERED  ([Id]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_MonthEndBilling_TerminalList_StartDate_EndDate_ISOID] ON [dbo].[tbl_MonthEndBilling_TerminalList] ([StartDate], [EndDate], [ISOID]) WITH (FILLFACTOR=80, PAD_INDEX=ON) ON [PRIMARY]
GO
