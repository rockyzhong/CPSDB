CREATE TABLE [dbo].[tbl_DeviceIPAddressFlags]
(
[Id] [bigint] NOT NULL IDENTITY(1, 2) NOT FOR REPLICATION,
[IPAddressFlagId] [bigint] NOT NULL,
[IPAddressFlagDesc] [nvarchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DisplayType] [nvarchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UpdatedUserId] [bigint] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tbl_DeviceIPAddressFlags] ADD CONSTRAINT [pk_DeviceIPAddressFlags] PRIMARY KEY NONCLUSTERED  ([Id]) ON [PRIMARY]
GO
