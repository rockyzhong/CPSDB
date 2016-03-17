CREATE TABLE [dbo].[tbl_DeviceModel]
(
[Id] [bigint] NOT NULL IDENTITY(1, 2) NOT FOR REPLICATION,
[Make] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Model] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[FeatureFlags] [bigint] NOT NULL,
[DeviceEmulation] [bigint] NOT NULL,
[LoadAsEmulation] [bigint] NOT NULL,
[MaxBillsPerCassette] [bigint] NOT NULL,
[MaxBillsPerDispense] [bigint] NOT NULL,
[UpdatedUserId] [bigint] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tbl_DeviceModel] ADD CONSTRAINT [pk_DeviceModel] PRIMARY KEY NONCLUSTERED  ([Id]) ON [PRIMARY]
GO
