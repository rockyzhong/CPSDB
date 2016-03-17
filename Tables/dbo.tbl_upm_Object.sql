CREATE TABLE [dbo].[tbl_upm_Object]
(
[Id] [bigint] NOT NULL IDENTITY(1, 2) NOT FOR REPLICATION,
[SourceId] [bigint] NOT NULL,
[SourceType] [bigint] NOT NULL,
[CreatedUserId] [bigint] NOT NULL,
[UpdatedUserId] [bigint] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tbl_upm_Object] ADD CONSTRAINT [pk_Object] PRIMARY KEY CLUSTERED  ([Id]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_Object_CreatedUserId] ON [dbo].[tbl_upm_Object] ([CreatedUserId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_Object_SourceType] ON [dbo].[tbl_upm_Object] ([SourceType]) ON [PRIMARY]
GO
