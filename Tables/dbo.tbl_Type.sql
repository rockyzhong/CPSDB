CREATE TABLE [dbo].[tbl_Type]
(
[id] [bigint] NOT NULL IDENTITY(1, 2) NOT FOR REPLICATION,
[Name] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Description] [nvarchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UpdatedUserId] [bigint] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tbl_Type] ADD CONSTRAINT [pk_Type] PRIMARY KEY NONCLUSTERED  ([id]) ON [PRIMARY]
GO
