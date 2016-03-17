CREATE TABLE [dbo].[tbl_upm_UserPasswordHistory]
(
[Id] [bigint] NOT NULL IDENTITY(1, 2) NOT FOR REPLICATION,
[UserId] [bigint] NOT NULL,
[Password] [varchar] (512) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[UpdatedUserId] [bigint] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tbl_upm_UserPasswordHistory] ADD CONSTRAINT [pk_UserPasswordHistory] PRIMARY KEY CLUSTERED  ([Id]) WITH (FILLFACTOR=80, PAD_INDEX=ON) ON [PRIMARY]
GO
