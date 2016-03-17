CREATE TABLE [dbo].[tbl_EJHistory]
(
[Id] [bigint] NOT NULL IDENTITY(1, 2) NOT FOR REPLICATION,
[DeviceId] [bigint] NULL,
[FileDate] [datetime] NOT NULL,
[FileType] [bigint] NULL,
[FileData] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UpdatedUserId] [bigint] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[tbl_EJHistory] ADD CONSTRAINT [pk_EJHistory] PRIMARY KEY NONCLUSTERED  ([Id]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_EJHistory_DeviceId_FileDate_FileType] ON [dbo].[tbl_EJHistory] ([DeviceId], [FileDate], [FileType]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'1 - Char  2 - Base 64', 'SCHEMA', N'dbo', 'TABLE', N'tbl_EJHistory', 'COLUMN', N'FileType'
GO
