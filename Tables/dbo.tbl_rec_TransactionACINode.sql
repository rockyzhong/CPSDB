CREATE TABLE [dbo].[tbl_rec_TransactionACINode]
(
[NodeID] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[NodeType] [char] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[FIIDDesc] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tbl_rec_TransactionACINode] ADD CONSTRAINT [PK_tbl_rec_TransactionACINode] PRIMARY KEY CLUSTERED  ([NodeID]) ON [PRIMARY]
GO
