CREATE TABLE [dbo].[tbl_ErrorLog]
(
[Id] [bigint] NOT NULL IDENTITY(1, 2) NOT FOR REPLICATION,
[Source] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Type] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Message] [nvarchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Trace] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreatedDate] [datetime] NOT NULL,
[UpdatedUserId] [bigint] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[tbl_ErrorLog] ADD CONSTRAINT [pk_ErrorLog] PRIMARY KEY NONCLUSTERED  ([Id]) WITH (FILLFACTOR=80, PAD_INDEX=ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_ErrorLog_CreatedDate] ON [dbo].[tbl_ErrorLog] ([CreatedDate]) WITH (FILLFACTOR=80, PAD_INDEX=ON) ON [PRIMARY]
GO
