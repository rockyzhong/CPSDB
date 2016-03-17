CREATE TABLE [dbo].[tbl_upm_NewUserImport]
(
[Id] [bigint] NOT NULL IDENTITY(1, 2) NOT FOR REPLICATION,
[UserType] [bigint] NOT NULL,
[FirstName] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[LastName] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[MiddleInitial] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UserName] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tbl_upm_NewUserImport] ADD CONSTRAINT [pk_NewUserImport] PRIMARY KEY CLUSTERED  ([Id]) ON [PRIMARY]
GO
