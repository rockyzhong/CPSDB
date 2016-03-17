CREATE TABLE [dbo].[tbl_NetworkMerchantTeleCheck]
(
[Id] [bigint] NOT NULL IDENTITY(1, 2) NOT FOR REPLICATION,
[NetworkMerchantId] [bigint] NOT NULL,
[MerchantIdNo1] [nvarchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[MerchantIdNo2] [nvarchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[MerchantIdNo3] [nvarchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CheckType] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CheckLimit] [bigint] NULL,
[DisplayTransHist] [bit] NOT NULL,
[TransHistDays] [bigint] NOT NULL,
[KioskEnabled] [bit] NULL,
[UpdateDate] [datetime] NULL,
[UpdateUserId] [bigint] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tbl_NetworkMerchantTeleCheck] ADD CONSTRAINT [pk_NetworkMerchantTeleCheck] PRIMARY KEY CLUSTERED  ([Id]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_etworkMerchantTeleCheck_NMId] ON [dbo].[tbl_NetworkMerchantTeleCheck] ([NetworkMerchantId]) ON [PRIMARY]
GO
