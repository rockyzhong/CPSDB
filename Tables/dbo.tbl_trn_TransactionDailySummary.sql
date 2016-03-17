CREATE TABLE [dbo].[tbl_trn_TransactionDailySummary]
(
[Id] [bigint] NOT NULL IDENTITY(1, 2) NOT FOR REPLICATION,
[SystemSettlementDate] [datetime] NULL,
[DeviceId] [bigint] NULL,
[TerminalName] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DeviceSequenceRange] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DispensedAmount] [money] NULL,
[SurchargeAmount] [money] NULL,
[SettlementAmount] [money] NULL,
[InterchangeAmount] [money] NULL,
[TotalAmount] [money] NULL,
[TotalCount] [bigint] NULL,
[ApprovedCount] [bigint] NULL,
[ApprovedDispensedCount] [bigint] NULL,
[ApprovedSurchargedCount] [bigint] NULL,
[ApprovedInquryCount] [bigint] NULL,
[ApprovedTransferCount] [bigint] NULL,
[DeclinedCount] [bigint] NULL,
[DeclinedDispensedCount] [bigint] NULL,
[DeclinedInquryCount] [bigint] NULL,
[DeclinedTransferCount] [bigint] NULL,
[Interac] [bigint] NULL,
[BMO] [bigint] NULL,
[Circuit] [bigint] NULL,
[CirrusDom] [bigint] NULL,
[CirrusIntl] [bigint] NULL,
[PlUSDom] [bigint] NULL,
[PLUSIntl] [bigint] NULL,
[VISADom] [bigint] NULL,
[VISAIntl] [bigint] NULL,
[STAR] [bigint] NULL,
[ChinaUnionPay] [bigint] NULL,
[Other] [bigint] NULL,
[DeclinedPercent] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TerminalApprovedDispensedPercent] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tbl_trn_TransactionDailySummary] ADD CONSTRAINT [pk_TransactionDailySummary] PRIMARY KEY NONCLUSTERED  ([Id]) WITH (FILLFACTOR=80, PAD_INDEX=ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_TransactionDailySummary_SystemSettlementDate_DeviceId] ON [dbo].[tbl_trn_TransactionDailySummary] ([SystemSettlementDate], [DeviceId]) WITH (FILLFACTOR=80, PAD_INDEX=ON) ON [PRIMARY]
GO
