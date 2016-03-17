CREATE TABLE [dbo].[tbl_trn_TransactionACHPayout]
(
[SettlementDate] [datetime] NOT NULL,
[ACHFileID] [int] NOT NULL,
[FileNo] [int] NOT NULL,
[BatchHeader] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[RTA] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[AccountType] [char] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[RefName] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[HolderName] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Amount] [money] NOT NULL,
[DueDate] [datetime] NOT NULL,
[StandardEntryCode] [char] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[UserID] [bigint] NULL,
[AddendaTypeCode] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AddendaInfo] [varchar] (80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Currency] [smallint] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tbl_trn_TransactionACHPayout] ADD CONSTRAINT [PK_tbl_trn_TransactionACHPayout] PRIMARY KEY CLUSTERED  ([SettlementDate], [ACHFileID], [FileNo], [BatchHeader], [RTA], [AccountType], [RefName]) ON [PRIMARY]
GO
