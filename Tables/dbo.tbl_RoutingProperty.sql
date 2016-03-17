CREATE TABLE [dbo].[tbl_RoutingProperty]
(
[Id] [bigint] NOT NULL IDENTITY(1, 2) NOT FOR REPLICATION,
[CountryCode] [bigint] NOT NULL,
[RoutingCode] [bigint] NOT NULL,
[RoutingProperty] [bigint] NOT NULL,
[Issuers] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Description] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[UpdatedUserId] [bigint] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tbl_RoutingProperty] ADD CONSTRAINT [pk_RoutingProperty] PRIMARY KEY NONCLUSTERED  ([Id]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_RoutingProperty_CountryCode] ON [dbo].[tbl_RoutingProperty] ([CountryCode]) ON [PRIMARY]
GO
