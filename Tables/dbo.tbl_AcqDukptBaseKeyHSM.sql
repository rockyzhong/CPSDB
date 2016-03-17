CREATE TABLE [dbo].[tbl_AcqDukptBaseKeyHSM]
(
[Id] [bigint] NOT NULL IDENTITY(1, 2) NOT FOR REPLICATION,
[MasterKeyId] [bigint] NOT NULL,
[SchemaId] [bigint] NOT NULL,
[Cryptogram] [nvarchar] (80) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CheckDigits] [nvarchar] (16) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AssignedDate] [datetime] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tbl_AcqDukptBaseKeyHSM] ADD CONSTRAINT [pk_AcqDukptBaseKeyHSM] PRIMARY KEY CLUSTERED  ([Id]) WITH (FILLFACTOR=80, PAD_INDEX=ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_AcqDukptBaseKeyHSM_MasterKeyId] ON [dbo].[tbl_AcqDukptBaseKeyHSM] ([MasterKeyId]) ON [PRIMARY]
GO
