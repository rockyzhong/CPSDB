CREATE TABLE [dbo].[tbl_DeviceStatusIcons]
(
[Id] [bigint] NOT NULL IDENTITY(1, 2) NOT FOR REPLICATION,
[StatusType] [char] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[StatusText] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[StatusIcon] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[UpdatedUserId] [bigint] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tbl_DeviceStatusIcons] ADD CONSTRAINT [pk_DeviceStatusIcons] PRIMARY KEY CLUSTERED  ([Id]) ON [PRIMARY]
GO
