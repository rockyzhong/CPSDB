CREATE TABLE [dbo].[tbl_CashLoadHistory]
(
[id] [bigint] NOT NULL IDENTITY(1, 2) NOT FOR REPLICATION,
[DeviceId] [bigint] NOT NULL,
[CassetteId] [bigint] NOT NULL,
[ReplenishmentDate] [datetime] NOT NULL,
[ReplenishmentCount] [bigint] NOT NULL,
[Currency] [bigint] NOT NULL,
[MediaCode] [bigint] NOT NULL,
[MediaValue] [bigint] NOT NULL,
[OldCount] [bigint] NULL CONSTRAINT [DF__tbl_CashL__OldCo__3612CF1C] DEFAULT ((0)),
[UpdatedUserId] [bigint] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tbl_CashLoadHistory] ADD CONSTRAINT [pk_CashLoadHistory] PRIMARY KEY NONCLUSTERED  ([id]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_CashLoadHistory_DeviceId] ON [dbo].[tbl_CashLoadHistory] ([DeviceId]) ON [PRIMARY]
GO
