CREATE TABLE [dbo].[tbl_TypeValue]
(
[Id] [bigint] NOT NULL IDENTITY(1, 2) NOT FOR REPLICATION,
[TypeId] [bigint] NULL,
[Name] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Value] [bigint] NULL,
[Description] [nvarchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UpdatedUserId] [bigint] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tbl_TypeValue] ADD CONSTRAINT [pk_TypeValue] PRIMARY KEY NONCLUSTERED  ([Id]) WITH (FILLFACTOR=80, PAD_INDEX=ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_TypeValue_TypeId_Name] ON [dbo].[tbl_TypeValue] ([TypeId], [Name]) WITH (FILLFACTOR=80, PAD_INDEX=ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_TypeValue_TypeId_Value] ON [dbo].[tbl_TypeValue] ([TypeId], [Value]) WITH (FILLFACTOR=80, PAD_INDEX=ON) ON [PRIMARY]
GO
