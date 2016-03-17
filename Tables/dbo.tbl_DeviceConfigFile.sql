CREATE TABLE [dbo].[tbl_DeviceConfigFile]
(
[Id] [bigint] NOT NULL IDENTITY(1, 2) NOT FOR REPLICATION,
[ConfigDesc] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[DeviceEmulation] [bigint] NOT NULL,
[ScreenFileName] [nvarchar] (60) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ConfigValueFileName] [nvarchar] (60) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[StateFileName] [nvarchar] (60) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[UpdatedUserId] [bigint] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tbl_DeviceConfigFile] ADD CONSTRAINT [pk_DeviceConfigFile] PRIMARY KEY NONCLUSTERED  ([Id]) ON [PRIMARY]
GO
