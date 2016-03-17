CREATE TABLE [dbo].[tbl_DeviceFilter]
(
[Id] [bigint] NOT NULL IDENTITY(1, 2) NOT FOR REPLICATION,
[ColumnId] [bigint] NOT NULL,
[FilterName] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Description] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FilterQuery] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ParameterName] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DataField] [bigint] NOT NULL CONSTRAINT [DF_DeviceFilter_DataField] DEFAULT ((0)),
[DataFormat] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_DeviceFilter_DataFormat] DEFAULT ('{0}'),
[Regex] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Rank] [bigint] NOT NULL,
[FilterType] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_DeviceFilter_FilterType] DEFAULT ('TEXT'),
[FilterStatus] [bigint] NOT NULL CONSTRAINT [DF_DeviceFilter_Status] DEFAULT ((1)),
[PermissionId] [bigint] NOT NULL,
[UpdatedUserId] [bigint] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tbl_DeviceFilter] ADD CONSTRAINT [pk_DeviceFilter] PRIMARY KEY NONCLUSTERED  ([Id]) ON [PRIMARY]
GO
