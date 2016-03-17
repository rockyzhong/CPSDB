CREATE TABLE [dbo].[tbl_Report_Format]
(
[Id] [int] NOT NULL IDENTITY(1, 2) NOT FOR REPLICATION,
[Name] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[UpdatedUserId] [bigint] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tbl_Report_Format] ADD CONSTRAINT [PK_tbl_Report_Format] PRIMARY KEY CLUSTERED  ([Id]) ON [PRIMARY]
GO
