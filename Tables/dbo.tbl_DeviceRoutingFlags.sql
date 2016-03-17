CREATE TABLE [dbo].[tbl_DeviceRoutingFlags]
(
[Id] [bigint] NOT NULL,
[Name] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Description] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CountryCode] [bigint] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tbl_DeviceRoutingFlags] ADD CONSTRAINT [pk_DeviceRoutingFlags] PRIMARY KEY NONCLUSTERED  ([Id]) ON [PRIMARY]
GO
