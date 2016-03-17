CREATE TABLE [dbo].[tbl_SCConnCageError]
(
[Id] [bigint] NOT NULL IDENTITY(1, 2) NOT FOR REPLICATION,
[SCip] [nvarchar] (16) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Cageserver] [nvarchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Isoid] [bigint] NOT NULL,
[Deviceid] [bigint] NOT NULL,
[Message] [nvarchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[TransFail] [bit] NOT NULL,
[CreatedDate] [datetime] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tbl_SCConnCageError] ADD CONSTRAINT [pk_SCConnCageError] PRIMARY KEY NONCLUSTERED  ([Id]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_SCConnCageError_CreatedDate] ON [dbo].[tbl_SCConnCageError] ([CreatedDate]) ON [PRIMARY]
GO
