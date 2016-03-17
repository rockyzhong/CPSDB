SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_set_ACHEntryHistory_Get]
@pSettlementDate datetime,
@pACHFileID int
AS
-- Retrieve ACH Settlement Data for a Settlement date
--
-- Revision 1.0.0 2011.03.24 by Adam Glover
--   Initial Revision
SELECT [PayoutDate]
      ,[AchFileId]
      ,[AchFileNumber]
      ,[BankAccountHolderName]
      ,[BankAccountType]
      ,[BankAccountRta]
      ,[Amount]
      ,[BatchHeader]
      ,[ReferenceName]
      ,[DueDate]
      ,[AddendaTypeCode]
      ,[AddendaData]
      ,[SettlementStatus]
FROM [dbo].[tbl_AchEntryHistory]
WHERE SettlementDate BETWEEN @pSettlementDate and dateadd(hour, 23, @pSettlementDate)
  AND ACHFileID = @pACHFileID
ORDER BY [BatchHeader], [BankAccountHolderName], [BankAccountRta], [ReferenceName]
GO
