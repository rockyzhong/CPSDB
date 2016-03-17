SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[usp_iso_GetIsoFees] 
@IsoId   bigint
AS
BEGIN 
  SELECT Id DeviceFeeId,DeviceId,IsoId,FeeType,StartDate,EndDate,AmountFrom,AmountTo,FeeFixed,FeePercentage,FeeAddedPercentage 
  FROM dbo.tbl_DeviceFee WHERE IsoId=@IsoId
  ORDER BY FeeType,AmountFrom
END
GO
GRANT EXECUTE ON  [dbo].[usp_iso_GetIsoFees] TO [WebV4Role]
GO
