CREATE TABLE [dbo].[tbl_DeviceCokeKeyWorking]
(
[Id] [nvarchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CurrKey] [nvarchar] (76) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PrevKey] [nvarchar] (76) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CountUsed] [smallint] NULL,
[UpatedDate] [bigint] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tbl_DeviceCokeKeyWorking] ADD CONSTRAINT [PK_AKBWKEYS] PRIMARY KEY CLUSTERED  ([Id]) ON [PRIMARY]
GO
