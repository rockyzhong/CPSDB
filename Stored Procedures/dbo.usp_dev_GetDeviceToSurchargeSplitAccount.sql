SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_dev_GetDeviceToSurchargeSplitAccount] 
  @DeviceId                      bigint
AS
BEGIN
  SET NOCOUNT ON
  
  SELECT a.Id DeviceToSurchargeSplitAccountId,a.DeviceId,a.SplitType,CASE WHEN a.SplitType IN (0,1) THEN SplitData ELSE 0 END SplitData,
         b.Id BankAccountId,b.HolderName,b.Rta
  FROM dbo.tbl_DeviceToSurchargeSplitAccount a JOIN dbo.tbl_BankAccount b ON a.BankAccountId=b.Id
  WHERE DeviceId=@DeviceId AND EndDate=CONVERT(datetime,'39991231',112)

  RETURN 0
END
GO
GRANT EXECUTE ON  [dbo].[usp_dev_GetDeviceToSurchargeSplitAccount] TO [WebV4Role]
GO
