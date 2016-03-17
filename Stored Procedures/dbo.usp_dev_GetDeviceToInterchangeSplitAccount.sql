SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_dev_GetDeviceToInterchangeSplitAccount] 
  @DeviceId                      bigint
AS
BEGIN
  SET NOCOUNT ON
  
  SELECT a.Id DeviceToInterchangeSplitAccountId,a.DeviceId,a.Recipient,a.SplitType,CASE WHEN a.SplitType IN (0,1) THEN SplitData ELSE 0 END SplitData,
         b.Id BankAccountId,b.HolderName,b.Rta
  FROM dbo.tbl_DeviceToInterchangeSplitAccount a JOIN dbo.tbl_BankAccount b ON a.BankAccountId=b.Id
  WHERE DeviceId=@DeviceId AND EndDate=CONVERT(datetime,'39991231',112)

  RETURN 0
END
GO
GRANT EXECUTE ON  [dbo].[usp_dev_GetDeviceToInterchangeSplitAccount] TO [WebV4Role]
GO
