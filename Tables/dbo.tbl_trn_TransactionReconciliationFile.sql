CREATE TABLE [dbo].[tbl_trn_TransactionReconciliationFile]
(
[Id] [bigint] NOT NULL IDENTITY(1, 2) NOT FOR REPLICATION,
[FileName] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tbl_trn_TransactionReconciliationFile] ADD CONSTRAINT [pk_TransactionReconciliationFile] PRIMARY KEY NONCLUSTERED  ([Id]) ON [PRIMARY]
GO
