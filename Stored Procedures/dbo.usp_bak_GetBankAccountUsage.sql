SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_bak_GetBankAccountUsage]
@UserId           bigint,
@BankAccountId    bigint
AS
BEGIN
  SET NOCOUNT ON
  
  DECLARE @Source SourceTABLE
  INSERT INTO @Source EXEC dbo.usp_upm_GetObjectIds @UserId,1,1

  SELECT @BankAccountId BankAccountId,1 SourceType,a.DeviceId SourceId,b.TerminalName+' '+b.Location SourceDesc,'Vault Cash Account' UsageTypeDesc
  FROM dbo.tbl_DeviceToSettlementAccount a JOIN dbo.tbl_Device b ON a.DeviceId=b.Id
  WHERE a.DeviceId IN (SELECT Id FROM @Source) AND a.BankAccountId=@BankAccountId AND a.StartDate<=GETUTCDATE() AND a.Enddate>GETUTCDATE() AND b.DeviceStatus IN (1,2,3)
  UNION ALL
  SELECT @BankAccountId BankAccountId,1 SourceType,a.DeviceId SourceId,b.TerminalName+' '+b.Location SourceDesc,'Vault Cash Override Account -'+CASE WHEN a.OverrideType=1 THEN 'TransactionType '+dbo.udf_GetValueName(19,a.OverrideData) ELSE '' END UsageTypeDesc
  FROM dbo.tbl_DeviceToSettlementAccountOverride a JOIN dbo.tbl_Device b ON a.DeviceId=b.Id
  WHERE a.DeviceId IN (SELECT Id FROM @Source) AND a.BankAccountId=@BankAccountId AND a.StartDate<=GETUTCDATE() AND a.Enddate>GETUTCDATE() AND b.DeviceStatus IN (1,2,3)
  UNION ALL
  SELECT @BankAccountId BankAccountId,1 SourceType,a.DeviceId SourceId,b.TerminalName+' '+b.Location SourceDesc,'Surcharge Account' UsageTypeDesc
  FROM dbo.tbl_DeviceToSurchargeSplitAccount a JOIN dbo.tbl_Device b ON a.DeviceId=b.Id
  WHERE a.DeviceId IN (SELECT Id FROM @Source) AND a.BankAccountId=@BankAccountId AND a.StartDate<=GETUTCDATE() AND a.Enddate>GETUTCDATE() AND b.DeviceStatus IN (1,2,3)
  UNION ALL
  SELECT @BankAccountId BankAccountId,1 SourceType,a.DeviceId SourceId,b.TerminalName+' '+b.Location SourceDesc,'Surcharge Override Account – '+CASE WHEN a.OverrideType=1 THEN 'TransactionType '+dbo.udf_GetValueName(19,a.OverrideData) WHEN a.OverrideType=2 THEN 'IssuerNetworkId '+a.OverrideData ELSE '' END UsageTypeDesc
  FROM dbo.tbl_DeviceToSurchargeSplitAccountOverride a JOIN dbo.tbl_Device b ON a.DeviceId=b.Id
  WHERE a.DeviceId IN (SELECT Id FROM @Source) AND a.BankAccountId=@BankAccountId AND a.StartDate<=GETUTCDATE() AND a.Enddate>GETUTCDATE() AND b.DeviceStatus IN (1,2,3)
  UNION ALL
  SELECT @BankAccountId BankAccountId,1 SourceType,a.DeviceId SourceId,b.TerminalName+' '+b.Location SourceDesc,'Interchange for Code: '++dbo.udf_GetValueName(11,Recipient) UsageTypeDesc
  FROM dbo.tbl_DeviceToInterchangeSplitAccount a JOIN dbo.tbl_Device b ON a.DeviceId=b.Id
  WHERE a.DeviceId IN (SELECT Id FROM @Source) AND a.BankAccountId=@BankAccountId AND a.StartDate<=GETUTCDATE() AND a.Enddate>GETUTCDATE() AND b.DeviceStatus IN (1,2,3)
  UNION ALL
  SELECT @BankAccountId BankAccountId,SourceType,SourceId,b.TerminalName+' '+b.Location SourceDesc,'Scheduled Fee Debit: '+dbo.udf_GetValueName(11,ScheduleType) UsageTypeDesc
  FROM dbo.tbl_AchSchedule a JOIN dbo.tbl_Device b ON a.SourceType=1 AND a.SourceId=b.Id
  WHERE a.SourceId IN (SELECT Id FROM @Source) AND a.SourceBankAccountId=@BankAccountId AND a.StartDate<=GETUTCDATE() AND a.Enddate>GETUTCDATE() AND a.AchScheduleStatus=1 AND b.DeviceStatus IN (1,2,3)
  UNION ALL
  SELECT @BankAccountId BankAccountId,SourceType,SourceId,b.TerminalName+' '+b.Location SourceDesc,'Scheduled Credit Debit: '+dbo.udf_GetValueName(11,ScheduleType) UsageTypeDesc
  FROM dbo.tbl_AchSchedule a JOIN dbo.tbl_Device b ON a.SourceType=1 AND a.SourceId=b.Id
  WHERE a.SourceId IN (SELECT Id FROM @Source) AND a.DestinationBankAccountId=@BankAccountId AND a.StartDate<=GETUTCDATE() AND a.Enddate>GETUTCDATE() AND a.AchScheduleStatus=1 AND b.DeviceStatus IN (1,2,3)
 
END
GO
