CREATE TABLE [dbo].[tbl_RegionTax]
(
[Id] [bigint] NOT NULL IDENTITY(1, 2) NOT FOR REPLICATION,
[RegionId] [bigint] NOT NULL,
[TaxName] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[TaxPercent] [money] NOT NULL,
[RefNumber] [nvarchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UpdatedUserId] [bigint] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tbl_RegionTax] ADD CONSTRAINT [PK_RegionTax] PRIMARY KEY CLUSTERED  ([Id]) ON [PRIMARY]
GO
