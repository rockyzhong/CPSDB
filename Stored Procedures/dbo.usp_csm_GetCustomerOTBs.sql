SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_csm_GetCustomerOTBs]
@CustomerId bigint
AS
BEGIN
  SELECT TOP 1 Id CustomerOTBId,CustomerId,MerchantId,TransactionClass,FullMICR,OTBLimit,CustomerLimit,ActiveStatus,EnrollmentType,EnrollmentDate 
  FROM dbo.tbl_CustomerOTB 
  WHERE CustomerId=@CustomerId AND TransactionClass='OTB'
  ORDER BY EnrollmentDate DESC  
END
GO
GRANT EXECUTE ON  [dbo].[usp_csm_GetCustomerOTBs] TO [WebV4Role]
GO
