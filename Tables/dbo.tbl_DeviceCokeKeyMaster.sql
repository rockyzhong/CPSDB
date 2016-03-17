CREATE TABLE [dbo].[tbl_DeviceCokeKeyMaster]
(
[Id] [nvarchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Variant] [tinyint] NULL,
[CurrKey] [nvarchar] (76) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UpatedDate] [bigint] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tbl_DeviceCokeKeyMaster] ADD CONSTRAINT [PK_AKBMKEYS] PRIMARY KEY CLUSTERED  ([Id]) ON [PRIMARY]
GO
