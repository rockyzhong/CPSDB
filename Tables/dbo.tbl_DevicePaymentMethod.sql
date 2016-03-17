CREATE TABLE [dbo].[tbl_DevicePaymentMethod]
(
[Id] [bigint] NOT NULL IDENTITY(1, 2) NOT FOR REPLICATION,
[DeviceId] [bigint] NOT NULL,
[PaymentId] [bigint] NOT NULL,
[IsEnabled] [bit] NOT NULL,
[UpdatedDate] [datetime] NULL,
[UpdatedUserId] [bigint] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tbl_DevicePaymentMethod] ADD CONSTRAINT [pk_DevicePaymentMethod] PRIMARY KEY CLUSTERED  ([Id]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx__DevicePaymentMethod_DeviceIdPaymentId] ON [dbo].[tbl_DevicePaymentMethod] ([DeviceId], [PaymentId]) ON [PRIMARY]
GO
