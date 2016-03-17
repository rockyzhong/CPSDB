CREATE TABLE [dbo].[tbl_DeviceDefaultView]
(
[Id] [bigint] NOT NULL IDENTITY(1, 2) NOT FOR REPLICATION,
[UserId] [bigint] NOT NULL,
[ViewId] [bigint] NOT NULL,
[UpdateUserId] [bigint] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tbl_DeviceDefaultView] ADD CONSTRAINT [pk_DeviceDefaultView] PRIMARY KEY NONCLUSTERED  ([Id]) ON [PRIMARY]
GO
