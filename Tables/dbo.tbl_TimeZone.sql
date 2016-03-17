CREATE TABLE [dbo].[tbl_TimeZone]
(
[Id] [bigint] NOT NULL IDENTITY(1, 2) NOT FOR REPLICATION,
[TimeZoneName] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TimeZoneTime] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TimeZoneOffset] [bigint] NULL,
[DayLightSavingTime] [bit] NULL,
[UpdatedUserId] [bigint] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tbl_TimeZone] ADD CONSTRAINT [PK_tbl_TimeZone] PRIMARY KEY CLUSTERED  ([Id]) ON [PRIMARY]
GO
