SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[usp_dev_GetDeviceFees] 
  @DeviceId   bigint
AS
BEGIN 
  SELECT Id DeviceFeeId,DeviceId,IsoId,FeeType,StartDate,EndDate,AmountFrom,AmountTo,FeeFixed,FeePercentage,FeeAddedPercentage 
  FROM dbo.tbl_DeviceFee WHERE DeviceId=@DeviceId
  

  RETURN 0
END
GO
GRANT EXECUTE ON  [dbo].[usp_dev_GetDeviceFees] TO [WebV4Role]
GO
