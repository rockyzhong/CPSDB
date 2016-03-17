CREATE TABLE [dbo].[tbl_upm_Question]
(
[Id] [bigint] NOT NULL IDENTITY(1, 2) NOT FOR REPLICATION,
[Question] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UpdatedUserId] [bigint] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tbl_upm_Question] ADD CONSTRAINT [pk_Question] PRIMARY KEY CLUSTERED  ([Id]) ON [PRIMARY]
GO
