CREATE TABLE [dbo].[tbl_DeviceModelFeatureFlags]
(
[Id] [bigint] NOT NULL IDENTITY(1, 2) NOT FOR REPLICATION,
[FeatureId] [bigint] NOT NULL,
[FeatureDesc] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[UpdatedUserId] [bigint] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tbl_DeviceModelFeatureFlags] ADD CONSTRAINT [pk_DeviceModelFeatureFlags] PRIMARY KEY NONCLUSTERED  ([Id]) ON [PRIMARY]
GO
