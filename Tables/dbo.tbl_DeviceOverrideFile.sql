CREATE TABLE [dbo].[tbl_DeviceOverrideFile]
(
[Id] [bigint] NOT NULL IDENTITY(1, 2) NOT FOR REPLICATION,
[OverrideFileName] [nvarchar] (60) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[OverrideFileDesc] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[UpdatedUserId] [bigint] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tbl_DeviceOverrideFile] ADD CONSTRAINT [pk_DeviceOverrideFile] PRIMARY KEY NONCLUSTERED  ([Id]) ON [PRIMARY]
GO
