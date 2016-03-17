CREATE TABLE [dbo].[tbl_Module]
(
[Id] [bigint] NOT NULL IDENTITY(1, 2) NOT FOR REPLICATION,
[ModuleName] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SortOrder] [bigint] NULL,
[UpdatedUserId] [bigint] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tbl_Module] ADD CONSTRAINT [pk_Module] PRIMARY KEY NONCLUSTERED  ([Id]) ON [PRIMARY]
GO
