CREATE TABLE [dbo].[tbl_NetworkResponseCodeExternal]
(
[Id] [bigint] NOT NULL IDENTITY(1, 2) NOT FOR REPLICATION,
[NetworkId] [bigint] NOT NULL,
[ResponseCodeExternal] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Description] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UpdatedUserId] [bigint] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tbl_NetworkResponseCodeExternal] ADD CONSTRAINT [pk_NetworkResponseCodeExternal] PRIMARY KEY CLUSTERED  ([Id]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_NetworkId_ResponseCodeExternal] ON [dbo].[tbl_NetworkResponseCodeExternal] ([NetworkId], [ResponseCodeExternal]) ON [PRIMARY]
GO
