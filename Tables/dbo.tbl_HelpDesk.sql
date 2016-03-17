CREATE TABLE [dbo].[tbl_HelpDesk]
(
[Id] [bigint] NOT NULL IDENTITY(1, 2) NOT FOR REPLICATION,
[ContactName] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[PhoneNumber] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[PermissionId] [bigint] NULL,
[UpdatedDate] [datetime] NULL,
[UpdatedUserId] [bigint] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tbl_HelpDesk] ADD CONSTRAINT [pk_HelpDesk] PRIMARY KEY CLUSTERED  ([Id]) ON [PRIMARY]
GO
