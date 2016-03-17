CREATE TABLE [dbo].[tbl_trn_TransactionCoke]
(
[MERCID] [char] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[TERMID] [char] (16) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[BATCHNO] [int] NULL,
[BATCHPRDT] [char] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[BATCHSRC] [nvarchar] (13) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[BATCHSEQ] [bigint] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[TRANTYPE] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TRANAMT] [char] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TRANSEQ] [char] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TRANDT] [char] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TRANTM] [char] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TRANRC] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TRANAUTH] [char] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TRANVOID] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EDCCHAIN] [char] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SETTLDT] [char] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TIMESTAMP] [char] (14) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PAN] [nvarchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ENTRYMODE] [char] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SYSNAME] [nvarchar] (9) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CREATED] [int] NULL,
[CREATEID] [char] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CARDTYPE] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SRVRNAME] [char] (9) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MERCCURR] [char] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CUSTOMER] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ORGTRACE] [char] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SALESORG] [nvarchar] (31) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MERCNAME] [nvarchar] (26) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MODIFYDATE] [int] NULL,
[MODIFYID] [char] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tbl_trn_TransactionCoke] ADD CONSTRAINT [PK_ICHBATCH] PRIMARY KEY CLUSTERED  ([BATCHSEQ]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_TransactionCoke_MerTerm] ON [dbo].[tbl_trn_TransactionCoke] ([MERCID], [TERMID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [idx_TransactionCoke_MerTermTranSeq] ON [dbo].[tbl_trn_TransactionCoke] ([MERCID], [TERMID], [TRANSEQ]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_TransactionCoke_MerTermTranSeqAuthType] ON [dbo].[tbl_trn_TransactionCoke] ([MERCID], [TERMID], [TRANSEQ], [TRANAUTH], [TRANTYPE]) ON [PRIMARY]
GO
