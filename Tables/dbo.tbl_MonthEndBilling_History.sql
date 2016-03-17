CREATE TABLE [dbo].[tbl_MonthEndBilling_History]
(
[Id] [bigint] NOT NULL IDENTITY(1, 2) NOT FOR REPLICATION,
[EntryID] [int] NOT NULL,
[StartDate] [datetime] NOT NULL,
[EndDate] [datetime] NOT NULL,
[ISOID] [int] NOT NULL,
[EntryType] [int] NULL,
[ExpenseType] [int] NOT NULL,
[APIType] [int] NOT NULL,
[StatementOrder] [int] NOT NULL,
[StatementLabel1] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[StatementLabel2] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ItemCount] [int] NOT NULL,
[Rate] [money] NOT NULL,
[TotalAmount] [money] NULL,
[Taxable] [int] NULL,
[UpdatedUserId] [bigint] NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[tbl_MonthEndBilling_History_AfterInsert] ON [dbo].[tbl_MonthEndBilling_History]
   WITH EXECUTE AS 'dbo'
   AFTER INSERT
AS 
BEGIN
  SET NOCOUNT ON
  UPDATE dbo.tbl_MonthEndBilling_History SET TotalAmount=ItemCount*Rate WHERE Id IN (SELECT Id FROM inserted) AND TotalAmount IS NULL
END
GO
ALTER TABLE [dbo].[tbl_MonthEndBilling_History] ADD CONSTRAINT [pk_MonthEndBilling_History] PRIMARY KEY NONCLUSTERED  ([Id]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_MonthEndBilling_History_StartDate_EndDate_ISOID] ON [dbo].[tbl_MonthEndBilling_History] ([StartDate], [EndDate], [ISOID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
