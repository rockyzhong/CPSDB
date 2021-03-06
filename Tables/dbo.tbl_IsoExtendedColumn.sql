CREATE TABLE [dbo].[tbl_IsoExtendedColumn]
(
[Id] [bigint] NOT NULL IDENTITY(1, 2) NOT FOR REPLICATION,
[ExtendedColumnType] [bigint] NULL,
[ExtendedColumnLabel] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ExtendedColumnDescription] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UpdatedUserId] [bigint] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tbl_IsoExtendedColumn] ADD CONSTRAINT [pk_IsoExtendedColumn] PRIMARY KEY NONCLUSTERED  ([Id]) ON [PRIMARY]
GO
