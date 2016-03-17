CREATE TABLE [dbo].[tbl_trn_Transactionreconandtrace]
(
[TranId] [bigint] NOT NULL,
[ReconciliationStatus] [bigint] NULL CONSTRAINT [DF_tbl_trn_Transactionreconandtrace_ReconciliationStatus] DEFAULT ((1)),
[UnreconciledStatus] [bigint] NULL,
[ReconciliationComment] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TraceInitiator] [bigint] NULL,
[TraceOpenedDate] [datetime] NULL,
[TraceOpenedUserId] [bigint] NULL,
[TraceReopenedDate] [datetime] NULL,
[TraceReopenedUserId] [bigint] NULL,
[TraceDueDate] [datetime] NULL,
[TraceClosedDate] [datetime] NULL,
[TraceClosedUserId] [bigint] NULL,
[TraceStatus] [bigint] NULL,
[TraceDispensedStatus] [bigint] NULL,
[TraceBankNo] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TraceBankClaimNo] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TraceCreditDate] [datetime] NULL,
[TraceCreditAmount] [money] NULL,
[TraceTranmissionType] [bigint] NULL,
[TraceMailAddress] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TraceLetterComment] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TraceInternalComment] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
