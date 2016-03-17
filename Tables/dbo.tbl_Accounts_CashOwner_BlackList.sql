CREATE TABLE [dbo].[tbl_Accounts_CashOwner_BlackList]
(
[Id] [bigint] NOT NULL IDENTITY(1, 2) NOT FOR REPLICATION,
[CashOwnerName] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CashOwnerDocTypeId] [bigint] NULL,
[DocumentNumber] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tbl_Accounts_CashOwner_BlackList] ADD CONSTRAINT [PK_Accounts_CashOwner_BlackList] PRIMARY KEY NONCLUSTERED  ([Id]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_Accounts_CashOwner_BlackList_DocTypeId_DocNumber] ON [dbo].[tbl_Accounts_CashOwner_BlackList] ([CashOwnerDocTypeId], [DocumentNumber]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_Accounts_CashOwner_BlackList_CashOwnerName] ON [dbo].[tbl_Accounts_CashOwner_BlackList] ([CashOwnerName]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
