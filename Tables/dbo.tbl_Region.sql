CREATE TABLE [dbo].[tbl_Region]
(
[Id] [bigint] NOT NULL IDENTITY(1, 2) NOT FOR REPLICATION,
[CountryId] [bigint] NOT NULL,
[RegionFullName] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[RegionShortName] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UpdatedUserId] [bigint] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tbl_Region] ADD CONSTRAINT [PK_Region] PRIMARY KEY CLUSTERED  ([Id]) WITH (FILLFACTOR=80, PAD_INDEX=ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_Region_CountryId] ON [dbo].[tbl_Region] ([CountryId]) ON [PRIMARY]
GO
