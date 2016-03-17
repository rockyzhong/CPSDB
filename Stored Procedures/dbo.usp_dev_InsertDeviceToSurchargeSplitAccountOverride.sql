SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_dev_InsertDeviceToSurchargeSplitAccountOverride]
@DeviceId         bigint,
@BankAccountId    bigint,
@SplitType        bigint,
@SplitData        bigint,
@OverrideType     bigint,
@OverrideData     nvarchar(30),
@OverridePriority bigint,
@Date             datetime,
@UpdatedUserId    bigint
AS
BEGIN
  SET NOCOUNT ON

  DECLARE @StartDate datetime,@EndDate datetime
  SET @EndDate=CONVERT(datetime,'39991231',112)

  IF NOT EXISTS (SELECT * FROM dbo.tbl_DeviceToSurchargeSplitAccountOverride WHERE DeviceId=@DeviceId AND OverrideType=@OverrideType AND OverrideData=@OverrideData)
    SET @StartDate = CONVERT(datetime, '19000101',112)
  ELSE IF @Date <= dateadd(n, 10, GETUTCDATE())
    SET @StartDate=DATEADD(day,-5,@Date)
  ELSE
    SET @StartDate=@Date

  INSERT INTO dbo.tbl_DeviceToSurchargeSplitAccountOverride(DeviceId,BankAccountId,StartDate,EndDate,SplitType,SplitData,OverrideType,OverrideData,OverridePriority,UpdatedUserId)
  VALUES(@DeviceId,@BankAccountId,@StartDate,@EndDate,@SplitType,
  CASE WHEN @SplitType=0 or @SplitType=1 THEN @SplitData ELSE 0 END,@OverrideType,@OverrideData,@OverridePriority,@UpdatedUserId)
  
  RETURN 0
END
GO
GRANT EXECUTE ON  [dbo].[usp_dev_InsertDeviceToSurchargeSplitAccountOverride] TO [WebV4Role]
GO
