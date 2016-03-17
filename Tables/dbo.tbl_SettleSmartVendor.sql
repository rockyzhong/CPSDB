CREATE TABLE [dbo].[tbl_SettleSmartVendor]
(
[Id] [bigint] NOT NULL IDENTITY(1, 2) NOT FOR REPLICATION,
[SmartABA] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SmartBankName] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SmartCity] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SmartAccountNumber] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UpdatedUserId] [bigint] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tbl_SettleSmartVendor] ADD CONSTRAINT [PK_tbl_SettlementSmartVendor] PRIMARY KEY CLUSTERED  ([Id]) ON [PRIMARY]
GO
