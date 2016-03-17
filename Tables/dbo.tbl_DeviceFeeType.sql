CREATE TABLE [dbo].[tbl_DeviceFeeType]
(
[Id] [bigint] NOT NULL IDENTITY(1, 2) NOT FOR REPLICATION,
[FeeType] [bigint] NOT NULL,
[TransactionType] [bigint] NOT NULL,
[DebitCredit] [bigint] NOT NULL,
[UpdatedUserId] [bigint] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tbl_DeviceFeeType] ADD CONSTRAINT [pk_DeviceFeeType] PRIMARY KEY NONCLUSTERED  ([Id]) ON [PRIMARY]
GO
