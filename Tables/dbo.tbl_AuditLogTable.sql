CREATE TABLE [dbo].[tbl_AuditLogTable]
(
[Id] [bigint] NOT NULL IDENTITY(1, 2) NOT FOR REPLICATION,
[SourceType] [bigint] NULL,
[TableName] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UpdatedUserId] [bigint] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tbl_AuditLogTable] ADD CONSTRAINT [pk_AuditTable] PRIMARY KEY NONCLUSTERED  ([Id]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_AuditLogTable_TableName] ON [dbo].[tbl_AuditLogTable] ([TableName]) ON [PRIMARY]
GO
