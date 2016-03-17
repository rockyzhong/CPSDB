CREATE TABLE [dbo].[tbl_MenuItem]
(
[Id] [bigint] NOT NULL IDENTITY(1, 2) NOT FOR REPLICATION,
[PermissionId] [bigint] NOT NULL,
[ModuleId] [bigint] NOT NULL,
[MenuItemName] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[MenuItemNav] [nvarchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SortOrder] [bigint] NOT NULL,
[UpdatedUserId] [bigint] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tbl_MenuItem] ADD CONSTRAINT [pk_MeniItem] PRIMARY KEY CLUSTERED  ([Id]) WITH (FILLFACTOR=80, PAD_INDEX=ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_MenuItem_ModuleId] ON [dbo].[tbl_MenuItem] ([ModuleId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_MenuItem_PermissionId] ON [dbo].[tbl_MenuItem] ([PermissionId]) ON [PRIMARY]
GO
