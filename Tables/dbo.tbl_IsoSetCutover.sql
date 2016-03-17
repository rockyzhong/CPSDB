CREATE TABLE [dbo].[tbl_IsoSetCutover]
(
[Id] [bigint] NOT NULL IDENTITY(1, 2) NOT FOR REPLICATION,
[IsoId] [bigint] NOT NULL,
[CutoverTime] [nvarchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tbl_IsoSetCutover] ADD CONSTRAINT [pk_IsoSetCutover] PRIMARY KEY NONCLUSTERED  ([Id]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_IsoSetCutover_IsoId] ON [dbo].[tbl_IsoSetCutover] ([IsoId]) ON [PRIMARY]
GO
