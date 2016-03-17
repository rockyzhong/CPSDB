CREATE TABLE [dbo].[tbl_BINGroupProperty]
(
[Id] [bigint] NOT NULL IDENTITY(1, 2) NOT FOR REPLICATION,
[CountryCode] [bigint] NOT NULL,
[BINGroup] [bigint] NOT NULL,
[BINGroupProperty] [bigint] NOT NULL,
[Issuers] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Description] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[UpdatedUserId] [bigint] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tbl_BINGroupProperty] ADD CONSTRAINT [pk_BINGroupProperty] PRIMARY KEY NONCLUSTERED  ([Id]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_BINGroupProperty_CountryCode] ON [dbo].[tbl_BINGroupProperty] ([CountryCode]) ON [PRIMARY]
GO
