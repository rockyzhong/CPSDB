CREATE TABLE [dbo].[tbl_IsoPaymentMethod]
(
[Id] [bigint] NOT NULL IDENTITY(1, 2) NOT FOR REPLICATION,
[IsoId] [bigint] NOT NULL,
[PaymentId] [bigint] NOT NULL,
[DisplayName] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[DefaultEnabled] [bit] NOT NULL,
[UpdatedDate] [datetime] NULL,
[UpdatedUserId] [bigint] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tbl_IsoPaymentMethod] ADD CONSTRAINT [pk_IsoPaymentMethod] PRIMARY KEY CLUSTERED  ([Id]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_IsoPaymentMethod_IsoIdPaymentId] ON [dbo].[tbl_IsoPaymentMethod] ([IsoId], [PaymentId]) ON [PRIMARY]
GO
