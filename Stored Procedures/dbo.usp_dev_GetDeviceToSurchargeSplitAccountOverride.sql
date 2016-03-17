SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_dev_GetDeviceToSurchargeSplitAccountOverride]
@DeviceId bigint
AS
BEGIN
  DECLARE @Date datetime
  SET @Date = GETUTCDATE()

  SELECT o.Id DeviceToSurchargeSplitAccountOverrideId,o.DeviceId,o.StartDate,o.EndDate,o.SplitType,CASE WHEN o.SplitType IN (0,1) THEN SplitData ELSE 0 END SplitData,
         o.OverrideType,o.OverrideData,o.OverridePriority,
         b.Id BankAccountId,b.HolderName,b.Rta,b.BankAccountType,b.BankAccountStatus
  FROM dbo.tbl_DeviceToSurchargeSplitAccountOverride o
  JOIN dbo.tbl_BankAccount b ON o.BankAccountId=b.Id
  WHERE o.DeviceId=@DeviceId AND o.StartDate<=@Date AND o.EndDate>@Date
  ORDER BY o.OverridePriority,o.OverrideType,o.OverrideData
END
GO
GRANT EXECUTE ON  [dbo].[usp_dev_GetDeviceToSurchargeSplitAccountOverride] TO [WebV4Role]
GO
