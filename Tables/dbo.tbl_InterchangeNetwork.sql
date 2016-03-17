CREATE TABLE [dbo].[tbl_InterchangeNetwork]
(
[Id] [bigint] NOT NULL IDENTITY(1, 2),
[NetworkCode] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NetworkDesc] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[GroupCode] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UpdatedUserId] [bigint] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tbl_InterchangeNetwork] ADD CONSTRAINT [pk_InterchangeNetwork] PRIMARY KEY NONCLUSTERED  ([Id]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_InterchangeNetwork_NetworkCode] ON [dbo].[tbl_InterchangeNetwork] ([NetworkCode]) ON [PRIMARY]
GO
