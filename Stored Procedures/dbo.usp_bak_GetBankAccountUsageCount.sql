SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_bak_GetBankAccountUsageCount]
@BankAccountId bigint,
@Count         bigint out
AS
BEGIN
  SET NOCOUNT ON
  
  DECLARE @Count1 bigint,@Count2 bigint,@Count3 bigint,@Count4 bigint,@Count5 bigint,@Count6 bigint,@Count7 bigint
  
  SELECT @Count1=COUNT(*)
  FROM dbo.tbl_DeviceToSettlementAccount a JOIN dbo.tbl_Device b ON a.DeviceId=b.Id
  WHERE a.BankAccountId=@BankAccountId AND a.StartDate<=GETUTCDATE() AND a.Enddate>GETUTCDATE() AND b.DeviceStatus IN (1,2,3)
  
  SELECT @Count2=COUNT(*)
  FROM dbo.tbl_DeviceToSettlementAccountOverride a JOIN dbo.tbl_Device b ON a.DeviceId=b.Id
  WHERE a.BankAccountId=@BankAccountId AND a.StartDate<=GETUTCDATE() AND a.Enddate>GETUTCDATE() AND b.DeviceStatus IN (1,2,3)

  SELECT @Count3=COUNT(*)
  FROM dbo.tbl_DeviceToSurchargeSplitAccount a JOIN dbo.tbl_Device b ON a.DeviceId=b.Id
  WHERE a.BankAccountId=@BankAccountId AND a.StartDate<=GETUTCDATE() AND a.Enddate>GETUTCDATE() AND b.DeviceStatus IN (1,2,3)
  
  SELECT @Count4=COUNT(*)
  FROM dbo.tbl_DeviceToSurchargeSplitAccountOverride a JOIN dbo.tbl_Device b ON a.DeviceId=b.Id
  WHERE a.BankAccountId=@BankAccountId AND a.StartDate<=GETUTCDATE() AND a.Enddate>GETUTCDATE() AND b.DeviceStatus IN (1,2,3)
  
  SELECT @Count5=COUNT(*)
  FROM dbo.tbl_DeviceToInterchangeSplitAccount a JOIN dbo.tbl_Device b ON a.DeviceId=b.Id
  WHERE a.BankAccountId=@BankAccountId AND a.StartDate<=GETUTCDATE() AND a.Enddate>GETUTCDATE() AND b.DeviceStatus IN (1,2,3)
  
  SELECT @Count6=COUNT(*)
  FROM dbo.tbl_AchSchedule a JOIN dbo.tbl_Device b ON a.SourceType=1 AND a.SourceId=b.Id
  WHERE a.SourceBankAccountId=@BankAccountId AND a.StartDate<=GETUTCDATE() AND a.Enddate>GETUTCDATE() AND a.AchScheduleStatus=1 AND b.DeviceStatus IN (1,2,3)
  
  SELECT @Count7=COUNT(*)
  FROM dbo.tbl_AchSchedule a JOIN dbo.tbl_Device b ON a.SourceType=1 AND a.SourceId=b.Id
  WHERE a.DestinationBankAccountId=@BankAccountId AND a.StartDate<=GETUTCDATE() AND a.Enddate>GETUTCDATE() AND a.AchScheduleStatus=1 AND b.DeviceStatus IN (1,2,3)
 
  SET @Count=@Count1+@Count2+@Count3+@Count4+@Count5+@Count6+@Count7
  
  RETURN 0
END
GO
