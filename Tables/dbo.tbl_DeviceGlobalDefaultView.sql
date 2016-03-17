CREATE TABLE [dbo].[tbl_DeviceGlobalDefaultView]
(
[Id] [bigint] NOT NULL IDENTITY(1, 2) NOT FOR REPLICATION,
[ViewId] [bigint] NOT NULL,
[UpdateUserId] [bigint] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tbl_DeviceGlobalDefaultView] ADD CONSTRAINT [pk_DeviceGlobalDefaultView] PRIMARY KEY NONCLUSTERED  ([Id]) ON [PRIMARY]
GO
