CREATE TABLE [dbo].[tbl_ResponseType]
(
[Id] [bigint] NOT NULL,
[Description] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[UpdatedUserId] [bigint] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tbl_ResponseType] ADD CONSTRAINT [pk_ResponseType] PRIMARY KEY CLUSTERED  ([Id]) ON [PRIMARY]
GO
