SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_csm_GetCustomerACHs] 
@CustomerId bigint,
@FullMICR   nvarchar(25)
AS
BEGIN
  SELECT Id CustomerOTBId,CustomerId,MerchantId,TransactionClass,FullMICR,OTBLimit,CustomerLimit,ActiveStatus,EnrollmentType,EnrollmentDate 
  FROM dbo.tbl_CustomerOTB 
  WHERE CustomerId=@CustomerId AND FullMICR=@FullMICR AND TransactionClass='ACH'
END
GO
GRANT EXECUTE ON  [dbo].[usp_csm_GetCustomerACHs] TO [WebV4Role]
GO
