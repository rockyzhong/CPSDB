CREATE TABLE [dbo].[tbl_rec_TransactionCheckFile]
(
[Id] [bigint] NOT NULL IDENTITY(1, 2) NOT FOR REPLICATION,
[SettlementDate] [datetime] NOT NULL,
[FileDate] [datetime] NOT NULL,
[MerchantId] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[UploadFileName] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ResponseFileName] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tbl_rec_TransactionCheckFile] ADD CONSTRAINT [pk_TransactionCheckFile] PRIMARY KEY NONCLUSTERED  ([Id]) ON [PRIMARY]
GO
