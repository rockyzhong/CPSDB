CREATE TABLE [dbo].[tbl_MonthEndBilling_ExchangeRate]
(
[Id] [bigint] NOT NULL IDENTITY(1, 2) NOT FOR REPLICATION,
[FromCurrencyCode] [int] NOT NULL,
[ToCurrencyCode] [int] NOT NULL,
[ExchangeRate] [money] NOT NULL,
[UpdatedUserId] [bigint] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tbl_MonthEndBilling_ExchangeRate] ADD CONSTRAINT [pk_MonthEndBilling_ExchangeRate] PRIMARY KEY NONCLUSTERED  ([Id]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_MonthEndBilling_ExchangeRate_FromCurrencyCode_ToCurrencyCode] ON [dbo].[tbl_MonthEndBilling_ExchangeRate] ([FromCurrencyCode], [ToCurrencyCode]) ON [PRIMARY]
GO
