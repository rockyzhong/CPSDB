CREATE TABLE [dbo].[tbl_EmulationErrorDescription]
(
[Id] [bigint] NOT NULL IDENTITY(1, 2) NOT FOR REPLICATION,
[ErrorText] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ErrorDescription] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UpdatedUserId] [bigint] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tbl_EmulationErrorDescription] ADD CONSTRAINT [pk_EmulationErrorDescription] PRIMARY KEY NONCLUSTERED  ([Id]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [idx_EmulationErrorDescription_ErrorText] ON [dbo].[tbl_EmulationErrorDescription] ([ErrorText]) ON [PRIMARY]
GO
