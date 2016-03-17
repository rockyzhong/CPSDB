CREATE TABLE [dbo].[tbl_Parameter]
(
[Id] [bigint] NOT NULL IDENTITY(1, 2) NOT FOR REPLICATION,
[Name] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Value] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Description] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UpdatedUserId] [bigint] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tbl_Parameter] ADD CONSTRAINT [pk_Parameter] PRIMARY KEY NONCLUSTERED  ([Id]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_Parameter_Name] ON [dbo].[tbl_Parameter] ([Name]) ON [PRIMARY]
GO
