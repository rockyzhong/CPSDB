CREATE TABLE [dbo].[tbl_CustomerLoyalty]
(
[Id] [bigint] NOT NULL IDENTITY(1, 2) NOT FOR REPLICATION,
[IsoId] [bigint] NOT NULL,
[CustomerId] [bigint] NOT NULL,
[Track1] [nvarchar] (79) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Track2] [nvarchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PIN] [varbinary] (1024) NULL,
[UpdatedUserId] [bigint] NULL,
[UpdateTime] [datetime] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tbl_CustomerLoyalty] ADD CONSTRAINT [pk_CustomerLoyalty] PRIMARY KEY NONCLUSTERED  ([Id]) ON [PRIMARY]
GO
